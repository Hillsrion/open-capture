# Implementation Plan: Restoration of Lens Correction (Distortion, LCC, CA)

## Phase 1: Data Models (AppCoreShared / ModelCore) [checkpoint: d06a106]
- [x] Task: Reconstruct `MCLensCorrectionSettings` (distortion, light falloff, sharpness falloff). f2a610d
- [x] Task: Reconstruct `MCLCCSettings` and `MCLCCProfile` data models. f2a610d
- [x] Task: Implement `LensCorrectionManager` to handle profile lookups and active settings. f2a610d
- [x] Task: Commit Phase 1. f2a610d

## Phase 2: Mathematical Kernels (ImageCore)
- [x] Task: Implement `ICL_DistortionCorrection` kernel for geometric correction. c21efc1
- [x] Task: Implement `ICL_ChromaticAberration` analysis and correction logic. c21efc1
- [x] Task: Implement `ICL_LightFalloff` compensation kernel. c21efc1
- [x] Task: Commit Phase 2. c21efc1

## Phase 3: LCC Logic & Integration (ImageCore)
- [x] Task: Implement `IC_CreateLCCProfile` logic based on Analyze and Create LCC. d06a106
- [x] Task: Implement LCC application in `ImageCorePipeline`. d06a106
- [x] Task: Commit Phase 3. d06a106

## Phase 4: UI & Validation (CaptureOneUI)
- [ ] Task: Reconstruct `LensCorrectionView` tool inspector (Distortion, Sharpness Falloff, Light Falloff sliders).
- [ ] Task: Reconstruct `LCCView` tool inspector and "Create LCC" workflow.
- [ ] Task: Create a test case to apply lens correction to a variant and verify histogram changes.
- [ ] Task: Commit Phase 4.
