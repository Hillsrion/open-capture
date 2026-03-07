# Specification: High-Speed Image Browsing and Rendering Integration

## Overview
Now that the core frameworks and GUI are integrated, this track focuses on implementing the actual image browsing and rendering capabilities. We will reconstruct the logic for scanning directories, generating and caching thumbnails, and displaying images in a grid (Browser) and a high-fidelity viewer.

## Functional Requirements
- **Folder Scanning:** Implement the logic in `MOFolderCollection` to scan the filesystem for supported image formats (RAW, JPEG, TIFF).
- **Thumbnail Generation:** Reconstruct the thumbnail extraction and caching system, utilizing `ImageIO` or `QuickLook` for performance.
- **Image Browser UI:** Implement a performant grid view in `CaptureOneUI` to display thumbnails with basic metadata (rating, color tag).
- **High-Fidelity Viewer:** Connect the `ImageCorePipeline` to a primary viewer area to render the selected image with basic adjustments.
- **Selection Synchronization:** Ensure that selecting an image in the browser correctly updates the global application state and the viewer.

## Non-Functional Requirements
- **High Performance:** Browsing through folders with hundreds of images must feel instantaneous (using asynchronous loading and caching).
- **Modern Swift:** Implement using SwiftUI for the grid and viewer, with AppKit bridging where necessary for performance.
- **Modular Integrity:** Keep browsing logic in `AppCoreShared` and rendering logic in `ImageCore`.

## Acceptance Criteria
- Capability to point the application to a local folder and see its images appear in a grid.
- Selecting an image displays it in the larger viewer area.
- Thumbnails are cached to avoid redundant processing.

## Out of Scope
- Complex adjustment editing (exposure, curves) - only basic rendering for now.
- Integration with external/cloud catalogs.
