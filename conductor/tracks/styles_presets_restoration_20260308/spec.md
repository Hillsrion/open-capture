# Specification: Camera Control API Restoration (TETH-001)

## Overview
This track focuses on the reconstruction of Capture One's robust tethered capture engine. At its core is `P1CaptureCore`, a multi-layered system that communicates with cameras via PTP (Picture Transfer Protocol) over USB or Network. The reconstruction will provide a unified API for camera discovery, property management (ISO, Shutter, Aperture), and high-speed image transfer.

## Functional Requirements
- **Camera Discovery:**
    - **PTP Device Browser:** Reconstruct the logic discovered in `PtpDeviceBrowser` to scan for connected USB cameras.
    - **Camera Selection:** Implement the `P1CaptureCore_CameraList` to manage multiple connected devices.
- **Camera Control:**
    - **Session Management:** Reconstruct `open`, `close`, and `isConnected` logic for stable tethering sessions.
    - **Shutter Release:** Implement the `shutterRelease` method to trigger the camera remotely.
    - **Property Management:** Reconstruct the `P1CaptureCore_Property` system to get/set camera settings (ISO, Shutter Speed, Aperture, White Balance).
- **Image Transfer:**
    - **Capture Queue:** Reconstruct the `getCaptureImageQueue` and `getNextCaptureImage` logic for asynchronous background image transfer.
    - **Raw Injection:** Provide a mechanism to inject captured RAW data directly into the `ImageCore` pipeline for immediate preview.
- **Live View Engine:**
    - **Stream Control:** Reconstruct `startLiveView` and `stopLiveView` methods.
    - **Frame Processing:** Implement `getNextLiveViewImage` to fetch real-time preview frames from the camera.

## Non-Functional Requirements
- **Reliability:** The tethering engine must handle disconnects gracefully and attempt auto-reconnection.
- **Speed:** Image transfer and preview rendering must be highly optimized to support professional shooting speeds (up to 10+ FPS).

## Acceptance Criteria
- Successful discovery of a simulated PTP camera.
- Ability to remotely trigger the shutter and receive a "capture completed" event.
- Real-time updates of camera properties in the UI.
- Simulated live view stream rendering in the viewer at 30 FPS.

## Out of Scope
- Brand-specific proprietary protocols beyond standard PTP extensions (e.g., legacy FireWire protocols).
- Camera firmware update management.
