# Implementation Plan: Cross-Module Integration & Persistence Cleanup

## Phase 1: AppCore & DataCore Synchronization
- [x] Task: Implement `canApplyLensCorrection` in `VariantBase`.
- [x] Task: Add Lens Correction columns to `ZVARIANT` and `ZVARIANTLAYER` in `DatabaseSchema`.
- [x] Task: Update `DatabaseReader` and `DatabaseWriter` to handle the new columns.
- [~] Task: Commit Phase 1.

## Phase 2: ImageCore Engine Refinement
- [ ] Task: Implement library loading in `ImageCoreGPU.getPipelineState`.
- [ ] Task: Expand `IC_ProcessSettings` with discovered parameters.
- [ ] Task: Commit Phase 2.

## Phase 3: UI Viewer Fidelity
- [ ] Task: Update `COViewerView` to simulate Distortion using `CIBumpDistortion` or similar.
- [ ] Task: Update `COViewerView` to simulate Light Falloff using `CIVignette`.
- [ ] Task: Verify end-to-end flow from UI slider to Viewer preview.
- [ ] Task: Commit Phase 3.
