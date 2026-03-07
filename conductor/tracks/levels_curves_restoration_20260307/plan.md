# Implementation Plan: Levels and Curves Tool Restoration

## Phase 1: Mathematical Logic & ImageCore Kernels
- [ ] Task: Reconstruct the `Levels` transformation logic (Input-to-Output mapping).
- [ ] Task: Reconstruct the `Curves` spline interpolation algorithm (Cubic Splines for smooth transitions).
- [ ] Task: Implement LUT (Look-Up Table) generation from curve points.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Mathematical Logic' (Protocol in workflow.md)

## Phase 2: UI Components (CaptureOneUI)
- [ ] Task: Reconstruct the `Levels` interactive histogram widget (`POLevelsControl`).
- [ ] Task: Reconstruct the `Curves` interactive editor (`POCurvesControl`).
- [ ] Task: Implement multi-channel support (RGB, Red, Green, Blue, Luma) for both tools.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: UI Components' (Protocol in workflow.md)

## Phase 3: Integration & State Management
- [ ] Task: Bind Levels and Curves parameters to `MCVariant` settings.
- [ ] Task: Connect tool changes to the `ImageCorePipeline` (LUT-based processing).
- [ ] Task: Optimize the histogram and curve preview for real-time responsiveness.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Integration' (Protocol in workflow.md)
