# Initial Concept
Reconstruct a comprehensive, compilable, and functional codebase from the compiled macOS application bundle `Capture One.app` for educational and learning purposes.

# Product Guide

## Overview
The goal of this project is to reverse-engineer and reconstruct the full source code of Capture One. This is an ambitious undertaking aimed at creating a version of the software that can be compiled, run, and used, while serving as a deep learning resource for high-performance macOS application development, image processing, and modular architecture.

## Primary Objective: Educational/Learning
- Deeply understand the internals of a professional-grade RAW photo editor.
- Explore large-scale Swift and Objective-C interoperability.
- Map the interactions between proprietary frameworks and macOS system libraries.

## Success Criteria: Compilable and Functional
- Reconstructed modules must compile successfully.
- The resulting software must be functional and usable.
- Functional understanding of key algorithms (ImageCore, processing engine).

## Scope & Focus Areas: Comprehensive Reconstruction
- **Core Processing:** `ImageCore`, `ImageProcessing`, and RAW conversion logic.
- **Business Logic & Data:** `AppCoreShared`, `DataCore`, and `ModelCore`.
- **Infrastructure:** `COFoundation`, `IdentityManagement`, and `Cloud` frameworks.
- **Extensibility:** `PluginCore`, XPC services, and the `.coplugin` ecosystem.

## Documentation Strategy: Architectural Overview
- Maintain high-level architectural overviews of all reconstructed modules.
- Map module-level interactions and data flows.
- Track reconstruction progress against the original `.app` bundle.
- **Status:** Disassembly and metadata extraction pipeline established using LLVM 17+ tools.
- **Status:** Core data models (Image, Variant, Collection, Session) and logic coordination (ObjectContext) reconstructed for `AppCoreShared`. License checks and telemetry neutralized.
- **Status:** Processing pipeline, Metal GPU dispatching, and Masking engine (LumaRange/Local AI) reconstructed for `ImageCore`.
- **Status:** SQLite schema mapped and persistence layer (Catalogs/Sessions/Sidecars) reconstructed for `DataCore`.
- **Status:** Presentation layer (Themes, Custom Controls, Windowing, Tool Views) reconstructed for `CaptureOneUI`.
- **Status:** High-speed image browsing (folder scan, thumbnail caching) and high-fidelity viewer integrated across all core frameworks.
- **Status:** Lens Correction (Distortion, CA, Light Falloff) and LCC (Lens Cast Calibration) engine reconstructed and integrated into the ImageCore pipeline.
- **Status:** Import Engine (POImporter) reconstructed with support for source scanning, token-based renaming, and catalog registration.
- **Status:** Session Folder management reconstructed, including path resolution for Capture/Selects/Output/Trash and routing logic.
- **Status:** High-performance Grid Browser reconstructed with resizable thumbnails, multi-selection interactor, and high-fidelity overlays.
- **Status:** Noise Reduction (Luminance, Color, Detail) and Sharpening (Amount, Radius, Halo Control) engine reconstructed and integrated into the ImageCore pipeline.
- **Status:** Styles & Presets system reconstructed with hierarchical browser, live hover previews, and stacking support.
- **Status:** 3-Way Color Balance tool reconstructed with interactive circular wheels, polar coordinate math, and multi-layout support.
- **Status:** Magic Brush and Smart Masking engine reconstructed with tolerance-based region growing, edge refinement, and AI subject/background segmentation.
- **Status:** Heal & Clone tools reconstructed with interactive "Repair Arrow" overlays, auto-source logic, and specialized retouching layers.
- **Status:** Procedural Film Grain engine reconstructed with luminance-weighted noise generation and multiple film types (Fine, Silver Rich, Soft, Cubic).
- **Status:** Annotations system reconstructed with interactive drawing layer, freehand strokes, and text notes supported on the viewer.
- **Status:** Keyboard Shortcuts system reconstructed with dynamic mapping, conflict detection, and real-time UI/tooltip integration.
- **Status:** Hierarchical Keywords management reconstructed with centralized library, tree-based taxonomy, and session database persistence.

# Guidelines & Mandates
- **Documentation:** Technical documentation in `reconstructed_codebase/docs/`.
- **Token Reporting:** Regular "Session Token Reports" in `docs/token_usage.md`.
- **Git Hygiene:** Commit regularly and provide detailed descriptions in git to preserve context and history.
- **Skill Creation:** Formalize repetitive reverse-engineering tasks into Gemini CLI skills.
