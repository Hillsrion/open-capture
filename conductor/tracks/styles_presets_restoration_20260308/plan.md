# Implementation Plan: Live View Engine Restoration

## Phase 1: Stream Management & Models (AppCoreShared / CaptureOneUI)
- [x] Task: Reconstruct `P1CaptureCore_LiveViewImage` model. fc89662
- [x] Task: Implement `startLiveView`, `stopLiveView`, and `pauseLiveView` in `P1CaptureCore_Camera`. fc89662
- [x] Task: Reconstruct `liveViewState` state management. fc89662
- [x] Task: Commit Phase 1 & Build Check. fc89662

## Phase 2: Frame Fetching Loop (CaptureOneUI)
- [x] Task: Reconstruct the high-speed `LiveViewFrameLoop` using `CADisplayLink` or a high-priority `Timer`. fc89663
- [x] Task: Implement the asynchronous `getNextLiveViewImage` fetch logic. fc89663
- [x] Task: Implement mock frame generation for the simulated stream. fc89663
- [x] Task: Commit Phase 2 & Build Check. fc89663

## Phase 3: Viewer Integration (CaptureOneUI)
- [ ] Task: Reconstruct the `LiveViewOverlayView` for high-performance frame rendering.
- [ ] Task: Implement the `cropMatchesCurrentCameraCrop` aspect ratio logic.
- [ ] Task: Add the "Live View" button to the `CameraSettingsTool`.
- [ ] Task: Commit Phase 3 & Build Check.

## Phase 4: Validation & Optimization (Project-wide)
- [ ] Task: Implement automatic live view pausing during high-res capture.
- [ ] Task: Create a test case: enable live view -> verify 30 FPS frame updates -> trigger capture -> verify auto-pause.
- [ ] Task: Commit Phase 4 & Build Check.
