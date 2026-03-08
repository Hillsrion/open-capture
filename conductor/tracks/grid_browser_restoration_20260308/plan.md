# Implementation Plan: Grid View Browser Restoration

## Phase 1: Grid Layout & Performance (CaptureOneUI)
- [~] Task: Reconstruct `COImageBrowserView` using `LazyVGrid` for performant virtualization.
- [ ] Task: Implement `COImageBrowserCell` with high-fidelity v16.5 styling (borders, padding).
- [ ] Task: Integrate `ThumbnailManager` for asynchronous image loading.
- [ ] Task: Commit Phase 1.

## Phase 2: Dynamic Zoom & Sizing (AppCoreShared / CaptureOneUI)
- [ ] Task: Reconstruct `ImageBrowserZoomLevelStore` to manage thumbnail scales.
- [ ] Task: Bind the UI zoom slider to the grid cell dimensions.
- [ ] Task: Implement smooth cell transition logic during resizing.
- [ ] Task: Commit Phase 2.

## Phase 3: Selection & Interactivity (CaptureOneUI)
- [ ] Task: Reconstruct `ImageBrowserInteractor` for selection logic (Multi-select, Range-select).
- [ ] Task: Implement active variant highlight (Orange border per v16.5 theme).
- [ ] Task: Add context menu support for browser cells.
- [ ] Task: Commit Phase 3.

## Phase 4: Overlays & Final Polish (CaptureOneUI)
- [ ] Task: Implement `BrowserOverlayView` for Stars, Color Tags, and Variant status icons.
- [ ] Task: Restore the thumbnail info footer (Filename, Index).
- [ ] Task: Create end-to-end test case: load 100 images -> scroll -> resize -> select.
- [ ] Task: Commit Phase 4.
