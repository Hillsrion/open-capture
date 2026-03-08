# Implementation Plan: HDR & Panorama Restoration

## Phase 1: Data Models & Settings (AppCoreShared / ImageCore)
- [x] Task: Reconstruct `IC_HDRMergeSettings` and `IC_PanoramaMergeSettings`. a5707cb
- [x] Task: Define `PanoramaWarpType` enum (Spherical, Cylindrical, Perspective, Panini). a5707cb
- [x] Task: Reconstruct the `MergeResult` model for background task tracking. a5707cb
- [x] Task: Commit Phase 1. 6378907

## Phase 2: HDR Merge Engine (ImageCore)
- [x] Task: Implement feature-based image alignment logic (vDSP/OpenCV simulation). df6a3b4
- [x] Task: Implement the 32-bit linear merge algorithm. df6a3b4
- [x] Task: Implement ghosting detection and removal logic. df6a3b4
- [x] Task: Commit Phase 2. df6a3b4

## Phase 3: Panorama Stitch Engine (ImageCore)
- [x] Task: Implement cylindrical and spherical warping math. bbc32d8
- [x] Task: Implement overlap feature matching and stitching. bbc32d8
- [x] Task: Implement exposure blending across stitched images. bbc32d8
- [x] Task: Commit Phase 3. bbc32d8

## Phase 4: DNG Generation & UI (CaptureOneUI / ImageCore)
- [x] Task: Reconstruct the 32-bit linear DNG writer. a5707cb
- [x] Task: Reconstruct the `HDRMergeDialog` and `PanoramaMergeDialog`. a5707cb
- [x] Task: Create a test case: merge 3 brackets -> verify 32-bit DNG output. a5707cb
- [x] Task: Commit Phase 4. a5707cb
