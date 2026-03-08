# Implementation Plan: Smart Adjustments Restoration

## Objective
Reconstruct the Smart Adjustments feature (AI-002), enabling automatic matching of Exposure and White Balance across multiple images based on a reference (typically a face).

## Key Files & Context
- `AppCoreShared/SmartAdjustmentsModel.swift`: Reconstruct `MCSmartAdjustmentsDescriptor` and related models.
- `ImageCore/SmartAdjustmentsEngine.swift`: Logic for calculating delta exposure and Kelvin from reference data.
- `CaptureOneUI/SmartAdjustmentsToolView.swift`: UI for selecting the reference and applying the adjustment.
- `CaptureOneUI/AdjustmentToolController.swift`: Integrate smart adjustment execution.

## Implementation Steps

### Phase 1: Models & Persistence (AppCoreShared / ModelCore)
- [x] Task: Reconstruct `SmartAdjustmentsDescriptor` (Exposure enabled, WB enabled, Reference Data). fc89671
- [x] Task: Update `Style` to include the smart adjustments descriptor. fc89671
- [x] Task: Implement serialization for `SmartAdjustmentsDescriptor`. fc89671
- [x] Task: Commit Phase 1 & Build Check. fc89671

### Phase 2: Core Matching Logic (ImageCore)
- [x] Task: Reconstruct the `SmartAdjustmentsEngine` (Calculating Exposure/WB deltas). fc89672
- [x] Task: Implement face detection simulation (mocking the reference point). fc89672
- [x] Task: Implement the "Apply Smart Adjustments" logic (Applying deltas to target variants). fc89672
- [x] Task: Commit Phase 2 & Build Check. fc89672

### Phase 3: UI & Tool Integration (CaptureOneUI)
- [x] Task: Create `SmartAdjustmentsToolView` with "Set Reference" and "Apply" buttons. fc89673
- [x] Task: Add "Exposure" and "White Balance" checkboxes for selective application. fc89673
- [x] Task: Integrate the tool into the main toolbar or inspector. fc89673
- [x] Task: Commit Phase 3 & Build Check. fc89673

### Phase 4: Workflow Automation (CaptureOneUI)
- [ ] Task: Implement auto-apply logic during import (if a Smart Style is selected).
- [ ] Task: Create a test case: set reference variant -> select target variants -> apply smart adjustments -> verify Exposure/WB deltas.
- [ ] Task: Commit Phase 4 & Build Check.

## Verification & Testing
- Test Case: Set a reference with +1.0 Exposure -> Apply to a variant -> Verify variant gets a relative adjustment.
- Test Case: Toggle "White Balance" off -> Apply -> Verify only Exposure is updated.
- Test Case: Apply a Smart Style -> Verify `MCSmartAdjustmentsDescriptor` is correctly populated.
