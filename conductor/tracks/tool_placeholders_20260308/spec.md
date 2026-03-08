# Specification: Workspace Parity - Exposure, Details, Lens Tools

## Context
Per the backlog (`UI-202`, `UI-203`, `UI-204`), several tools in the Exposure, Details, and Lens palettes are currently placeholders (reachable via the UI only through `UnavailableToolView`). To reach full workspace parity with the decompiled application, we must replace these placeholders with implemented tool views and bind them to the underlying data models.

## Objectives
- **UI-202**: Restore Exposure palette parity by providing adapter or implemented views for `MatchLook`, `BlackAndWhite`, `Dehaze`, and `Vignetting`.
- **UI-203**: Restore Details palette parity by providing views for `Navigator`, `Focus`, `SpotRemoval`, `LensColorCorrections`, and `Moire`.
- **UI-204**: Restore Lens palette parity by providing views for `Crop`, `AICrop`, `Rotation`, `Grid`, and `Guides`.

## Scope
- Create SwiftUI tool views for the remaining placeholders in Exposure, Details, and Lens.
- Update `ToolRegistry.swift` to route these Tool IDs to their newly implemented views instead of `UnavailableToolView`.
- Make sure data models (`AdjustmentToolController` / `ImageBase` or newly created minimal models) exist to persist these adjustments.

## Technical Details
- **MatchLook**: A button that matches exposure/color properties of a reference image. (Skeleton implementation is fine if ML isn't ready).
- **BlackAndWhite**: Toggle for B&W enabled, with red/yellow/green/cyan/blue/magenta sliders.
- **Dehaze**: Amount slider and shadow tone color picker.
- **Vignetting**: Amount and Method selectors.
- **Navigator**: A thumbnail display of the crop/current image viewport.
- **Focus**: A magnified sub-view of the active image region.
- **SpotRemoval**: List of active healing spots.
- **LensColorCorrections**: Sliders for purple fringing, etc.
- **Moire**: Amount and Pattern sliders.
- **Crop**: X, Y, Width, Height, Aspect Ratio selection.
- **AICrop**: Auto-crop toggles/buttons.
- **Rotation**: Angle slider.
- **Grid**: Overlay toggle/settings.
- **Guides**: Overlay options.

Note: In this reconstruction phase, visually matching the tool headers and controls is priority #1. The actual image processing algorithms underneath can be mocked or simply proxy to the adjustment controller properties.
