# Specification: Full Restoration of Adjustment Tools (Exposure, Contrast, WB, HDR)

## Overview
This track focuses on the deep reconstruction of Capture One's core adjustment engine. We will restore the mathematical logic for basic image manipulations (Exposure, Contrast, Saturation, Brightness), the White Balance system (Kelvin/Tint), and the HDR tool (Highlight/Shadow recovery), ensuring 100% behavioral fidelity with the original processing engine.

## Functional Requirements
- **Exposure & Basic Adjustments:** Reconstruct the mathematical kernels for `Exposure`, `Contrast`, `Brightness`, and `Saturation`.
- **White Balance System:** Restore the logic for mapping RAW sensor data to Kelvin and Tint, including inferred Auto-WB algorithms.
- **High Dynamic Range (HDR):** Reconstruct the logic for non-destructive highlight and shadow recovery based on Engine 16.x patterns.
- **UI Integration:** Implement the corresponding tool views in `CaptureOneUI`, including sliders, input fields, and real-time histogram feedback.
- **Model Binding:** Ensure that UI changes correctly update the `MCVariant` settings and trigger the `ImageCorePipeline` for live preview updates.

## Non-Functional Requirements
- **Processing Performance:** Ensure mathematical operations are optimized using Accelerate/SIMD or Metal where appropriate.
- **Real-time Feedback:** UI sliders must provide near-instantaneous feedback in the `COViewerView`.
- **High Fidelity:** Reconstructed logic must match the original application's output characteristics.

## Acceptance Criteria
- Functional sliders for Exposure, Contrast, WB, and HDR in the UI.
- Moving a slider correctly updates the image in the viewer in real-time.
- Mathematical correctness verified against expected behavioral patterns of the original engine.

## Out of Scope
- Advanced tools like Curves, Levels, or Color Balance (handled in future tracks).
- AI-based "Smart Adjustments".
