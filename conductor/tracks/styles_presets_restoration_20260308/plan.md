# Implementation Plan: Color Wheels UI Restoration

## Phase 1: Data Models & Math (AppCoreShared / CaptureOneUI)
- [x] Task: Reconstruct `ColorBalanceSettings` data model. f11cfb0
- [x] Task: Implement coordinate transformation logic (Polar to Cartesian and vice-versa). f11cfb0
- [x] Task: Reconstruct `ColorWheelLayout` logic for switching between 3-way and single view. f11cfb0
- [x] Task: Commit Phase 1. f11cfb0

## Phase 2: Core Color Wheel Widget (CaptureOneUI)
- [x] Task: Reconstruct the base `POColorBalanceControl` circular widget using SwiftUI. a5707cb
- [x] Task: Implement circular hue gradient rendering. a5707cb
- [x] Task: Implement the interactive crosshair for Hue/Saturation selection. a5707cb
- [x] Task: Commit Phase 2. 1a22f05

## Phase 3: Peripheral Controls & Sliders (CaptureOneUI)
- [~] Task: Implement the arc-based Brightness slider surrounding the wheel.
- [ ] Task: Add fine-tuning numeric fields for precise color adjustments.
- [ ] Task: Integrate reset logic for individual wheels.
- [ ] Task: Commit Phase 3.

## Phase 4: Inspector Integration & Validation (CaptureOneUI)
- [x] Task: Reconstruct `ColorBalanceInspectorTool` containing the 3-way layout. a5707cb
- [x] Task: Bind all wheels to the `AdjustmentToolController` state. a5707cb
- [x] Task: Create a test case: interact with Shadow wheel -> verify variant metadata update. a5707cb
- [x] Task: Commit Phase 4. a5707cb
