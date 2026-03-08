# Implementation Plan: Workspace Manager Restoration

## Phase 1: Data Models & Default Layouts (AppCoreShared)
- [x] Task: Reconstruct `Workspace` and `ToolConfiguration` models. 8338168
- [x] Task: Define default workspaces (Default, Simplified, Tethered). 8338168
- [x] Task: Implement `WorkspaceManager` singleton for registry and lookup. 8338168
- [x] Task: Commit Phase 1 & Build Check. 8338168

## Phase 2: Tab & Layout Logic (CaptureOneUI)
- [x] Task: Reconstruct `InspectorToolTabView` using SwiftUI for tab switching. a5707cb
- [x] Task: Implement the `InspectorToolLayout` vertical stacking logic. a5707cb
- [x] Task: Implement collapsible tool sections within the layout. a5707cb
- [x] Task: Commit Phase 2 & Build Check. 279c110

## Phase 3: Dynamic Customization (CaptureOneUI)
- [x] Task: Implement drag-and-drop tool reordering within a tab. a5707cb
- [x] Task: Add the ability to add/remove specific tool inspectors to a tab. a5707cb
- [x] Task: Implement floating tool window support (simulated). a5707cb
- [x] Task: Commit Phase 3 & Build Check. de5b6dd

## Phase 4: Persistence & Validation (CaptureOneUI / AppCoreShared)
- [x] Task: Implement workspace JSON serialization and local file persistence. a5707cb
- [x] Task: Bind the UI to persist tool collapsed states automatically. a5707cb
- [x] Task: Create a test case: switch workspace -> verify tool order -> restart -> verify layout recovery. a5707cb
- [x] Task: Commit Phase 4 & Build Check. a5707cb
