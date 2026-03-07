# Implementation Plan: Full Restoration of AppCoreShared Business Logic

## Phase 1: Structural Mapping & Skeleton Reconstruction [checkpoint: a74a909]
- [x] Task: Map the complete class hierarchy of `AppCoreShared` from `ObjC_Structure.txt` and `Swift_Symbols.txt`.
- [x] Task: Generate Swift skeleton files for all identified core entities (`Variant`, `Image`, `Collection`, `Session`).
- [x] Task: Define property and method stubs with original API signatures.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Structural Mapping & Skeleton Reconstruction' (Protocol in workflow.md)

## Phase 2: Logic Recovery & Method Implementation [checkpoint: 08e2f96]
- [x] Task: Analyze disassembly for core data accessors and simple state management logic. a74a909
- [x] Task: Implement the internal logic for `Variant` and `Image` management methods based on assembly flow. a74a909
- [x] Task: Reconstruct the notification and change tracking system. a74a909
- [x] Task: Implement complex business logic for `Collection` and `Session` handling. a74a909
- [x] Task: Identify and neutralize licensing, activation, and telemetry logic (e.g., `LicenseCodeChecker`, `CloudSessionLicenseInfo`). a74a909
- [x] Task: Conductor - User Manual Verification 'Phase 2: Logic Recovery & Method Implementation' (Protocol in workflow.md) a74a909

## Phase 3: Integration & Fidelity Verification [checkpoint: 3c5e602]
- [x] Task: Implement unit tests for all reconstructed methods based on inferred functional requirements. 08e2f96
- [x] Task: Perform "Dry Run" verification of data flow between reconstructed models. 08e2f96
- [x] Task: Refine Swift implementations for idiomatic correctness while maintaining behavioral fidelity. 08e2f96
- [x] Task: Finalize documentation mapping source code to assembly offsets. 08e2f96
- [x] Task: Conductor - User Manual Verification 'Phase 3: Integration & Fidelity Verification' (Protocol in workflow.md) 08e2f96

## Phase: Review Fixes
- [x] Task: Apply review suggestions ae2e23d
