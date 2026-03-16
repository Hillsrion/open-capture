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
};

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
    
    // 5. Saturation
    luma = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
    rgb = luma + (rgb - luma) * params.saturation;
    
    outTexture.write(float4(clamp(rgb, 0.0, 1.0), 1.0), gid);
}
