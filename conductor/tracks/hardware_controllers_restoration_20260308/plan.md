# Implementation Plan: Hardware Controllers Restoration

## Objective
Reconstruct the hardware controller mapping system (INT-005), enabling external physical control surfaces (like Tangent panels or MIDI devices) to map knobs and dials to specific adjustments (e.g., Exposure, Contrast, Color Wheels).

## Key Files & Context
- `AppCoreShared/HardwareControllerManager.swift`: A new manager to handle incoming events and mapping logic.
- `AppCoreShared/HardwareMapping.swift`: Data models for defining how a physical input maps to a software property.
- `CaptureOneUI/AdjustmentToolController.swift`: Expose setters that can be triggered by the hardware manager.
- `CaptureOneApp/main.swift`: Initialize the hardware manager.

## Implementation Steps

### Phase 1: Models & API (AppCoreShared)
- [x] Task: Reconstruct `HardwareMapping` and `HardwareEvent` models (Action ID, Value Delta). fc89698
- [x] Task: Create `HardwareControllerManager` with a registry of supported actions (e.g., `adjustExposure`, `adjustContrast`). fc89698
- [x] Task: Commit Phase 1 & Build Check. fc89698

### Phase 2: Integration with Adjustment Controller (CaptureOneUI)
- [x] Task: Connect `HardwareControllerManager` to the shared `AdjustmentToolController`. fc89699
- [x] Task: Implement a public method `handleHardwareEvent(actionID: String, delta: Double)` to mutate active variant properties. fc89699
- [x] Task: Commit Phase 2 & Build Check. fc89699

### Phase 3: Mock Driver & Verification
- [x] Task: Implement a mock driver in `HardwareControllerManager` to simulate incoming physical events. fc89700
- [x] Task: Create a test case: simulate a `knob_turn` event mapped to Exposure -> verify `AdjustmentToolController.exposure` changes proportionally. fc89700
- [x] Task: Commit Phase 3 & Build Check. fc89700

## Verification & Testing
- Test Case: Send `adjustExposure` event with `+0.5` delta -> Verify `exposure` slider updates in the UI and the underlying `VariantBase` is modified.
- Test Case: Ensure smooth value clamping (e.g., exposure cannot exceed bounds via hardware turns).
