# Implementation Plan: Workspace Parity - Exposure, Details, Lens Tools

## Phase 1: Models & Data
- [x] Task: Inspect `AdjustmentToolController` and ensure properties exist for `vignettingAmount`, `dehazeAmount`, `rotationAngle`, `blackAndWhiteEnabled`, `cropRect`, etc. If missing, add them. 60846e9
- [x] Task: Commit Phase 1. 60846e9

## Phase 2: Exposure Palette
- [x] Task: Create `MatchLookToolView`, `BlackAndWhiteToolView`, `DehazeToolView`, `VignettingToolView`. b74f61d
- [x] Task: Update `ToolRegistry.swift` to route `MatchLook`, `BlackAndWhite`, `Dehaze`, and `Vignetting` to the new views. b74f61d
- [x] Task: Commit Phase 2. b74f61d

## Phase 3: Details Palette
- [x] Task: Create `NavigatorToolView`, `FocusToolView`, `SpotRemovalToolView`, `LensColorCorrectionsToolView`, `MoireToolView`. f839632
- [x] Task: Update `ToolRegistry.swift` to route `Navigator`, `Focus`, `SpotRemoval`, `LensColorCorrections`, and `Moire` to the new views. f839632
- [x] Task: Commit Phase 3. f839632

## Phase 4: Lens Palette
- [x] Task: Create `CropToolView`, `AICropToolView`, `RotationToolView`, `GridToolView`, `GuidesToolView`. 9712e11
- [x] Task: Update `ToolRegistry.swift` to route `Crop`, `AICrop`, `Rotation`, `Grid`, and `Guides` to the new views. 9712e11
- [x] Task: Commit Phase 4. 9712e11
