# Implementation Plan: High-Speed Image Browsing and Rendering Integration

## Phase 1: Folder Scanning & Asset Mapping [checkpoint: 5a85c6d]
- [x] Task: Map the `CImageBrowser` and `ThumbnailCache` logic from disassembly. 75a2eb4
- [x] Task: Implement actual folder scanning in `MOFolderCollection` using `FileManager`. 75a2eb4
- [x] Task: Create a base `ThumbnailManager` using `ImageIO` or `QuickLook` for fast extraction. 75a2eb4
- [x] Task: Conductor - User Manual Verification 'Phase 1: Folder Scanning & Asset Mapping' (Protocol in workflow.md) 75a2eb4

## Phase 2: Image Browser UI Implementation
- [x] Task: Reconstruct the `ImageBrowserView` in `CaptureOneUI` using a SwiftUI `LazyVGrid`. 5a85c6d
- [x] Task: Implement thumbnail cell views with metadata overlays (rating, tags). 5a85c6d
- [~] Task: Connect browser selection events to the global `ObjectContext`.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Image Browser UI Implementation' (Protocol in workflow.md)

## Phase 3: Viewer & Rendering Integration
- [ ] Task: Create a `ImageViewerView` in `CaptureOneUI` for high-resolution display.
- [ ] Task: Integrate `ImageCorePipeline` to render the selected image with default settings.
- [ ] Task: Implement asynchronous image loading to keep the UI responsive.
- [ ] Task: Finalize end-to-end data flow from folder selection to image display.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Viewer & Rendering Integration' (Protocol in workflow.md)
