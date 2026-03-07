# Implementation Plan: Cross-Module Integration & Persistence Cleanup

## Phase 1: AppCore & DataCore Synchronization
- [x] Task: Implement `canApplyLensCorrection` in `VariantBase`. 0a03f99
- [x] Task: Add Lens Correction columns to `ZVARIANT` and `ZVARIANTLAYER` in `DatabaseSchema`. 0a03f99
- [x] Task: Update `DatabaseReader` and `DatabaseWriter` to handle the new columns. 0a03f99
- [x] Task: Commit Phase 1. 0a03f99

## Phase 2: ImageCore Engine Refinement
- [x] Task: Implement library loading in `ImageCoreGPU.getPipelineState`. 0a03f99
- [x] Task: Expand `IC_ProcessSettings` with discovered parameters. 0a03f99
- [x] Task: Commit Phase 2. 0a03f99

## Phase 3: UI Viewer Fidelity
- [x] Task: Update `COViewerView` to simulate Distortion using `CIBumpDistortion` or similar.
- [x] Task: Update `COViewerView` to simulate Light Falloff using `CIVignette`.
- [x] Task: Verify end-to-end flow from UI slider to Viewer preview.
- [x] Task: Commit Phase 3.
