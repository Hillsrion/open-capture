#include <metal_stdlib>
using namespace metal;

struct ComputeLUTParams {
    float exposure;
    float contrast;
    float brightness;
    float saturation;
    
    struct ColorBalanceValue {
        float hue;
        float saturation;
        float brightness;
    };
    
    ColorBalanceValue shadow;
    ColorBalanceValue midtone;
    ColorBalanceValue highlight;
    ColorBalanceValue master;
    
    struct ColorCorrection {
        float hueRotation;
        float saturationChange;
        float lightnessChange;
        float lowHue;
        float highHue;
        float lowSaturation;
        float highSaturation;
        float homogeneityHue;
        float homogeneitySaturation;
        float homogeneityLightness;
    };
    
    int correctionCount;
    ColorCorrection corrections[16];
};

static float3 rgbToHsl(float3 rgb) {
    float maxV = max(rgb.r, max(rgb.g, rgb.b));
    float minV = min(rgb.r, min(rgb.g, rgb.b));
    float delta = maxV - minV;
    
    float h = 0.0;
    float s = 0.0;
    float l = (maxV + minV) / 2.0;
    
    if (delta > 0.0001) {
        s = l > 0.5 ? delta / (2.0 - maxV - minV) : delta / (maxV + minV);
        
        if (maxV == rgb.r) {
            h = (rgb.g - rgb.b) / delta + (rgb.g < rgb.b ? 6.0 : 0.0);
        } else if (maxV == rgb.g) {
            h = (rgb.b - rgb.r) / delta + 2.0;
        } else {
            h = (rgb.r - rgb.g) / delta + 4.0;
        }
        h /= 6.0;
    }
    
    return float3(h, s, l);
}

static float hueToRgb(float t1, float t2, float t3) {
    float t = t3;
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0/6.0) return t1 + (t2 - t1) * 6.0 * t;
    if (t < 1.0/2.0) return t2;
    if (t < 2.0/3.0) return t1 + (t2 - t1) * (2.0/3.0 - t) * 6.0;
    return t1;
}

static float3 hslToRgb(float3 hsl) {
    float h = hsl.x;
    float s = hsl.y;
    float l = hsl.z;
    
    if (s == 0.0) {
        return float3(l, l, l);
    }
    
    float q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
    float p = 2.0 * l - q;
    
    float r = hueToRgb(p, q, h + 1.0/3.0);
    float g = hueToRgb(p, q, h);
    float b = hueToRgb(p, q, h - 1.0/3.0);
    
    return float3(r, g, b);
}

static float3 applyColorCorrections(float3 rgb, ComputeLUTParams params) {
    if (params.correctionCount <= 0) return rgb;
    
    for (int i = 0; i < params.correctionCount; ++i) {
        ComputeLUTParams::ColorCorrection corr = params.corrections[i];
        
        float3 hsl = rgbToHsl(rgb);
        float h = hsl.x;
        float s = hsl.y;
        float l = hsl.z;
        
        bool inRange = false;
        if (corr.lowHue < corr.highHue) {
            inRange = (h >= corr.lowHue && h <= corr.highHue);
        } else {
            inRange = (h >= corr.lowHue || h <= corr.highHue);
        }
        
        if (inRange && s >= corr.lowSaturation && s <= corr.highSaturation) {
            float weight = 1.0;
            
            h += (corr.hueRotation / 360.0) * weight;
            if (h > 1.0) h -= 1.0;
            if (h < 0.0) h += 1.0;
            
            s += (corr.saturationChange / 100.0) * weight;
            s = clamp(s, 0.0, 1.0);
            
            l += (corr.lightnessChange / 100.0) * weight;
            l = clamp(l, 0.0, 1.0);
            
            float targetHue = (corr.lowHue + corr.highHue) / 2.0;
            float hueDiff = h - targetHue;
            h -= hueDiff * (corr.homogeneityHue / 100.0) * weight;
            
            float targetSat = (corr.lowSaturation + corr.highSaturation) / 2.0;
            float satDiff = s - targetSat;
            s -= satDiff * (corr.homogeneitySaturation / 100.0) * weight;
            
            float targetLuma = 0.5;
            float lumaDiff = l - targetLuma;
            l -= lumaDiff * (corr.homogeneityLightness / 100.0) * weight;
        }
        
        rgb = hslToRgb(float3(h, s, l));
    }
    return rgb;
}

static float3 applyRegionAdjustment(float3 rgb, float weight, ComputeLUTParams::ColorBalanceValue val) {
    if (weight <= 0.0) return rgb;
    
    // Convert polar (Hue/Sat) to RGB offset
    float radians = (val.hue - 90.0) * M_PI_F / 180.0;
    float strength = (val.saturation / 100.0) * weight;
    
    float dr = cos(radians) * strength;
    float dg = sin(radians) * strength;
    float db = -0.5 * strength; // Simplified luminance-preserving blue offset
    
    float3 offset = float3(dr, dg, db);
    rgb += offset;
    
    // Apply brightness/luminance
    float brightShift = (val.brightness / 100.0) * weight;
    rgb += float3(brightShift);
    
    return rgb;
}

static float3 applyColorBalance(float3 rgb, ComputeLUTParams params) {
    float luma = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
    
    // 1. Calculate weights for each region
    float shadowWeight = pow(max(0.0, 1.0 - luma), 2.0);
    float highlightWeight = pow(max(0.0, luma), 2.0);
    float midtoneWeight = 1.0 - shadowWeight - highlightWeight;
    
    // 2. Apply adjustments per region
    rgb = applyRegionAdjustment(rgb, shadowWeight, params.shadow);
    rgb = applyRegionAdjustment(rgb, midtoneWeight, params.midtone);
    rgb = applyRegionAdjustment(rgb, highlightWeight, params.highlight);
    rgb = applyRegionAdjustment(rgb, 1.0, params.master); // Master applies to all
    
    return rgb;
}

static float sampleCurve(texture1d<float, access::sample> tex, float value) {
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    return tex.sample(s, value).r;
}

kernel void compute_3d_lut(
    texture3d<float, access::write> outTexture [[texture(0)]],
    constant ComputeLUTParams &params [[buffer(0)]],
    texture1d<float, access::sample> curveX [[texture(1)]],
    texture1d<float, access::sample> curveL [[texture(2)]],
    texture1d<float, access::sample> curveR [[texture(3)]],
    texture1d<float, access::sample> curveG [[texture(4)]],
    texture1d<float, access::sample> curveB [[texture(5)]],
    uint3 gid [[thread_position_in_grid]]
) {
    if (gid.x >= outTexture.get_width() || gid.y >= outTexture.get_height() || gid.z >= outTexture.get_depth()) {
        return;
    }
    
    float3 rgb = float3(gid) / float3(outTexture.get_width() - 1, outTexture.get_height() - 1, outTexture.get_depth() - 1);
    
    // 1. Exposure
    rgb *= pow(2.0, params.exposure);
    
    // 2. Contrast & Brightness
    rgb = (rgb - 0.5) * params.contrast + 0.5 + params.brightness;
    
    // 3. Color Balance
    rgb = applyColorBalance(rgb, params);
    
    // 4. Curves
    rgb.r = sampleCurve(curveX, rgb.r);
    rgb.g = sampleCurve(curveX, rgb.g);
    rgb.b = sampleCurve(curveX, rgb.b);
    
    float luma = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
    float mappedLuma = sampleCurve(curveL, luma);
    if (luma > 0.0001) {
        rgb *= (mappedLuma / luma);
    } else {
        rgb = float3(mappedLuma);
    }
    
    rgb.r = sampleCurve(curveR, rgb.r);
    rgb.g = sampleCurve(curveG, rgb.g);
    rgb.b = sampleCurve(curveB, rgb.b);
    
    // 4.5 Color Corrections
    rgb = applyColorCorrections(rgb, params);
    
    // 5. Saturation
    luma = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
    rgb = luma + (rgb - luma) * params.saturation;
    
    outTexture.write(float4(clamp(rgb, 0.0, 1.0), 1.0), gid);
}
