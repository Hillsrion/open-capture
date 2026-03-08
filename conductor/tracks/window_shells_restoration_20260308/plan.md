# Implementation Plan — Window Shell Restoration

## Phase 1: Viewer Window Shell (WS-101)
- [x] Task: Create `ViewerWindowController.swift` that loads `WorkspaceManager.createWorkspace(windowKind: .viewer)`. 4f2b2c1
- [x] Task: Extend `COWindowManager` with `openViewerWindow(for:)` and its delegate. 4f2b2c1
- [x] Task: Add `Window > New Viewer` menu action. 4f2b2c1
- [x] Task: Commit Phase 1. 4f2b2c1

## Phase 2: Culling Window Shell (WS-103)
- [x] Task: Create `CullingShellController.swift` (distinct from existing `CullingWindowController`). Load `.culling` preset. 4f2b2c1
- [x] Task: Extend `COWindowManager` with `openCullingWindow(for:)` and its delegate. 4f2b2c1
- [x] Task: Add `Window > Culling` menu action. 4f2b2c1
- [x] Task: Commit Phase 2. 4f2b2c1

## Phase 3: Validate live preview (WS-102) + cleanup
- [x] Task: Verify `LivePreviewWindowController` correctly loads `.livePreview` preset. Fix if needed. Already correct.
- [x] Task: Commit Phase 3 if any fix was necessary. No fix needed.
