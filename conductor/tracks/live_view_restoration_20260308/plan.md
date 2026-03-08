# Implementation Plan: Live View Engine Restoration

## Phase 1: Live View Tool Views
- [x] Task: Create `LivePreviewTools.swift`. Implement `LivePreviewCompositionToolView`, `LivePreviewAdjustmentsToolView`, `LivePreviewInfoToolView`, and `NormalizeToolView`. f8de41d
- [x] Task: Register them in `ToolRegistry.swift` to replace their placeholders. f8de41d
- [x] Task: Commit Phase 1. f8de41d

## Phase 2: Live View Shell
- [x] Task: Create `LivePreviewWindowController` (or SwiftUI equivilent). It should load the `livepreviewwindow.tools` workspace preset for its sidebar. 83d5d97
- [x] Task: Extend `COWindowManager` to handle opening and focusing the `LivePreviewWindow`. 83d5d97
- [x] Task: Commit Phase 2. 83d5d97

## Phase 3: Action Wiring
- [x] Task: Add "Window -> Live View" to `AppMenuTarget` and `main.swift`. 06640b5
- [x] Task: Connect the menu action to `AppCommandCenter` -> `COWindowManager.shared.openLivePreview()`. 06640b5
- [x] Task: Commit Phase 3. 06640b5
