# Capture One Feature History & Architectural Milestones

This document provides a historical overview of Capture One's feature evolution. It serves as a mapping guide to identify legacy vs. modern logic during the reconstruction process.

## 1. Major Version Milestones

### Capture One 12 (2018) - The Foundation of Modern Masking
- **Luma Range Masking:** Introduction of luminosity-based masking logic.
  - *Keywords:* `LumaRange`, `BrightnessMask`.
- **Parametric Masking:** Radial and Linear gradient tools.
  - *Keywords:* `RadialGradient`, `LinearGradient`.
- **Plugin System:** Launch of the third-party extension architecture.
  - *Keywords:* `PluginCore`, `COPlugin`.

### Capture One 20 (2019) - Refined Color & HDR
- **Direct Color Editor:** Interaction-based color adjustments.
  - *Keywords:* `DirectColorEditor`, `ColorCorrection`.
- **HDR Tool Expansion:** Addition of Black and White recovery logic.
  - *Keywords:* `HDRTool`, `HighDynamicRange`.
- **Scrolling Tools:** Architectural shift in UI tool management.

### Capture One 21 (2020) - Pro Workflow & Speed
- **Speed Edit:** Hotkey-based adjustment logic.
  - *Keywords:* `SpeedEdit`, `KeyboardAdjustment`.
- **Dehaze:** Dedicated atmospheric haze removal algorithm.
- **ProStandard Profiles:** Next-gen camera color science.
  - *Keywords:* `ProStandard`, `CameraProfile`.

### Capture One 22 (2021) - Computational Photography
- **Panorama Stitching:** Logic for merging RAW files into panoramas.
  - *Keywords:* `PanoramaStitcher`, `DNGMerge`.
- **HDR Merging:** Multi-exposure fusion logic.
- **Auto Rotate:** AI-driven horizon leveling.
  - *Keywords:* `AutoRotate`, `HorizonDetection`.

### Capture One 23 / v16.0 (2022) - Smart Automation
- **Smart Adjustments:** AI-powered Exposure/WB matching across images.
  - *Keywords:* `SmartAdjustments`, `AIBalance`.
- **Cull View:** High-speed rating/tagging engine.
  - *Keywords:* `CullView`, `FastPreview`.
- **Layers in Styles:** Nested adjustment layers within presets.

### Capture One 16.3+ (2023-2025) - The AI Era
- **AI Masking:** Subject and Background segmentation.
  - *Keywords:* `AISegmentation`, `SubjectDetection`, `BackgroundMask`.
- **Match Look (16.5):** AI reference-based color grading.
- **Retouch Tools:** AI-powered eye and teeth enhancement.

## 2. Core Architectural Pillars (Persistent)

### Data Management
- **Catalog vs. Session:** Two distinct modes of project management.
  - *Catalog:* Centralized SQLite database.
  - *Session:* Folder-based workflow with sidecar files.
- **Variants:** The core non-destructive editing model (multiple versions per RAW file).

### Processing Engine
- **Engine Versions:** Legacy support for older processing engines (e.g., Engine 9, 10, 11, 12).
- **Hardware Acceleration:** Logic for OpenCL (legacy) and Metal (modern) GPU processing.

### Metadata & XMP
- **Full IPTC/EXIF/XMP support.**
- **Sync Logic:** Synchronizing sidecar files with the internal database.
