# Specification: Workspace Parity - Library Organize Workflow

## Context
Per `backlog.md` (UI-201, GAP-402, UI-214, UI-215): The `Library` palette currently exists but is a session-folder stub. It lacks smart albums, albums, favorites management, system folders, and richer organize workflows.

## Objectives
- **GAP-402**: Restore album/smart album management in the main `Library` UX (since Data and predicates already exist).
- **UI-201**: Implement `Library`, `MetadataFilters`, `Keywords`, `KeywordLibrary`, `Metadata` to fully cover the organize workflows instead of just session folders.
- **UI-214**: Finish Library session structure. `LibraryToolView` should show `Session Folders`, `Session Albums`, `Session Favorites`, `System Folders`, per-section `+`/`-` actions, and richer structure.
- **UI-215**: Implement folder row context menu. Folder rows need `New`, `Rename`, `Sort Albums and Favorites By Name`, `Remove from Favorites`, `Import`, `Export`, all four `Set as ... Folder` variants, Finder/Library info actions, and session trash maintenance.

## Scope
- Refactor `LibraryToolView` inside `CaptureOneUI` to include `OutlineView` or similar representing the full folder taxonomy.
- Wire context menus to actions matching decompiled behavior.
- Link DataCore `Predicate` and `SmartAlbum` to the UI.
