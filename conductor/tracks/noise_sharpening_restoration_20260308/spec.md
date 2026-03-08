# Specification: Film Grain Generator Restoration (ENG-008)

## Overview
This track focuses on the reconstruction of Capture One's procedural film grain engine. Unlike simple static overlays, Capture One generates grain dynamically based on image content and user parameters, ensuring a realistic, organic look that responds to luminance. The reconstruction will include the mathematical kernels, the integration into the ImageCore pipeline, and the UI controls.

## Functional Requirements
- **Procedural Grain Engine:**
    - **Noise Generation:** Reconstruct the procedural noise algorithm (likely based on Perlin or simplex noise) that generates grain on the GPU.
    - **Luminance Response:** Implement logic where grain visibility and intensity vary based on the underlying image luminance (e.g., more visible in midtones).
- **Adjustable Parameters:**
    - **Amount:** Overall strength of the grain effect.
    - **Density:** Controls the number of grain particles.
    - **Granularity:** Controls the size and "clumpiness" of the grain.
- **Film Types:** Reconstruct the predefined grain profiles:
    - **Fine Grain:** Small, subtle particles.
    - **Silver Rich:** Larger, higher contrast grain.
    - **Soft Grain:** Blurred, organic texture.
    - **Cubic:** Modern, digital-style noise.
- **ImageCore Integration:** Update `IC_ProcessSettings` to include `IC_FilmGrainSettings` and integrate the grain application into the final rendering stage.
- **UI Interaction:** Reconstruct the Film Grain tool in the inspector with sliders and a type selector.

## Non-Functional Requirements
- **Performance:** Grain generation must be performant enough for real-time preview in the viewer.
- **Determinism:** The grain pattern must be stable for a given seed and parameter set to ensure consistent output.

## Acceptance Criteria
- Visually realistic grain that responds to the `Amount`, `Density`, and `Granularity` sliders.
- Support for different film grain types with distinct visual characteristics.
- Correct integration into the `AdjustmentToolController` and viewer rendering.
- Grain is applied after all other adjustments but before final sharpening/output.

## Out of Scope
- AI-based noise reduction (handled in `ENG-007`).
- Textural overlays from external image files.
