# Implementation Plan — High-Fidelity Workspace Chrome & Shell Restoration

## Phase 1: Dedicated Importer Shell (WS-104)
- [x] Task: Create `ImporterWindowController.swift` as an `NSWindowController` wrapping `ImportDialog`.
- [x] Task: Add `openImporterWindow(importer:)` to `COWindowManager` and its delegate.
- [x] Task: Update `AppCommandCenter.presentImport()` to call `COWindowManager.openImporterWindow`.
- [x] Task: Verify workspace preset `.importerwindow` is requested from `WorkspaceManager`.
- [x] Task: Commit Phase 1.

## Phase 2: Dedicated Exporter Shell (WS-104)
- [x] Task: Create `ExporterWindowController.swift` as an `NSWindowController` wrapping `ExportView`.
- [x] Task: Add `openExporterWindow()` to `COWindowManager`.
- [x] Task: Update `AppCommandCenter.presentExport()` to use the new window controller.
- [x] Task: Verify workspace preset `.exporterwindow` is correctly applied.
- [x] Task: Commit Phase 2.

## Phase 3: Dedicated Print Shell (WS-104)
- [ ] Task: Convert `PrintWindowController.swift` into a real `NSWindowController` wrapping `PrintDialog`.
- [ ] Task: Add `openPrintWindow()` to `COWindowManager`.
- [ ] Task: Update `AppCommandCenter.presentPrint()` to use the new window controller.
- [ ] Task: Verify workspace preset `.printwindow` is correctly applied.
- [ ] Task: Commit Phase 3.

## Phase 4: Palette Undocking & Redocking (WS-105)
- [ ] Task: Implement `FloatingToolWindowController` to host a single `ToolConfiguration`.
- [ ] Task: Add drag gesture support to `ToolHeader` and `InspectorToolTabView` to trigger undocking.
- [ ] Task: Implement redocking logic when dragging a floating tool back to the sidebar.
- [ ] Task: Handle persistence of undocked tool states in the `Workspace`.
- [ ] Task: Commit Phase 4.

## Phase 5: Multi-monitor & Full Screen behavior (WS-106)
- [ ] Task: Restore window placement persistence across multiple displays (saving screen frames to plist).
- [ ] Task: Implement C1-style full-screen behavior (hiding/showing chrome based on workspace state).
- [ ] Task: Verify and fix any window depth/level issues (e.g., floating tools staying on top).
- [ ] Task: Commit Phase 5.
