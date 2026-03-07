# Capture One Architectural Overview (Reconstructed)

Based on Phase 1 (Resources) and Phase 2 (Headers/Disassembly), the architecture of Capture One is built upon a modular, framework-heavy macOS application model.

## Core Application Structure
- **Main Binary:** `Capture One.app/Contents/MacOS/Capture One`
- **Frameworks:** Extensive use of embedded frameworks (~40 internal frameworks). This indicates a highly modularized business logic layer.
- **XPC Services:** Use of separate processes for plugin hosting (`COPluginHostApple.xpc`), indicating a sandbox-aware architecture.
- **Architecture:** Primarily `arm64` (Apple Silicon) with legacy `x86_64` support in universal binaries.

## Notable Framework Modules
Based on extracted headers and symbol tables:
1. **`AppCoreShared`:** Likely the central business logic framework, bridging common data models across the UI and processing engine.
2. **`ImageCore` & `ImageProcessing`:** High-performance frameworks likely handling the RAW conversion, GPU-accelerated rendering (Metal), and pixel manipulations.
3. **`DataCore` & `ModelCore`:** The persistence and modeling layer, probably interacting with the catalog SQLite databases.
4. **`COFoundation`:** Low-level utilities and base classes extending standard Apple foundations.

## Reconstruction Findings
- **Metadata Extraction:** Modern binaries (2025+) utilize updated `DYLD` export formats. Tools like `dsdump` may crash; `objdump --macho --objc-meta-data` from LLVM 17+ is required for reliable extraction.
- **Swift Integration:** The application is heavily integrated with Swift. Metadata reveals extensive use of Swift classes and protocols across all major frameworks.
- **Disassembly Scale:** The main binary generates ~100MB of assembly code, while the entire framework suite generates over 2GB of raw assembly data.

## Resource Management
- **`Assets.car`:** Modern compiled assets managed via the standard Cocoa asset catalog system.
- **`.lproj`:** Standard macOS localization patterns.

## Reconstructed API Patterns
- **Objective-C / Swift Interop:** Seamless interoperability is observed, with Swift classes often bridged to Objective-C for consumption by legacy frameworks.
- **Service-Oriented Design:** Isolation of plugins via XPC for stability.
