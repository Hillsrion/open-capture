# Implementation Plan: Tethered Capture Enhancements (Next Capture Naming & Adjustments)

## Objective
Reconstruct the logic for managing next capture naming (token-based) and automatic adjustment application (Next Capture Adjustments) during tethered capture.

## Key Files & Context
- `AppCoreShared/CameraModels.swift`: `P1CaptureCore_Camera` needs to handle naming.
- `AppCoreShared/NamingEngine.swift`: New engine for token parsing and formatting (TETH-003).
- `CaptureOneUI/NextCaptureSettingsTool.swift`: New UI tool for managing these settings.
- `CaptureOneUI/LiveViewOverlayView.swift`: Add Focus Mask rendering (TETH-004).

## Implementation Steps

### Phase 1: Naming & Token Engine (AppCoreShared)
- [x] Task: Reconstruct `CaptureNamingToken` model and `CaptureNamingFormatter`. fc89666
- [x] Task: Implement `resolveNamingFormat` logic supporting tokens like `[Camera]`, `[Date]`, `[Counter]`. fc89666
- [x] Task: Add `nextCaptureName` property to `P1CaptureCore_Camera`. fc89666
- [x] Task: Commit Phase 1 & Build Check. fc89666

### Phase 2: Next Capture Adjustments (AppCoreShared / ImageCore)
- [x] Task: Reconstruct `NextCaptureAdjustments` state (Copy from Last, Copy from Primary, Specific Style). fc89666
- [x] Task: Implement the auto-apply logic in `P1CaptureCore_Camera.shutterRelease` (simulation). fc89666
- [x] Task: Commit Phase 2 & Build Check. fc89666

### Phase 3: Focus Mask Engine (ImageCore / CaptureOneUI)
- [x] Task: Reconstruct the high-frequency Focus Mask algorithm (detecting sharp edges in the Live View stream). fc89666
- [x] Task: Implement `FocusMaskOverlay` in `LiveViewOverlayView`. fc89666
- [x] Task: Commit Phase 3 & Build Check. fc89666

### Phase 4: UI & Tool Integration (CaptureOneUI)
- [x] Task: Create `NextCaptureSettingsTool` with naming format editor and adjustment selection. fc89666
- [x] Task: Integrate the new tool into the `CameraSettingsTool` workflow. fc89666
- [x] Task: Commit Phase 4 & Build Check. fc89666

## Verification & Testing
- Test Case: Set naming format to `[Camera]_[Counter]` -> Trigger capture -> Verify resulting filename.
- Test Case: Set adjustments to "Copy from Last" -> Modify last variant -> Trigger capture -> Verify adjustments are applied to new variant.
- Test Case: Enable Focus Mask -> Verify green overlay on sharp areas of mock Live View stream.
