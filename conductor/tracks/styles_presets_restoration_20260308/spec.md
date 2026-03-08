# Specification: Workspace Manager Restoration (UI-013)

## Overview
This track focuses on the reconstruction of Capture One's flexible workspace management system. Professional users customize their UI by adding, removing, and reordering tool inspectors across multiple tabs and sidebars. The workspace manager ensures these configurations (panel visibility, tool order, floating windows) are persisted and can be switched via presets.

## Functional Requirements
- **Layout Management:**
    - **Inspector Tool Layout:** Reconstruct the `InspectorToolLayout` logic to manage the vertical stacking and collapsible state of tools in the sidebars.
    - **Tab System:** Reconstruct the `InspectorToolTabView` to handle tool categorization (e.g., Color, Exposure, Metadata).
- **Customization:**
    - **Tool Reordering:** Provide an API to change the order of tools within a sidebar.
    - **Floating Tools:** Support "floating" tools that can be positioned anywhere on the screen independently of the main window.
- **Data Models:**
    - **Workspace:** Reconstruct the model for a full UI state (tabs, tool order, sidebar width).
    - **ToolConfiguration:** Model for a single tool's state (collapsed, height).
- **Persistence:**
    - **Local Storage:** Save and load workspace configurations as JSON/PLIST files.
    - **Default Workspaces:** Provide standard presets (e.g., "Simplified", "Tethered", "Wedding").

## Non-Functional Requirements
- **UI Responsiveness:** Switching workspaces must be fluid, with layout recalculations performed efficiently.
- **Persistence Stability:** UI state must be recovered exactly as left upon application restart.

## Acceptance Criteria
- Ability to switch between multiple predefined workspace layouts.
- Collapsing/Expanding a tool correctly persists its state.
- Changing the tool tab (e.g., from Library to Capture) correctly updates the sidebar content.
- Custom tool orders are preserved across session restarts.

## Out of Scope
- Multi-monitor window spanning (beyond basic dual-monitor layout support).
- Theme customization (handled in `UI-001`).
