# Specification: Annotations System Restoration (UI-007)

## Overview
This track focuses on the reconstruction of Capture One's Annotations tool. This feature provides a dedicated drawing layer on top of the viewer, allowing photographers and art directors to sketch, circle areas of interest, or write notes directly on the image. These annotations are non-destructive and can be exported with the image or used as a guide for retouching.

## Functional Requirements
- **Drawing Layer:**
    - **Freehand Pen:** Reconstruct the logic for smooth freehand drawing using mouse/pen input.
    - **Annotations Notes:** Implement the ability to add text-based notes at specific coordinates.
- **Visual Feedback:**
    - **Viewer Overlay:** Implement the transparent overlay discovered in `VariantAnnotationsLayer` that renders on top of the `COViewerView`.
    - **Live Rendering:** Ensure strokes appear in real-time with anti-aliasing.
- **Data Models:**
    - **MCAnnotations:** Reconstruct the container for all annotations on a variant.
    - **MCAnnotationsLine:** Reconstruct the model for a single stroke (array of points, color, width).
    - **MCAnnotationsNote:** Reconstruct the model for a text note (text, coordinate).
- **Coordinate Mapping:** Ensure annotations are mapped to the raw image space, remaining correctly positioned regardless of viewer zoom or crop.
- **UI Interaction:**
    - **Annotations Inspector:** Reconstruct the tool in the sidebar with "Always Show" and "Include in Export" toggles.
    - **Eraser Tool:** Implement logic to remove specific strokes or notes.

## Non-Functional Requirements
- **Precision:** Drawing must be high-precision, matching the high-fidelity rendering of the v16.5 UI.
- **Persistence:** Annotations must be serialized and persisted in the session database (linked to `ZVARIANT`).

## Acceptance Criteria
- Ability to draw freehand strokes on top of the image in the viewer.
- Annotations remain correctly aligned during zoom and pan.
- Toggling "Display Annotations" correctly hides/shows the overlay.
- Annotations are correctly persisted across sessions.

## Out of Scope
- Pressure sensitivity for Wacom tablets (simulated as fixed width for now).
- Collaborative live annotations (shared over network).
