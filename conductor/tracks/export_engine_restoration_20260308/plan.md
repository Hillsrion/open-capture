# Implementation Plan: Export Engine Restoration

## Phase 1: Data Models (AppCoreShared / ModelCore)
- [ ] Task: Reconstruct `ProcessRecipe` (wrapper around `MCRecipe`).
- [ ] Task: Implement `RecipeManager` to handle the list of active/inactive recipes.
- [ ] Task: Reconstruct `ExportSettings` (resizing logic, naming tokens).
- [ ] Task: Commit Phase 1.

## Phase 2: Translation Logic (AppCoreShared)
- [ ] Task: Implement translation from `MCRecipe` to `IC_ProcessSettings` (format, quality, color space).
- [ ] Task: Implement `ExportEngine` coordinator that queues jobs.
- [ ] Task: Commit Phase 2.

## Phase 3: Low-Level Integration (ImageCore)
- [ ] Task: Implement `ICP_ProcessToFile` wrapper in `ImageCorePipeline`.
- [ ] Task: Support for different output formats (JPEG, TIFF, PNG) via ImageCore.
- [ ] Task: Commit Phase 3.

## Phase 4: UI & Validation (CaptureOneUI)
- [ ] Task: Reconstruct `ExportView` (summary of selected recipes and "Export" button).
- [ ] Task: Create a test case to "export" a variant to a temporary file.
- [ ] Task: Commit Phase 4.
