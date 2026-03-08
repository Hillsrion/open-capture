# Track: Top Chrome Parity (UI-207)

## Context

The main session window currently uses a SwiftUI `MainToolbarView` rendered inside
the content area as a fake toolbar strip. The original Capture One uses a real
`NSToolbar` with `POValidatingToolbarItem` subclasses and native item validation.

## Scope

- Replace the in-content SwiftUI strip with a native `NSToolbar` on the document window.
- The toolbar items should be driven by the same `ToolbarConfiguration` from the
  workspace plist.
- Keep `MainToolbarView` as a fallback for secondary windows (viewer, culling).

## Technical Objectives

1. Create `CONativeToolbar` class conforming to `NSToolbarDelegate`.
2. Attach it to the `NSWindow` in `COWindowManager.openDocumentWindow`.
3. Remove the `MainToolbarView()` call from `CullingView.body` (it will be native).
