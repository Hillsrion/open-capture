# Technology Stack

## Core Technologies
- **Languages:**
    - **Swift:** Used for modern UI components and high-level logic.
    - **Objective-C:** Likely used for lower-level performance-critical modules and legacy infrastructure.
- **Platform:** macOS (target architecture: `arm64`).

## Frameworks & UI
- **User Interface:**
    - **AppKit:** For the main windowing and legacy UI components.
    - **SwiftUI:** For modern, modular UI elements.
- **Image Processing:**
    - **Accelerate & Metal:** Likely used by the processing engine for performance.
    - **Custom Frameworks:** `ImageCore`, `ImageProcessing`.

## Data & Infrastructure
- **Persistence:**
    - **SQLite:** Used for catalog management and data storage.
    - **Custom Frameworks:** `DataCore`, `ModelCore`.
- **Communication:**
    - **XPC Services:** Used for process isolation in plugin hosting.
    - **XPC inter-process communication (IPC):** For communication between the main app and plugins.

## External Libraries
- **Networking:** `CocoaAsyncSocket`, `CocoaHTTPServer`.
- **Serialization:** `SwiftProtobuf`.
- **Analytics:** `AnalyticsFrameworkObjC`.
