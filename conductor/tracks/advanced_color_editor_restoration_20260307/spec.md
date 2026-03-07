# Specification: Advanced Color Editor Restoration

## Objective
Reconstruct the Advanced Color Editor and Skin Tone correction. This tool allows selective hue/saturation/lightness targeting and uniformization, a signature feature of Capture One.

## Scope
- **Data Models**:
    - Reconstruct `ColorCorrection` structure to handle Hue, Saturation, Lightness shifts, and Smoothness targeting.
    - Update `IC_ProcessSettings` to support an array of `ColorCorrection` items.
- **Color Kernels**:
    - Implement color targeting logic (HSL conversion, delta application, blending).
- **UI Components**:
    - Create `AdvancedColorEditorView` with the interactive color wheel simulation.
    - Implement sliders for Hue, Saturation, Lightness, and Smoothness.
- **Integration**:
    - Bind the UI to `AdjustmentToolController` and pass down to `ImageCorePipeline`.

## Success Criteria
- [ ] Users can target a specific color range and adjust its HSL values.
- [ ] Multiple color corrections can be applied sequentially.
- [ ] The Skin Tone uniformity logic is implemented (simulated).