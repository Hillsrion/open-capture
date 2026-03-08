# Implementation Plan: Soft Proofing Engine Restoration

## Objective
Reconstruct the Soft Proofing Engine (ENG-011), enabling the simulation of output ICC profiles (print/web) within the viewer to ensure color accuracy before export.

## Key Files & Context
- `ImageCore/ICCManager.swift`: New manager for loading and caching ICC profiles.
- `ImageCore/SoftProofingKernel.swift`: Metal/CI kernel for color space transformation.
- `CaptureOneUI/COViewerView.swift`: Integrate soft proofing toggle and profile selection.
- `AppCoreShared/ExportModels.swift`: Link export recipes to soft proofing profiles.

## Implementation Steps

### Phase 1: ICC Profile Management (ImageCore / AppCoreShared)
- [x] Task: Reconstruct `ICCProfile` model and `ICCManager`. fc89679
- [x] Task: Implement loading of system ICC profiles (sRGB, Adobe RGB, ProPhoto, CMYK). fc89679
- [x] Task: Implement profile caching logic for high-performance switching. fc89679
- [x] Task: Commit Phase 1 & Build Check. fc89679

### Phase 2: Soft Proofing Logic (ImageCore)
- [x] Task: Implement the `SoftProofingKernel` using `CoreImage`'s `colorSpace` transformations. fc89680
- [x] Task: Implement Gamut Warning logic (highlighting out-of-gamut colors in neon). fc89680
- [x] Task: Add `isSoftProofingEnabled` and `targetProfile` to `IC_ProcessSettings`. fc89680
- [x] Task: Commit Phase 2 & Build Check. fc89680

### Phase 3: UI Integration (CaptureOneUI)
- [x] Task: Add Soft Proofing toggle to the `MainToolbarView`. fc89681
- [x] Task: Implement a profile picker in the `Viewer` or `Export` tab. fc89681
- [x] Task: Update `COViewerView` to apply the proofing kernel if enabled. fc89681
- [x] Task: Commit Phase 3 & Build Check. fc89681

### Phase 4: Recipe Synchronization (AppCoreShared / ImageCore)
- [x] Task: Implement logic to automatically proof the "Primary Recipe" when enabled. fc89682
- [x] Task: Create a test case: enable sRGB soft proofing -> verify gamut warning on high-saturation colors. fc89682
- [x] Task: Commit Phase 4 & Build Check. fc89682

## Verification & Testing
- Test Case: Toggle Soft Proofing on/off -> Verify visual shift in the Viewer.
- Test Case: Change target profile from sRGB to CMYK -> Verify expected color compression simulation.
- Test Case: Enable Gamut Warning -> Verify out-of-gamut pixels are correctly identified.
