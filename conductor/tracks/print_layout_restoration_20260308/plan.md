# Implementation Plan: Print Layout Window Restoration

## Objective
Reconstruct the Print Layout Window (UI-012), enabling users to format and layout images for printing, including margins, grids, and multi-image placements.

## Key Files & Context
- `AppCoreShared/PrintModels.swift`: New models for print layouts, templates, and settings.
- `CaptureOneUI/PrintWindowController.swift`: The main window controller for the print interface.
- `CaptureOneUI/PrintLayoutView.swift`: The canvas area displaying the interactive print layout.
- `CaptureOneUI/PrintSettingsSidebar.swift`: Sidebar for adjusting margins, grid size, and printer settings.

## Implementation Steps

### Phase 1: Models & Data (AppCoreShared)
- [x] Task: Reconstruct `PrintTemplate` model (paper size, margins, cell layout). fc89687
- [x] Task: Reconstruct `PrintSettings` model (printer profile, rendering intent, resolution). fc89687
- [x] Task: Implement a `PrintManager` to manage the collection of templates. fc89687
- [x] Task: Commit Phase 1 & Build Check. fc89687

### Phase 2: Core Print Layout UI (CaptureOneUI)
- [ ] Task: Implement `PrintLayoutView` using `Canvas` or `GeometryReader` to draw the paper bounds and image cells.
- [ ] Task: Implement drag-and-drop or selection logic to place images into cells.
- [ ] Task: Commit Phase 2 & Build Check.

### Phase 3: Settings Sidebar (CaptureOneUI)
- [ ] Task: Create `PrintSettingsSidebar` with controls for margins (Top, Bottom, Left, Right).
- [ ] Task: Add controls for grid layout (Rows, Columns, Spacing).
- [ ] Task: Wire the sidebar controls to update the `PrintTemplate` in real-time.
- [ ] Task: Commit Phase 3 & Build Check.

### Phase 4: Integration & Window Controller (CaptureOneUI / App)
- [ ] Task: Assemble the `PrintWindowController` integrating the layout view and sidebar.
- [ ] Task: Add a "Print" button to the main toolbar or file menu to trigger the window.
- [ ] Task: Commit Phase 4 & Build Check.

## Verification & Testing
- Test Case: Open Print Window -> Verify default A4/Letter layout is shown.
- Test Case: Adjust margins in sidebar -> Verify the canvas updates instantly.
- Test Case: Change grid to 2x2 -> Verify 4 cells are rendered on the page.
