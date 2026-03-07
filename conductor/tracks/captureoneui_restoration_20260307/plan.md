# Implementation Plan: Full Restoration of CaptureOneUI Presentation Logic

## Phase 1: Visual Foundation & Custom Controls
- [ ] Task: Map the complete custom color palette from `NSColor(CaptureOne)` symbols.
- [ ] Task: Reconstruct the `CaptureOneTheme` system for consistent styling.
- [ ] Task: Reconstruct custom UI components (Buttons, Sliders, Cells) identified in metadata.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Visual Foundation & Custom Controls' (Protocol in workflow.md)

## Phase 2: Windowing & Workspace Restoration
- [ ] Task: Reconstruct the main window controller and its toolbar management.
- [ ] Task: Implement the workspace layout engine (Sidebar, Viewer, Filmstrip coordination).
- [ ] Task: Reconstruct the SwiftUI/AppKit bridging layer.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Windowing & Workspace Restoration' (Protocol in workflow.md)

## Phase 3: Tool Views & Interactive Logic
- [ ] Task: Reconstruct the base `ToolViewController` and tool registration system.
- [ ] Task: Implement specialized views for Histogram and primary Exposure tools.
- [ ] Task: Reconstruct event handling for the main Viewer (Zoom, Pan, Crop interaction).
- [ ] Task: Perform functional verification of UI-to-Model bindings.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Tool Views & Interactive Logic' (Protocol in workflow.md)
