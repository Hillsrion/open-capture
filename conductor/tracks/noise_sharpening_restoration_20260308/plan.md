# Implementation Plan: Noise Reduction & Sharpening Restoration

## Phase 1: Data Models & Persistence (AppCoreShared / DataCore)
- [x] Task: Reconstruct `IC_NoiseReductionSettings` and `IC_SharpeningSettings` data models. f2a610d
- [x] Task: Add NR and Sharpening columns to `ZVARIANT` and `ZVARIANTLAYER` in `DatabaseSchema`. f2a610d
- [x] Task: Update `AdjustmentToolController` to manage NR/Sharpening state. f2a610d
- [x] Task: Commit Phase 1. f2a610d

## Phase 2: Sharpening Kernels (ImageCore)
- [x] Task: Implement `ICS_ApplySharpening` kernel (Amount, Radius, Threshold). f2a610d
- [x] Task: Implement `ICS_ApplyHaloControl` logic. f2a610d
- [x] Task: Integrate sharpening into the `ImageCorePipeline` processing loop. f2a610d
- [x] Task: Commit Phase 2. f2a610d

## Phase 3: Noise Reduction Kernels (ImageCore)
- [x] Task: Implement `ICNR_ApplyLuminanceNR` kernel with detail preservation. f2a610d
- [x] Task: Implement `ICNR_ApplyColorNR` logic. f2a610d
- [x] Task: Implement `ICNR_ApplySinglePixelNR` kernel. f2a610d
- [x] Task: Integrate NR into the `ImageCorePipeline` processing loop. f2a610d
- [x] Task: Commit Phase 3. f2a610d

## Phase 4: UI & Validation (CaptureOneUI)
- [x] Task: Reconstruct `SharpeningToolView` inspector. 3456647
- [x] Task: Reconstruct `NoiseReductionToolView` inspector. 3456647
- [x] Task: Create a test case: apply high NR/Sharpening -> verify pixel changes in output buffer. 3456647
- [x] Task: Commit Phase 4. a5707cb
