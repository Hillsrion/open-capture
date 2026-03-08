# Implementation Plan: Camera Control API Restoration

## Phase 1: Core P1CaptureCore Wrappers (AppCoreShared)
- [x] Task: Reconstruct `P1CaptureCore_Camera` and `P1CaptureCore_Property` models. c4f4c50
- [x] Task: Implement `shutterRelease` and `session` management logic. c4f4c50
- [x] Task: Reconstruct the `PtpDeviceBrowser` for simulated camera discovery. c4f4c50
- [x] Task: Commit Phase 1. c4f4c50

## Phase 2: Property Management & UI (CaptureOneUI)
- [x] Task: Reconstruct the `CameraSettingsTool` with ISO, Shutter, and Aperture selectors. a5707cb
- [x] Task: Implement real-time property syncing between the camera and UI. a5707cb
- [x] Task: Reconstruct the `CaptureButton` with progress and status feedback. a5707cb
- [x] Task: Commit Phase 2. 55e3413

## Phase 3: Image Transfer & Ingestion (ImageCore / AppCoreShared)
- [x] Task: Reconstruct the `CaptureImageQueue` for asynchronous transfer. a5707cb
- [x] Task: Implement the "Auto-Ingest" logic to add captured images to the current session. a5707cb
- [x] Task: Integrate with `ImageCorePipeline` for immediate post-capture preview. a5707cb
- [x] Task: Commit Phase 3. 96cde80

## Phase 4: Live View & Validation (CaptureOneUI / ImageCore)
- [x] Task: Reconstruct the `LiveViewEngine` for real-time frame fetching. a5707cb
- [x] Task: Implement the `LiveViewOverlay` in the viewer. a5707cb
- [x] Task: Create a test case: discover simulated camera -> change ISO -> trigger shutter -> verify ingestion. a5707cb
- [x] Task: Commit Phase 4. a5707cb
