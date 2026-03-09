# Capture One Feature History & Architectural Milestones

This document provides a comprehensive historical overview of Capture One's evolution. It serves as a mapping guide to identify legacy vs. modern logic during the reconstruction process.

## 1. Early Era & Core Foundations (v4 - v11)

### Capture One 4 (2007) - Modern Era Genesis
- **Redesigned UI:** Complete overhaul of the interface.
- **DSLR Expansion:** Shift from medium format only to broad DSLR support.

### Capture One 6 (2010) - Local Adjustments & Mobile
- **Local Adjustments:** First implementation of brushes and localized editing logic.
- **Capture Pilot:** Introduction of wireless iOS tethering/viewing logic.
  - *Keywords:* `CapturePilot`, `WirelessTethering`.

### Capture One 7 (2012) - The Catalog System
- **Catalogs (DAM):** Major architectural shift adding a Digital Asset Management system alongside Sessions.
  - *Keywords:* `Catalog`, `CollectionBase`, `MOCollection`.
- **Live View:** Remote sensor feed for tethered DSLRs.

### Capture One 8 (2014) - Layers & Retouching
- **Repair Layers:** Dedicated **Clone** and **Heal** layer types.
  - *Keywords:* `RepairLayer`, `CloneLayer`, `HealLayer`.
- **Film Grain:** High-quality grain simulation algorithm.

### Capture One 9 (2015) - Metadata & Engine 9
- **New Contrast Engine:** Reworked core processing algorithms.
- **Luma Curves:** Luminance-only curve adjustments.
  - *Keywords:* `LumaCurve`, `LumaAdjustment`.
- **Keyword Tool:** Rebuilt keyword management and hierarchy logic.

### Capture One 11 (2017) - Layer-Centric Architecture
- **Full Layer Compatibility:** Most adjustment tools became compatible with layers.
- **Layer Opacity:** Implementation of per-layer transparency control.
- **Annotations:** Ability to draw/write on images (metadata-linked).
  - *Keywords:* `Annotation`, `RefineMask`, `FeatherMask`.

## 2. Recent Major Milestones (v12 - v16.x)

### Capture One 12 (2018) - Advanced Masking
- **Luma Range Masking:** Parametric masking based on luminosity.
  - *Keywords:* `LumaRange`, `BrightnessMask`.
- **Plugin System:** Launch of the third-party extension architecture.
  - *Keywords:* `PluginCore`, `COPlugin`.

### Capture One 20 (2019) - Refined Color & HDR
- **Direct Color Editor:** Interaction-based color adjustments.
- **HDR Tool Expansion:** Addition of Black and White recovery logic.

### Capture One 21 (2020) - Pro Workflow & Speed
- **Speed Edit:** Hotkey-based adjustment logic.
- **ProStandard Profiles:** High-fidelity camera color science.

### Capture One 22 (2021) - Computational Photography
- **Panorama & HDR Merging:** Built-in DNG stitching and fusion.
  - *Keywords:* `PanoramaStitcher`, `HDRMerge`.
- **Auto Rotate:** AI-driven horizon leveling.

### Capture One 23 / v16.0 (2022) - Smart Automation
- **Smart Adjustments:** AI-powered Exposure/WB matching across images.
- **Cull View:** High-speed rating/tagging engine.

### Capture One 16.3+ (2023-2025) - The AI Era
- **AI Masking:** Subject and Background segmentation.
  - *Keywords:* `AISegmentation`, `SubjectDetection`, `BackgroundMask`.
- **Match Look (16.5):** AI reference-based color grading.

## 3. Core Architectural Pillars (Persistent)

### Data Management
- **Catalog vs. Session:** Two distinct modes of project management.
- **Variants:** The core non-destructive editing model (multiple versions per RAW file).

### Processing Engine
- **Engine Versions:** Legacy support for older processing engines (e.g., Engine 9, 10, 11, 12).
- **Hardware Acceleration:** Shift from OpenCL (legacy) to Metal (modern) GPU processing.
