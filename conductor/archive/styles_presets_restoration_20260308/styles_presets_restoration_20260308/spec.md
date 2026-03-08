# Specification: Color Wheels UI Restoration (UI-003)

## Overview
This track focuses on the reconstruction of Capture One's iconic 3-Way Color Balance tool. The interface features circular color wheels for granular control over the Hue, Saturation, and Brightness of Shadows, Midtones, and Highlights. The reconstruction will ensure high-fidelity visual rendering and precise mouse interaction for professional color grading.

## Functional Requirements
- **3-Way Color Control:** Reconstruct the `POColorBalanceControl` logic, providing separate wheels for:
    - **Master:** Global color offsets.
    - **Shadows:** Color grading in the dark areas.
    - **Midtones:** Color grading in the middle exposures.
    - **Highlights:** Color grading in the bright areas.
- **Interactive Wheels:**
    - **Hue/Saturation:** 2D circular picker for selecting hue (angle) and saturation (distance from center).
    - **Brightness Slider:** Peripheral arc slider for managing the lightness of each color range.
- **Layout Switcher:** Implement the layout logic discovered in `ColorWheelLayout`, allowing users to switch between "Master", "3-Way", and individual wheel views.
- **Model Binding:** Bind wheel positions to the `ZCOLOR_BALANCE_...` keys in the variant settings.
- **Visual Fidelity:** Match the exact gradient rendering, active highlight orange, and crosshair styles of the v16.5 UI.

## Non-Functional Requirements
- **Interaction Smoothness:** Color updates must be reflected in the viewer in real-time with zero lag.
- **Math Precision:** Implement correct coordinate transformations between polar (Hue/Sat) and Cartesian (UI space) systems.

## Acceptance Criteria
- Functional 3-way color wheels that update the variant's color balance settings.
- Live preview in the viewer when interacting with any wheel.
- Correct rendering of the circular hue gradients and specialized sliders.
- Support for resetting individual wheels via double-click or a reset icon.

## Out of Scope
- AI-based color grading suggestions (handled in `AI-002`).
- ICC-based color editing (handled in `ENG-004`).
