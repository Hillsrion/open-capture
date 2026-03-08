# Implementation Plan — Top Chrome Parity (UI-207)

## Phase 1: Native NSToolbar + Delegate
- [ ] Task: Create `CONativeToolbar.swift` with `NSToolbarDelegate` routing items from workspace config.
- [ ] Task: Integrate native toolbar into `COWindowManager.openDocumentWindow`.
- [ ] Task: Remove `MainToolbarView()` from `CullingView.body` (now native).
- [ ] Task: Commit Phase 1.
