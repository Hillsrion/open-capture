# Implementation Plan: Heal & Clone Tools Restoration

## Phase 1: Data Models & Layers (AppCoreShared)
- [x] Task: Reconstruct `RepairArrow` model (Source, Destination, Type). be80fb7
- [x] Task: Update `LayerBase` to support specialized Heal and Clone types. be80fb7
- [x] Task: Implement `addRepairArrow` logic in `VariantBase`. be80fb7
- [x] Task: Commit Phase 1. be80fb7

## Phase 2: Interactive Repair Arrows (CaptureOneUI)
- [x] Task: Reconstruct the `RepairArrowView` visual overlay (Line + Points). a5707cb
- [x] Task: Implement drag interaction for moving source and destination points. a5707cb
- [x] Task: Implement "Auto-Source" point placement logic. a5707cb
- [x] Task: Commit Phase 2. 2286570

## Phase 3: Core Engine Integration (ImageCore)
- [x] Task: Reconstruct the `Heal` blending kernel (Color/Light matching). 5636b4e
- [x] Task: Reconstruct the `Clone` copy kernel. 5636b4e
- [x] Task: Integrate retouching kernels into the `ImageCorePipeline` rendering. 5636b4e
- [x] Task: Commit Phase 3. 5636b4e

## Phase 4: UI Refinement & Validation (CaptureOneUI)
- [x] Task: Reconstruct the cursor behavior for Heal/Clone tools. a5707cb
- [x] Task: Implement "Clear Manual Source Point" UI action. a5707cb
- [x] Task: Create a test case: place heal point -> move source -> verify viewer update. a5707cb
- [x] Task: Commit Phase 4. a5707cb
