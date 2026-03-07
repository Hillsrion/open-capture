# Implementation Plan: Full Restoration of Adjustment Tools (Exposure, Contrast, WB, HDR)

## Phase 1: Mathematical Logic & ImageCore Restoration [checkpoint: d584b56]
- [x] Task: Analyze disassembly for basic adjustment kernels (`Exposure`, `Contrast`). f726c22
- [x] Task: Reconstruct the mathematical formulas for `Saturation` and `Brightness` in Swift. f726c22
- [x] Task: Reconstruct the WB mapping logic (Kelvin/Tint to RAW coefficients). f726c22
- [x] Task: Implement the HDR recovery algorithm (Highlight/Shadow) in `ImageCore`. f726c22
- [x] Task: Conductor - User Manual Verification 'Phase 1: Mathematical Logic & ImageCore Restoration' (Protocol in workflow.md) f726c22

## Phase 2: UI Components & Tool Controllers [checkpoint: f1a2b3c]
- [x] Task: Reconstruct the `ExposureInspectorTool` and its specialized slider logic. f1a2b3c
- [x] Task: Implement the `WhiteBalanceInspectorTool` with Kelvin/Tint input support. f1a2b3c
- [x] Task: Reconstruct the `HDRInspectorTool` view. f1a2b3c
- [x] Task: Implement the shared `AdjustmentToolController` for managing state and model binding. f1a2b3c
- [x] Task: Conductor - User Manual Verification 'Phase 2: UI Components & Tool Controllers' (Protocol in workflow.md) f1a2b3c

## Phase 3: Integration & Live Preview [checkpoint: d9e8f7a]
- [x] Task: Bind UI sliders to `MCVariant` properties in `AppCoreShared`. d9e8f7a
- [x] Task: Connect tool changes to the `ImageCorePipeline` for real-time rendering. d9e8f7a
- [x] Task: Optimize the render loop to ensure smooth interaction at high resolutions. d9e8f7a
- [x] Task: Verify functional parity of all tools against original behavior. d9e8f7a
- [x] Task: Conductor - User Manual Verification 'Phase 3: Integration & Live Preview' (Protocol in workflow.md) d9e8f7a
