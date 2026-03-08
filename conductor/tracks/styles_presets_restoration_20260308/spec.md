# Specification: Keyboard Shortcuts System Restoration (INT-002)

## Overview
This track focuses on the reconstruction of Capture One's robust keyboard shortcut system. Professional photographers rely heavily on shortcuts for rapid culling, editing, and workflow management. The system supports multiple shortcut "sets" (e.g., Default, Lightroom legacy), per-tool mappings, and synchronization across devices via the Cloud framework.

## Functional Requirements
- **Shortcut Management:**
    - **Mapping Engine:** Reconstruct the core `KeyboardShortcutManager` that maps key combinations (e.g., `⌘E`) to specific internal actions (e.g., `Export`).
    - **Shortcut Sets:** Support multiple predefined and user-created shortcut sets.
    - **Conflict Detection:** Implement logic to detect and resolve overlapping shortcut assignments.
- **Dynamic Tooltips:**
    - **UI Integration:** Reconstruct the logic discovered in `EnhancedTooltipScene` to display current shortcuts next to tool names in tooltips.
    - **Live Updates:** Ensure tooltips reflect changes immediately when the shortcut set is switched.
- **Data Models:**
    - **KeyboardShortcut:** Reconstruct the model for a single shortcut (Key, Modifier, ActionID).
    - **ShortcutSet:** Reconstruct the container for a full collection of shortcuts.
- **Persistence:** Save and load shortcut sets from JSON or Property List files in the application support directory.
- **Cloud Sync:** Implement the `CloudSettingsKeyboardShortcutsHandlerProtocol` to allow synchronization of custom shortcut sets.

## Non-Functional Requirements
- **Latency:** Shortcut resolution must be near-instantaneous (< 5ms) to ensure a responsive feel.
- **Extensibility:** The system must be able to handle 500+ unique actions without performance degradation.

## Acceptance Criteria
- Ability to trigger core actions (Exposure +, Rating 5, Export) via keyboard.
- Switching between "Default" and "Lightroom" shortcut sets correctly updates all mappings.
- Tooltips correctly display the mapped shortcut for the hovered tool.
- Custom shortcuts are correctly persisted across application restarts.

## Out of Scope
- MIDI controller mapping (handled in `INT-005`).
- Gesture-based shortcuts (e.g., Trackpad swipes).
