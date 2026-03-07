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

# Guidelines & Mandates
- **Documentation:** Technical documentation in `reconstructed_codebase/docs/`.
- **Token Reporting:** Regular "Session Token Reports" in `docs/token_usage.md`.
- **Git Hygiene:** Commit regularly and provide detailed descriptions in git to preserve context and history.
- **Skill Creation:** Formalize repetitive reverse-engineering tasks into Gemini CLI skills.
