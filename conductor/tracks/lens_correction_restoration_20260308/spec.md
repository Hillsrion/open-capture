# Specification: Restoration of Lens Correction (Distortion, LCC, CA)

## Overview
This track focuses on the deep reconstruction of Capture One's lens correction engine. We will restore the mathematical logic for Distortion correction, Chromatic Aberration (CA) removal, Light Falloff (vignetting) compensation, and the Lens Cast Calibration (LCC) system, ensuring 100% behavioral fidelity with the original processing engine (Engine 16.x).

## Functional Requirements
- **Distortion Correction:** Reconstruct the mathematical kernels for `Distortion` correction (Geometric Distortion, Pincushion/Barrel), including support for both Generic and Profile-based correction.
- **Chromatic Aberration (CA) & Diffraction:** Restore the logic for analyzing and removing longitudinal and lateral chromatic aberrations and correcting for diffraction-related softness.
- **Light Falloff:** Implement the compensation logic for lens-induced vignetting, ensuring smooth gradients and exposure consistency across the frame.
- **Lens Cast Calibration (LCC):** Reconstruct the logic for creating, applying, and managing LCC profiles to correct for color cast and uneven illumination across the sensor.
- **UI Integration:** Implement the corresponding tool views in `CaptureOneUI`, including sliders for Distortion, Sharpness Falloff, Light Falloff, and the LCC tool controls.
- **Model Binding:** Ensure that UI changes correctly update the `MCVariant` settings and trigger the `ImageCorePipeline` for live preview updates.

## Non-Functional Requirements
- **Processing Performance:** Ensure mathematical operations (especially for LCC and CA) are optimized using Metal or Accelerate/SIMD.
- **Real-time Feedback:** UI sliders must provide near-instantaneous feedback in the `COViewerView`.
- **High Fidelity:** Reconstructed logic must match the original application's output characteristics.

## Acceptance Criteria
- Functional sliders for Distortion, Light Falloff, and Sharpness Falloff in the UI.
- Working LCC tool with the ability to "Create LCC" and apply it to images.
- Successful removal of CA and correction of distortion verified against expected behavioral patterns of the original engine.

## Out of Scope
- Keystone correction (handled in AI-003).
- Perspective correction (handled in future tracks).
