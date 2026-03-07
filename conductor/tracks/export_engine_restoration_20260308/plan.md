# Implementation Plan: Export Engine Restoration

## Phase 1: Data Models (AppCoreShared / ModelCore)
- [x] Task: Reconstruct `ProcessRecipe` (wrapper around `MCRecipe`).
- [x] Task: Implement `RecipeManager` to handle the list of active/inactive recipes.
- [x] Task: Reconstruct `ExportSettings` (resizing logic, naming tokens).
- [x] Task: Commit Phase 1.

## Phase 2: Translation Logic (AppCoreShared)
- [x] Task: Implement translation from `MCRecipe` to `IC_ProcessSettings` (format, quality, color space).
- [x] Task: Implement `ExportEngine` coordinator that queues jobs.
- [x] Task: Commit Phase 2.

## Phase 3: Low-Level Integration (ImageCore)
- [x] Task: Implement `ICP_ProcessToFile` wrapper in `ImageCorePipeline`.
- [x] Task: Support for different output formats (JPEG, TIFF, PNG) via ImageCore.
- [x] Task: Commit Phase 3.

## Phase 4: UI & Validation (CaptureOneUI)
- [x] Task: Reconstruct `ExportView` (summary of selected recipes and "Export" button).
- [x] Task: Create a test case to "export" a variant to a temporary file.
- [x] Task: Commit Phase 4.
