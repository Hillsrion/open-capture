# Implementation Plan: Layers & Masking Restoration

## Phase 1: Data Model (AppCoreShared)
- [x] Task: Reconstruct `LayerBase` model.
- [x] Task: Update `VariantBase` to support multiple layers.
- [x] Task: Update `MCVariant` synchronization logic for layers.
- [x] Task: Commit Phase 1: Layer Data Model.

## Phase 2: UI Components (CaptureOneUI)
- [x] Task: Reconstruct `LayerInspectorView` (stack of layers with icons).
- [x] Task: Implement layer selection and property editing (opacity, visibility).
- [x] Task: Add "Add Adjustment Layer" functionality.
- [x] Task: Commit Phase 2: Layer UI.

## Phase 3: Blending Engine (ImageCore)
- [x] Task: Reconstruct mask representation in `ImageCore`.
- [x] Task: Implement alpha-blending kernel in `ImageCorePipeline`.
- [x] Task: Update `IC_ProcessSettings` to accept a stack of adjustments.
- [x] Task: Commit Phase 3: Blending Logic.

## Phase 4: Integration & Validation
- [ ] Task: Bind UI layer selection to adjustment tools (adjusting a layer instead of background).
- [ ] Task: Verify end-to-end multi-layer adjustments.
- [ ] Task: Commit Phase 4: Finalization.
