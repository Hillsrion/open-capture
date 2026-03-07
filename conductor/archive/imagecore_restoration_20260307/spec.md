# Specification: Full Restoration of ImageCore Processing Logic

## Overview
`ImageCore` is the high-performance heart of Capture One, responsible for RAW conversion, GPU acceleration via Metal, and complex image adjustment algorithms. This track aims for a full Swift restoration of its processing logic, ensuring 100% behavioral fidelity while maintaining a strictly local execution environment.

## Functional Requirements
- **RAW Conversion Pipeline:** Reconstruct the logic for managing different engine versions (Engine 9 through 16.x) and the conversion stages.
- **GPU/Metal Integration:** Reconstruct the Metal-based processing kernels and the coordination between CPU and GPU tasks.
- **Masking & Layer Logic:** Reconstruct Luma Range, Parametric Masking, and localized adjustment application logic.
- **Local AI Logic:** If AI-driven features (e.g., Subject/Background detection) are confirmed to run locally based on disassembly, reconstruct their implementation logic.
- **Dependency Neutralization:** Strictly remove any logic that requires external server pings or cloud-based processing.

## Non-Functional Requirements
- **Modern Swift Restoration:** Full port from assembly/ObjC to idiomatic Swift.
- **Performance Fidelity:** Ensure the reconstructed logic maintains the high-performance characteristics of the original engine.
- **Strictly Local:** Zero telemetry, zero cloud-pings.

## Acceptance Criteria
- Compilable Swift source for `ImageCore` models and processing coordination.
- Successful verification of adjustment application logic against inferred behavioral patterns.
- Documentation of local vs. cloud features found during analysis.

## Out of Scope
- Re-implementation of the actual UI (handled in separate tracks).
- Cloud-dependent features (dropped if found).
