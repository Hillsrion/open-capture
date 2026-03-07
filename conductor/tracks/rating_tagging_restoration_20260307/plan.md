# Implementation Plan: Rating & Color Tagging Restoration

## Phase 1: Data Model & Logic (AppCoreShared)
- [x] Task: Update `MCVariant` to handle `ZRATING` and `ZCOLOR_TAG` properties.
- [x] Task: Implement `VariantBase` methods for setting and getting rating/color tags.
- [x] Task: Commit Phase 1: Data Model.

## Phase 2: UI Components (CaptureOneUI)
- [x] Task: Reconstruct `PORatingControl` (interactive star component).
- [x] Task: Reconstruct `POColorTagPicker` (color swatch component).
- [x] Task: Integrate controls into the Metadata section or a new Culling tool.
- [x] Task: Commit Phase 2: UI Components.

## Phase 3: Browser Overlays & Shortcuts
- [ ] Task: Update `COImageBrowserView` to show rating/color tag overlays on thumbnails.
- [ ] Task: Implement keyboard shortcuts (1-5 for stars, 6-9 for colors).
- [ ] Task: Commit Phase 3: Integration.

## Phase 4: Validation
- [ ] Task: Build and verify the culling workflow.
- [ ] Task: Commit Phase 4: Finalization.
