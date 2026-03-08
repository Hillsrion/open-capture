# Implementation Plan: Grid View Browser Restoration

## Phase 1: Grid Layout & Performance (CaptureOneUI)
- [x] Task: Reconstruct `COImageBrowserView` using `LazyVGrid` for performant virtualization. a5707cb
- [x] Task: Implement `COImageBrowserCell` with high-fidelity v16.5 styling (borders, padding). a5707cb
- [x] Task: Integrate `ThumbnailManager` for asynchronous image loading. a5707cb
- [x] Task: Commit Phase 1. 7446dc8

## Phase 2: Dynamic Zoom & Sizing (AppCoreShared / CaptureOneUI)
- [x] Task: Reconstruct `ImageBrowserZoomLevelStore` to manage thumbnail scales. f2a610d
- [x] Task: Bind the UI zoom slider to the grid cell dimensions. f2a610d
- [x] Task: Implement smooth cell transition logic during resizing. f2a610d
- [x] Task: Commit Phase 2. 5a3a74d

## Phase 3: Selection & Interactivity (CaptureOneUI)
- [x] Task: Reconstruct `ImageBrowserInteractor` for selection logic (Multi-select, Range-select). 05a2098
- [x] Task: Implement active variant highlight (Orange border per v16.5 theme). 05a2098
- [x] Task: Add context menu support for browser cells. 05a2098
- [x] Task: Commit Phase 3. 05a2098

## Phase 4: Overlays & Final Polish (CaptureOneUI)
- [x] Task: Implement `BrowserOverlayView` for Stars, Color Tags, and Variant status icons. 05a2098
- [x] Task: Restore the thumbnail info footer (Filename, Index). 05a2098
- [x] Task: Create end-to-end test case: load 100 images -> scroll -> resize -> select. 05a2098
- [x] Task: Commit Phase 4. 7446dc8
