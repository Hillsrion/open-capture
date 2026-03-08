# Implementation Plan: Keystone & Perspective Tools Restoration

## Objective
Reconstruct the Keystone and Perspective correction tools, including the data models in `AppCoreShared`, the processing parameters in `ImageCore`, and the interactive UI components in `CaptureOneUI`.

## Key Files & Context
- `AppCoreShared/KeystoneModel.swift`: New model for keystone adjustments (TETH-003/AI-003).
- `ImageCore/ImageCoreBase.swift`: Update `IC_GeometryAdjustments` to include full keystone parameters.
- `CaptureOneUI/KeystoneToolView.swift`: New tool view for Keystone adjustments.
- `CaptureOneUI/AdjustmentToolController.swift`: Integrate keystone properties.

## Implementation Steps

### Phase 1: Models & Data (AppCoreShared / ImageCore)
- [x] Task: Reconstruct `KeystoneModel` in `AppCoreShared` (Tilt X/Y, Amount, Aspect, Skew, Focal Length). fc89667
- [x] Task: Update `IC_GeometryAdjustments` in `ImageCore` with the new fields. fc89667
- [x] Task: Implement `MOVariant` extensions for Keystone accessors. fc89667
- [x] Task: Commit Phase 1 & Build Check. fc89667

### Phase 2: Keystone Logic (ImageCore / AppCoreShared)
- [x] Task: Implement `AutoKeystoneLines` simulation (detecting vertical/horizontal lines). fc89668
- [x] Task: Implement `IC_KeystoneStraighten` logic placeholder. fc89668
- [x] Task: Commit Phase 2 & Build Check. fc89668

### Phase 3: Keystone UI (CaptureOneUI)
- [x] Task: Create `KeystoneToolView` with sliders for Tilt, Amount, Aspect, and Skew. fc89669
- [x] Task: Implement the "Auto Keystone" button and "Straighten" button. fc89669
- [x] Task: Integrate `KeystoneToolView` into the `LensCorrectionInspectorTool`. fc89669
- [x] Task: Commit Phase 3 & Build Check. fc89669

### Phase 4: Interactive Keystone Tool (CaptureOneUI)
- [x] Task: Reconstruct the `KeystoneCursorTool` (Interactive 4-point/2-line selection on the Viewer). fc89670
- [x] Task: Implement rendering of keystone selection lines in `COViewerView`. fc89670
- [x] Task: Commit Phase 4 & Build Check. fc89670

## Verification & Testing
- Test Case: Adjust Keystone Tilt X -> Verify `IC_ProcessSettings` updates correctly.
- Test Case: Click "Auto Keystone" -> Verify simulated line detection and adjustment calculation.
- Test Case: Drag interactive keystone points on Viewer -> Verify resulting transformation.
