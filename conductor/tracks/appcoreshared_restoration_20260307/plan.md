# Implementation Plan: Full Restoration of AppCoreShared Business Logic

## Phase 1: Structural Mapping & Skeleton Reconstruction
- [ ] Task: Map the complete class hierarchy of `AppCoreShared` from `ObjC_Structure.txt` and `Swift_Symbols.txt`.
- [ ] Task: Generate Swift skeleton files for all identified core entities (`Variant`, `Image`, `Collection`, `Session`).
- [ ] Task: Define property and method stubs with original API signatures.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Structural Mapping & Skeleton Reconstruction' (Protocol in workflow.md)

## Phase 2: Logic Recovery & Method Implementation
- [ ] Task: Analyze disassembly for core data accessors and simple state management logic.
- [ ] Task: Implement the internal logic for `Variant` and `Image` management methods based on assembly flow.
- [ ] Task: Reconstruct the notification and change tracking system.
- [ ] Task: Implement complex business logic for `Collection` and `Session` handling.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Logic Recovery & Method Implementation' (Protocol in workflow.md)

## Phase 3: Integration & Fidelity Verification
- [ ] Task: Implement unit tests for all reconstructed methods based on inferred functional requirements.
- [ ] Task: Perform "Dry Run" verification of data flow between reconstructed models.
- [ ] Task: Refine Swift implementations for idiomatic correctness while maintaining behavioral fidelity.
- [ ] Task: Finalize documentation mapping source code to assembly offsets.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Integration & Fidelity Verification' (Protocol in workflow.md)
