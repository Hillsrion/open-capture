# Specification: Styles & Presets Browser Restoration (UI-010)

## Overview
This track focuses on the reconstruction of Capture One's Styles and Presets management system. A "Style" is a collection of adjustments that can be applied to an image, while a "Preset" is a collection of settings for a single tool. The reconstruction will feature a hierarchical browser with live hover previews, allowing users to visualize the impact of a style before applying it.

## Functional Requirements
- **Hierarchical Browser:** Reconstruct the tree-based navigation for styles (Built-in, User, Styles Packs) based on `StyleTreeItemProtocol`.
- **Live Hover Previews:** Implement the "Live Preview" logic discovered in `temporarilyAddStyleLayer`, where hovering over a style in the browser temporarily applies its adjustments to the `currentVariant` in the viewer.
- **Style Application:**
    - Single style application via click.
    - Stacked styles support (toggling "Stack Styles" discovered in `toggleStackStyles`).
    - Multi-variant application (based on `applyStylesToVariants`).
- **User Styles Management:** Support for importing (`importUserStyle`) and deleting (`deleteUserStyle`) custom styles.
- **UI Interaction:** Reconstruct the `StyleInspectorTool` with a high-fidelity table view matching the v16.5 design.

## Non-Functional Requirements
- **Performance:** Live previews must be near-instantaneous to ensure a fluid browsing experience.
- **Visual Accuracy:** Match the exact indentation, icons, and shortcut display of the original styles table.

## Acceptance Criteria
- Styles browser correctly displays the hierarchy of available styles.
- Hovering over a style triggers a temporary preview in the viewer.
- Clicking a style applies it to the selected variant(s).
- "Stack Styles" mode correctly manages multiple applied styles.

## Out of Scope
- Style editing/creation UI (to be handled in a future refinement track).
- Presets for specific tools (e.g., WB presets) will be implemented in their respective tool tracks.
