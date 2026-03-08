# Specification: Noise Reduction & Sharpening Restoration (ENG-007)

## Overview
This track focuses on the reconstruction of Capture One's detail enhancement engine. We will restore the high-fidelity algorithms for Noise Reduction (Luminance, Color, and Detail preservation) and Sharpening (Amount, Radius, Threshold, and Halo Control). The reconstruction will follow the exact ABI structures discovered in the binary to ensure behavioral and mathematical fidelity.

## Functional Requirements
- **Noise Reduction Engine:**
    - **Luminance NR:** Reconstruct the kernel for reducing luminance grain while preserving edge contrast (based on `AbiLuminance` and `AbiDetails`).
    - **Color NR:** Implement the color noise suppression logic (based on `AbiColor`).
    - **Single Pixel NR:** Restore the "hot pixel" removal algorithm (based on `AbiSinglePixel`).
- **Sharpening Engine:**
    - **Standard Sharpening:** Reconstruct the deconvolution/unsharp mask logic (based on `AbiAmount`, `AbiRadius`, and `AbiThreshold`).
    - **Halo Control:** Implement the artifact suppression logic to prevent "white edges" (based on `AbiHaloControl`).
- **Data Models:** Reconstruct `IC_NoiseReductionSettings` and `IC_SharpeningSettings` mapping to the `MCAdjLayer` persistence keys.
- **Pipeline Integration:** Integrate NR and Sharpening steps into the `ImageCorePipeline` tile-processing loop.

## Non-Functional Requirements
- **Performance:** Mathematical kernels must be optimized using `Accelerate/vDSP` or `Metal` to ensure smooth real-time performance.
- **Accuracy:** The output must match the original application's characteristic rendering of fine details and grain.

## Acceptance Criteria
- Sliders for Luminance, Details, Color, and Single Pixel NR are functional and reflect in the viewer.
- Sharpening sliders (Amount, Radius, Threshold, Halo) correctly enhance image crispness without introducing excessive artifacts.
- Settings are persisted correctly in the `DataCore` database using the `Z` keys.

## Out of Scope
- Diffraction correction (handled in Lens Correction track).
- Film Grain procedural generation (handled in `ENG-008`).
