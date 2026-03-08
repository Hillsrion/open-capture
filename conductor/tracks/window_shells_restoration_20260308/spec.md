# Track: Window Shell Restoration (WS-101 to WS-103)

## Context

The workspace preset loader already parses `Default.plist` for all window kinds
(session, viewer, livePreview, culling), but only the session window has an
actual controller (`COWindowManager.openDocumentWindow`). The viewer and culling
window types remain unbuilt, meaning the dual-monitor and multi-window workflows
that define professional Capture One usage are unreachable.

## Scope

- **WS-101**: Create a dedicated **Viewer Window Controller** that loads
  `viewerwindow.tools` presets and shows a full-screen viewer with an optional
  sidebar.
- **WS-102**: Repurpose `LivePreviewWindowController` — it already exists from
  GAP-401. Validate it loads the correct preset and can be reopened.
- **WS-103**: Create a dedicated **Culling Window Controller** that loads
  `cullingwindow.tools` presets.

## Technical Objectives

1. Each window controller uses `WorkspaceManager.createWorkspace(windowKind:)`
   to get its preset.
2. Each window is managed by `COWindowManager` — can be opened, focused, and
   cleaned up with its own delegate.
3. Menu actions are added to `Window > New Viewer`, `Window > Culling`.
4. Each window loads the ToolRegistry-driven sidebar.
