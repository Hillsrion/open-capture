# Specification: Live View Engine Restoration

## Context
Per `backlog.md` (GAP-401, WS-102), the `Live View Engine Restoration` track is critical. The decompiled system features a dedicated `LivePreviewWindow` with its own toolsets (LivePreviewComposition, LivePreviewAdjustments, LivePreviewInfoTool, Normalize). Currently, these are missing or placeholders, and the shell doesn't spawn a proper standalone window dedicated to Live View workflows matching the decompiled behavior.

## Scope
- Reconstruct the missing `LivePreviewWindow` tool views (`LivePreviewCompositionToolView`, `LivePreviewAdjustmentsToolView`, `LivePreviewInfoToolView`, `NormalizeToolView`).
- Route them properly in `ToolRegistry.swift`.
- Create a dedicated `LivePreviewWindowController` capable of hosting real Live View sessions from tethered cameras.
- Extend `COWindowManager` to support opening/managing the `LivePreviewWindow`.

## Technical Objectives
1. Add `LivePreviewCompositionToolView`, `LivePreviewAdjustmentsToolView`, `LivePreviewInfoToolView`, and `NormalizeToolView` to a `LivePreviewTools.swift` file.
2. Route these new tool views in `ToolRegistry` so the `livepreviewwindow.tools` workspace file can load them correctly without showing `UnavailableToolView`.
3. Create `LivePreviewWindowController` that leverages the Workspace definition to layout the split between the video stream and the sidebar.
4. Update `main.swift` or App Menu to dispatch "Open Live View" actions to `COWindowManager` and subsequently the new window controller.
