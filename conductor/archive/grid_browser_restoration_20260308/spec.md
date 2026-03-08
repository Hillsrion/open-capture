# Specification: Grid View Browser Restoration (UI-005)

## Overview
This track focuses on the deep reconstruction of Capture One's main image browser. We will restore the high-performance grid engine capable of handling thousands of images with smooth scrolling, dynamic thumbnail resizing, and complex selection states. The reconstruction will bridge the gap between the simple filmstrip and a professional production browser.

## Functional Requirements
- **High-Performance Grid:** Reconstruct the grid layout engine (based on `ImageBrowserInteractor`) using `LazyVGrid` or a custom `NSScrollView` wrapper for extreme performance.
- **Dynamic Resizing:** Implement the thumbnail zoom system (based on `ImageBrowserZoomLevelStore`), allowing the grid to scale between tiny icons and large preview-ready cells.
- **Selection Management:** Restore the multi-selection logic, including Shift+Click and Cmd+Click patterns, synchronized with the `currentVariant` in the `AdjustmentToolController`.
- **Thumbnail Fidelity:** Ensure each cell displays:
    - High-quality thumbnail from `ThumbnailManager`.
    - Rating (stars) and Color Tag overlays.
    - File metadata (Name, Extension, processed status).
    - Variant-specific icons (cloned, variants).
- **Interactive States:** Implement hover effects, dragging for reordering/moving, and context menu integration.

## Non-Functional Requirements
- **Scrolling Smoothness:** Maintain 60fps scrolling even with 10,000+ items using aggressive cell reuse and async thumbnail loading.
- **Visual Accuracy:** Match the exact spacing, borders (especially the active variant highlight), and font sizes of the v16.5 UI.

## Acceptance Criteria
- Fluidly scrolling grid containing all images from the selected session/folder.
- Working zoom slider that live-updates the grid cell size.
- Correct rendering of all overlays (Stars, Tags) discovered in `UI-009`.
- Multi-selection state correctly shared with other tools (Viewer, Layers).

## Out of Scope
- List view mode (to be handled in a future refinement track).
- Contact sheet printing from the browser (handled in `UI-012`).
