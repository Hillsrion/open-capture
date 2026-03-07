# Implementation Plan: Full Restoration of ImageCore Processing Logic

## Phase 1: Engine Architecture & Mapping [checkpoint: 9dc0521]
- [x] Task: Map the core processing engine hierarchy from `ImageCore` metadata.
- [x] Task: Identify and reconstruct the `ICEngine` base classes and versioning logic.
- [x] Task: Identify all adjustment operations (`ICAdjustmentOperation`) and their property mappings.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Engine Architecture & Mapping' (Protocol in workflow.md)

## Phase 2: Pipeline & Metal Logic Restoration
- [x] Task: Reconstruct the image processing pipeline coordination logic. 9dc0521
- [x] Task: Analyze and restore Metal-based GPU kernel dispatching and buffer management. 9dc0521
- [x] Task: Reconstruct the masking engine, including `LumaRange` and parametric tools. 9dc0521
- [x] Task: Implement "Always Local" AI segmentation logic if dependencies allow. 9dc0521
- [x] Task: Conductor - User Manual Verification 'Phase 2: Pipeline & Metal Logic Restoration' (Protocol in workflow.md) 9dc0521

## Phase 3: Validation & Performance Fidelity
- [ ] Task: Implement unit tests verifying the mathematical correctness of adjustment operations.
- [ ] Task: Verify the end-to-end processing flow for a simulated RAW conversion.
- [ ] Task: Refine Swift implementations for idiomatic correctness and performance optimization.
- [ ] Task: Finalize documentation of the reconstructed engine architecture.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Validation & Performance Fidelity' (Protocol in workflow.md)
