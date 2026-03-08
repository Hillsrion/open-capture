# Specification: Live View Engine Restoration (TETH-002)

## Overview
This track focuses on the reconstruction of Capture One's high-performance Live View engine. This system provides a real-time video feed from tethered cameras directly into the viewer, allowing for precise composition, focus checking, and remote adjustment. The engine manages the PTP stream, handles frame decompression, and integrates with the viewer's overlay system.

## Functional Requirements
- **Stream Management:**
    - **Session Control:** Reconstruct `startLiveView`, `stopLiveView`, and `pauseLiveView` logic within `P1CaptureCore_Camera`.
    - **Status Tracking:** Implement `liveViewState` and `isLiveViewEnabled` to manage the UI state of the stream.
- **Frame Fetching:**
    - **Asynchronous Loop:** Reconstruct the logic to continuously fetch frames using `getNextLiveViewImage`.
    - **Frame Data:** Reconstruct the `P1CaptureCore_LiveViewImage` model to hold raw frame data and metadata (timestamp, focus status).
- **Viewer Integration:**
    - **Live View Overlay:** Implement a dedicated rendering layer in `COViewerView` for the live feed.
    - **Crop Matching:** Reconstruct the `cropMatchesCurrentCameraCrop` logic to ensure the live feed correctly respects the camera's active aspect ratio and crop.
- **Performance:**
    - **High-Speed Decoding:** Ensure frames are decoded and rendered at 30+ FPS with minimal latency.
    - **Tile-based Rendering:** Support tile-based updates if the stream resolution exceeds standard display sizes.

## Non-Functional Requirements
- **Latency:** The end-to-end latency (camera sensor to viewer screen) must be below 100ms for a "real-time" feel.
- **Robustness:** The engine must handle frame drops and network jitter without crashing or freezing.

## Acceptance Criteria
- Successful activation of the live view stream from a simulated camera.
- Smooth rendering of the feed at 30 FPS in the main viewer.
- Correct aspect ratio and crop alignment of the live feed.
- Live view automatically pauses/resumes during a high-resolution capture.

## Out of Scope
- Remote focus motor control (handled in a separate focus control track).
- Multi-camera simultaneous live view.
