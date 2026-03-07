# Implementation Plan: Advanced Color Editor

## Phase 1: Data Model & Kernels (ImageCore)
- [x] Task: Reconstruct `IC_ColorCorrection` structure.
- [x] Task: Update `IC_ProcessSettings` to support an array of color corrections.
- [x] Task: Implement `ColorCorrectionKernels` (HSL conversion and targeting).
- [x] Task: Commit Phase 1.

## Phase 2: Controller State (CaptureOneUI)
- [x] Task: Update `AdjustmentToolController` to manage the list of `ColorCorrection` items.
- [x] Task: Implement serialization/deserialization to `MCVariant` (or JSON string if complex).
- [x] Task: Commit Phase 2.

## Phase 3: UI Components (CaptureOneUI)
- [x] Task: Reconstruct `AdvancedColorEditorView` with the basic list and sliders.
- [x] Task: Integrate into `CullingWindowController` under the COLOR tab.
- [x] Task: Commit Phase 3.