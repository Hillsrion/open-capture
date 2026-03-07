# Implementation Plan: Full Restoration of ImageCore Processing Logic

## Phase 1: Engine Architecture & Mapping
- [ ] Task: Map the core processing engine hierarchy from `ImageCore` metadata.
- [ ] Task: Identify and reconstruct the `ICEngine` base classes and versioning logic.
- [ ] Task: Identify all adjustment operations (`ICAdjustmentOperation`) and their property mappings.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Engine Architecture & Mapping' (Protocol in workflow.md)

## Phase 2: Pipeline & Metal Logic Restoration
- [ ] Task: Reconstruct the image processing pipeline coordination logic.
- [ ] Task: Analyze and restore Metal-based GPU kernel dispatching and buffer management.
- [ ] Task: Reconstruct the masking engine, including `LumaRange` and parametric tools.
- [ ] Task: Implement "Always Local" AI segmentation logic if dependencies allow.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Pipeline & Metal Logic Restoration' (Protocol in workflow.md)

## Phase 3: Validation & Performance Fidelity
- [ ] Task: Implement unit tests verifying the mathematical correctness of adjustment operations.
- [ ] Task: Verify the end-to-end processing flow for a simulated RAW conversion.
- [ ] Task: Refine Swift implementations for idiomatic correctness and performance optimization.
- [ ] Task: Finalize documentation of the reconstructed engine architecture.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Validation & Performance Fidelity' (Protocol in workflow.md)
