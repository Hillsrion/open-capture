# Implementation Plan: Workspace Parity - Library Organize Workflow

## Phase 1: Library Structure Construction
- [x] Task: Update the `LibraryToolView` to incorporate `Session Albums`, `Session Favorites`, and `System Folders` alongside the existing `Session Folders`. 0999db9
- [x] Task: Ensure collapsible/expandable behavior and `+`/`-` actions for each section if applicable. 0999db9
- [x] Task: Commit Phase 1. 0999db9

## Phase 2: Album and Smart Album UI
- [x] Task: Connect DataCore's existing albums and smart albums (GAP-402) into the `Session Albums` section. 291ee03
- [x] Task: Implement "Create Album" and "Create Smart Album" UI flows from the `LibraryToolView`. 291ee03
- [x] Task: Commit Phase 2. 291ee03

## Phase 3: Folder Context Menus
- [x] Task: Implement the right-click context menu for folder rows in the Library view. 2a57f48
- [x] Task: Include `New`, `Rename`, `Sort Albums...`, `Remove from Favorites`, `Import`, `Export`, `Set as [Capture/Selects/Output/Trash] Folder`, Finder Info, and trash maintenance. 2a57f48
- [x] Task: Commit Phase 3. 2a57f48

## Phase 4: Remaining Organize Palette Tools [checkpoint: d39045ed]
- [x] Task: Verify that `MetadataFilters`, `Keywords`, `KeywordLibrary`, and `Metadata` views are accurately implemented and bound to DataCore rather than being generic stubs. d39045e
- [x] Task: Commit Phase 4. d39045e
