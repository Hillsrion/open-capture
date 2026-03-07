# Specification: Cross-Module Integration & Persistence Cleanup

## Overview
This track addresses integration gaps discovered during the consistency review of archived tracks. It focuses on ensuring that newly implemented features (like Lens Correction) are fully integrated into the core models, persistence layer, and UI viewer.

## Functional Requirements
- **AppCore Integration:** Add `canApplyLensCorrection` and related capability checks to `VariantBase`.
- **Persistence:** Update `DatabaseSchema` to include all missing columns for Lens Correction and LCC in `ZVARIANT` and `ZVARIANTLAYER`.
- **GPU Engine:** Implement the actual Metal library loading logic in `ImageCoreGPU.getPipelineState`.
- **Viewer Fidelity:** Update `COViewerView` to include Distortion and Light Falloff simulation in the live preview.
- **Model Completeness:** Refine `IC_ProcessSettings` to better match the discovered binary structure.

## Acceptance Criteria
- Lens Correction settings persist across application restarts (verified via SQLite CRUD tests).
- `VariantBase` exposes the correct capability flags for lens correction.
- `COViewerView` visually reflects changes to Distortion and Light Falloff sliders.
- `ImageCoreGPU` successfully retrieves compute pipeline states from the default Metal library.
