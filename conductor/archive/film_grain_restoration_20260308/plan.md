# Implementation Plan: Film Grain Restoration

## Phase 1: Data Models & ABI Refinement (AppCoreShared / ImageCore)
- [x] Task: Update `IC_ProcessSettings` to include `IC_FilmGrainSettings`. d02a456
- [x] Task: Define `FilmGrainType` enum (Fine, Silver Rich, Soft, Cubic). d02a456
- [x] Task: Update `AdjustmentToolController` with film grain properties. d02a456
- [x] Task: Commit Phase 1. d02a456

## Phase 2: Procedural Grain Engine (ImageCore)
- [x] Task: Implement the procedural noise generator (vDSP-based simulation). 9ba5a4d
- [x] Task: Implement the luminance-masking logic for grain application. 9ba5a4d
- [x] Task: Integrate `applyFilmGrain` into the `ImageCorePipeline`. 9ba5a4d
- [x] Task: Commit Phase 2. 9ba5a4d

## Phase 3: UI & Tool Inspector (CaptureOneUI)
- [x] Task: Reconstruct `FilmGrainToolView` with sliders and type picker. a5707cb
- [x] Task: Implement high-fidelity presets for different grain types. a5707cb
- [x] Task: Bind the UI to the `AdjustmentToolController` state. a5707cb
- [x] Task: Commit Phase 3. a5707cb

## Phase 4: Validation & Integration (Project-wide)
- [x] Task: Update `CullingWindowController` to include the Film Grain tool. a5707cb
- [x] Task: Create a test case: set grain amount -> verify pixel variance in rendered buffer. a5707cb
- [x] Task: Commit Phase 4. a5707cb
