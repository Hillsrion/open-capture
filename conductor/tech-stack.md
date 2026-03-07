# Technology Stack

## Core Technologies
- **Languages:**
    - **Swift:** Used for modern UI components and high-level logic.
    - **Objective-C:** Likely used for lower-level performance-critical modules and legacy infrastructure.
- **Platform:** macOS (target architecture: `arm64`).

## Frameworks & UI
- **User Interface:**
    - **AppKit, SwiftUI & QuickLook:** Hybrid architecture for window management, performant thumbnail extraction, and modern tool views.
- **Image Processing:**
    - **Accelerate, Metal & CoreML:** Used for high-performance SIMD processing, GPU acceleration, and local AI segmentation.
    - **Custom Frameworks:** `ImageCore`, `ImageProcessing`.

## Data & Infrastructure
- **Persistence:**
    - **SQLite3:** Core database engine for Catalog and Session management.
    - **Custom Frameworks:** `DataCore`, `ModelCore`.
- **Communication:**
    - **XPC Services:** Used for process isolation in plugin hosting.
    - **XPC inter-process communication (IPC):** For communication between the main app and plugins.

## External Libraries
- **Networking:** `CocoaAsyncSocket`, `CocoaHTTPServer`.
- **Serialization:** `SwiftProtobuf`.
- **Analytics:** `AnalyticsFrameworkObjC`.
- **Testing:** `XCTest` for logic verification and regression testing.
