# Implementation Plan: Magic Brush & Smart Masking Restoration

## Phase 1: Data Models & AI Infrastructure (AppCoreShared / ImageCore)
- [x] Task: Reconstruct `MagicBrushSettings` (Tolerance, Refine Edge, Sampled Color). f2a610d
- [x] Task: Reconstruct `VariantMagicBrushLayer` data model. f2a610d
- [x] Task: Implement `AIModelManager` for loading CoreML masking models. f2a610d
- [x] Task: Commit Phase 1. a495b07

## Phase 2: Magic Brush Engine (ImageCore)
- [x] Task: Implement the tolerance-based region growing algorithm. f2a610d
- [x] Task: Implement `IC_RefineMaskEdge` logic for smart boundaries. f2a610d
- [x] Task: Integrate Magic Brush into the `ImageCorePipeline` mask generation step. f2a610d
- [x] Task: Commit Phase 2. f2a610d

## Phase 3: AI Segmentation (ImageCore)
- [x] Task: Implement "Select Subject" logic using `subjectMaskingFP16`. 1e1aeab
- [x] Task: Implement "Select Background" logic (inverse subject). 1e1aeab
- [x] Task: Integrate AI masking into the `LayerInspector` workflow. 1e1aeab
- [x] Task: Commit Phase 3. 1e1aeab

## Phase 4: UI & Validation (CaptureOneUI)
- [x] Task: Reconstruct `MagicBrushSettingsTool` floating inspector. a5707cb
- [x] Task: Implement the interactive brushing gesture with live mask feedback. a5707cb
- [x] Task: Create a test case: sample color -> verify tolerance growth -> verify mask creation. a5707cb
- [x] Task: Commit Phase 4. a5707cb
