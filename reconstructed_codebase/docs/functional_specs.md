# Capture One 16.5.9 Functional Specifications (Reference)

This document serves as the functional source of truth for the reconstruction of Capture One version 16.5.9.7. These specifications are used to map technical disassembly to user-facing features and business logic.

## 1. Core Feature Set

### 1.1 AI-Driven Tools
- **Match Look:** AI-powered color and tone transfer from a reference image.
  - *Technical Keywords:* `MatchLook`, `ColorTransfer`, `AIEngine`.
- **People Masking:** Automatic identification and masking of human subjects and specific parts (skin, eyes, hair).
  - *Technical Keywords:* `PeopleMasking`, `Segmentation`, `ICSegmentation`, `FaceDetection`.
- **Replace Background:** Integration with Photoroom API for background removal and swapping.
  - *Technical Keywords:* `BackgroundRemoval`, `PhotoroomIntegration`.

### 1.2 Image Processing & Color
- **ProStandard Profiles:** High-fidelity color profiles for supported cameras.
- **ProRAW Support:** Ability to toggle between Apple ProRAW tone mapping and Capture One ProStandard.
  - *Technical Keywords:* `ProStandard`, `ProRAW`, `ToneMapping`.
- **RAW Conversion:** High-performance RAW processing engine supporting up to 715 megapixels.

### 1.3 Workflow & Infrastructure
- **Tethering:** High-stability professional camera tethering.
  - *Technical Keywords:* `P1CaptureCore`, `TetheringManager`, `CameraCore`.
- **Cloud Settings:** Synchronization of workspaces, shortcuts, and styles across devices.
  - *Technical Keywords:* `CloudSettings`, `SyncCore`, `IdentityManagement`.
- **Content Credentials (C2PA):** Implementation of the C2PA standard for image provenance.
  - *Technical Keywords:* `C2PA`, `ContentCredentials`, `Provenance`.

## 2. Technical Metadata Mapping (Observed in AppCoreShared)
Based on initial analysis of `AppCoreShared`, the following entities are prioritized:
- **Variant:** Represents an individual edit version of an image.
- **Image:** Represents the source file and its primary properties.
- **Collection:** Represents folders, albums, and smart collections.
- **Session/Catalog:** The primary database and project management containers.

## 3. System Requirements (Target Environment)
- **Architecture:** `arm64` (Apple Silicon) primary, `x86_64` (Intel) secondary.
- **Minimum OS:** macOS 13.7.
- **Graphics:** Heavy reliance on Metal for GPU-accelerated processing and masking.
