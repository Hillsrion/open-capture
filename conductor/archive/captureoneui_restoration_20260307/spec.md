# Specification: Full Restoration of CaptureOneUI Presentation Logic

## Overview
`CaptureOneUI` is the presentation layer of the application, managing everything from the main workspace layout to individual tool views and custom drawing logic. This track focuses on a full Swift restoration of these UI components, ensuring a faithful replication of the Capture One aesthetic using modern macOS UI frameworks.

## Functional Requirements
- **Visual Foundation:** Reconstruct the custom color palettes, themes, and styling logic identified in `NSColor(CaptureOne)` extensions.
- **Window & Workspace Management:** Restore the core window controllers and the logic for managing complex, customizable workspace layouts.
- **Tool View Architecture:** Reconstruct the base classes and specialized views for editing tools (Histogram, Exposure, Curves, etc.).
- **SwiftUI/AppKit Bridging:** Reconstruct the integration layer that allows the application to utilize both SwiftUI and AppKit components.
- **Event Handling & Interaction:** Restore the logic for mouse/keyboard interactions, custom gestures, and tool selection.

## Non-Functional Requirements
- **Modern Swift Restoration:** Full port from assembly/ObjC to idiomatic Swift.
- **Faithful Aesthetic:** Ensure the reconstructed UI matches the original Capture One look and feel.
- **Performance:** Maintain smooth interaction and rendering performance for high-resolution displays.

## Acceptance Criteria
- Compilable Swift source for core UI components and controllers.
- Verified rendering of basic UI elements (windows, basic tool shells).
- Documentation of the UI architecture and bridging strategy.

## Out of Scope
- Backend business logic (handled in `AppCoreShared`).
- Low-level image processing (handled in `ImageCore`).
