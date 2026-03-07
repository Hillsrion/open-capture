# Implementation Plan: Full Restoration of Adjustment Tools (Exposure, Contrast, WB, HDR)

## Phase 1: Mathematical Logic & ImageCore Restoration
- [ ] Task: Analyze disassembly for basic adjustment kernels (`Exposure`, `Contrast`).
- [ ] Task: Reconstruct the mathematical formulas for `Saturation` and `Brightness` in Swift.
- [ ] Task: Reconstruct the WB mapping logic (Kelvin/Tint to RAW coefficients).
- [ ] Task: Implement the HDR recovery algorithm (Highlight/Shadow) in `ImageCore`.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Mathematical Logic & ImageCore Restoration' (Protocol in workflow.md)

## Phase 2: UI Components & Tool Controllers
- [ ] Task: Reconstruct the `ExposureInspectorTool` and its specialized slider logic.
- [ ] Task: Implement the `WhiteBalanceInspectorTool` with Kelvin/Tint input support.
- [ ] Task: Reconstruct the `HDRInspectorTool` view.
- [ ] Task: Implement the shared `AdjustmentToolController` for managing state and model binding.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: UI Components & Tool Controllers' (Protocol in workflow.md)

## Phase 3: Integration & Live Preview
- [ ] Task: Bind UI sliders to `MCVariant` properties in `AppCoreShared`.
- [ ] Task: Connect tool changes to the `ImageCorePipeline` for real-time rendering.
- [ ] Task: Optimize the render loop to ensure smooth interaction at high resolutions.
- [ ] Task: Verify functional parity of all tools against original behavior.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Integration & Live Preview' (Protocol in workflow.md)
