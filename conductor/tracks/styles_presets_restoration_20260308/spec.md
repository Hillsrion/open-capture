# Specification: Heal & Clone Tools Restoration (UI-006)

## Overview
This track focuses on the reconstruction of Capture One's advanced retouching tools: the Heal and Clone brushes. Unlike standard brushes, these tools require two points: a source (where the texture is sampled from) and a destination (where the texture is applied). The reconstruction will include the interactive source point selection, the visual "Repair Arrow" linking them, and the underlying data structures.

## Functional Requirements
- **Interactive Retouching:**
    - **Heal Brush:** Reconstruct the logic to sample source texture and blend it into the destination, matching color and lighting.
    - **Clone Brush:** Reconstruct the logic for exact pixel-for-pixel copying from source to destination.
- **Repair Arrows:**
    - **Visual Feedback:** Implement the "Repair Arrow" overlay discovered in the symbols (`RepairArrow`) that links source and destination points.
    - **Point Management:** Allow users to move both source and destination points after they've been placed.
    - **Auto-Source:** Implement the algorithm that automatically finds a suitable source point if one isn't manually selected.
- **Data Models:** Reconstruct `RepairArrow` (or `RetouchPoint`) with `sourcePoint`, `destinationPoint`, and `arrowType` (Heal vs Clone).
- **Layer Integration:** Integrate retouching points into specialized `LayerBase` types: `heal` and `clone`.
- **UI Interaction:**
    - Reconstruct the cursor behavior for retouching (circle for brush size, crosshair for source).
    - Ensure retouching operations are non-destructive and can be toggled via layer visibility.

## Non-Functional Requirements
- **Responsiveness:** Source point movement must update the viewer's rendering in real-time.
- **Visual Accuracy:** Retouching points must be precisely aligned with the underlying raw image coordinates, accounting for zoom and crop.

## Acceptance Criteria
- Ability to draw heal/clone strokes on specialized layers.
- Interactive Repair Arrows that can be moved and deleted.
- Correct blending (Heal) and copying (Clone) simulation in the viewer.
- "Clear Manual Source Point" functionality works as discovered in symbols.

## Out of Scope
- AI-based "Magic Brush" (handled in `AI-001`).
- Advanced frequency separation retouching.
