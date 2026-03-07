# Implementation Plan: Levels and Curves Tool Restoration

## Phase 1: Mathematical Logic & ImageCore Kernels
- [x] Task: Reconstruct the `Levels` transformation logic (Input-to-Output mapping).
- [x] Task: Reconstruct the `Curves` spline interpolation algorithm (Cubic Splines for smooth transitions).
- [x] Task: Implement LUT (Look-Up Table) generation from curve points.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Mathematical Logic' (Protocol in workflow.md)

## Phase 2: UI Components (CaptureOneUI)
- [x] Task: Reconstruct the `Levels` interactive histogram widget (`POLevelsControl`).
- [x] Task: Reconstruct the `Curves` interactive editor (`POCurvesControl`).
- [x] Task: Implement multi-channel support (RGB, Red, Green, Blue, Luma) for both tools.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: UI Components' (Protocol in workflow.md)

## Phase 3: Integration & State Management
- [x] Task: Bind Levels and Curves parameters to `MCVariant` settings.
- [x] Task: Connect tool changes to the `ImageCorePipeline` (LUT-based processing).
- [x] Task: Optimize the histogram and curve preview for real-time responsiveness.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Integration' (Protocol in workflow.md)
