# Implementation Plan: Toolbar & Customization Restoration

## Objective
Reconstruct the customizable toolbar system (INT-001), enabling users to add, remove, and reorder tool icons in the main application window.

## Key Files & Context
- `AppCoreShared/ToolbarModels.swift`: Models for toolbar items and configurations.
- `CaptureOneUI/MainToolbarView.swift`: The main toolbar component.
- `CaptureOneUI/ToolbarCustomizationDialog.swift`: UI for modifying the toolbar.
- `AppCoreShared/WorkspaceModels.swift`: Update `Workspace` to include toolbar configuration.

## Implementation Steps

### Phase 1: Models & Persistence (AppCoreShared)
- [x] Task: Reconstruct `ToolbarItem` and `ToolbarConfiguration` models. fc89675
- [x] Task: Update `Workspace` model to include a `toolbarConfiguration` field. fc89675
- [x] Task: Implement serialization for toolbar states. fc89675
- [x] Task: Commit Phase 1 & Build Check. fc89675

### Phase 2: Toolbar Component (CaptureOneUI)
- [x] Task: Reconstruct the `MainToolbarView` with support for dynamic items. fc89676
- [x] Task: Implement the "Standard" set of toolbar items (Select, Pan, Loupe, Crop, Rotate, etc.). fc89676
- [x] Task: Add support for "Flexible Spacers" and "Fixed Spacers". fc89676
- [x] Task: Commit Phase 2 & Build Check. fc89676

### Phase 3: Customization Engine (CaptureOneUI)
- [x] Task: Implement the `ToolbarCustomizationDialog` (Grid of available items). fc89677
- [x] Task: Implement drag-and-drop logic for reordering and adding/removing items. fc89677
- [x] Task: Add "Reset to Default" functionality. fc89677
- [x] Task: Commit Phase 3 & Build Check. fc89677

### Phase 4: Integration (CaptureOneApp)
- [ ] Task: Integrate the new toolbar into the main application window.
- [ ] Task: Create a test case: modify toolbar configuration -> save workspace -> reload -> verify items.
- [ ] Task: Commit Phase 4 & Build Check.

## Verification & Testing
- Test Case: Add a custom item to the toolbar -> Verify it appears in the UI.
- Test Case: Reorder items via `ToolbarConfiguration` -> Verify visual order matches.
- Test Case: Switch workspaces -> Verify toolbar updates to the new workspace's configuration.
