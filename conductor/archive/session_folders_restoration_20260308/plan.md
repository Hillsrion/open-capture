# Implementation Plan: Session Folders Logic

## Phase 1: Constants & Base Models (AppCoreShared)
- [x] Task: Define `SessionFolderType` enum and constants (`kDefaultCaptureFolderName`, etc.). 9e99cc2
- [x] Task: Reconstruct `SessionFolderManager` to handle path resolution. 9e99cc2
- [x] Task: Implement `SessionBase` updates to store active system folder paths. 9e99cc2
- [x] Task: Commit Phase 1. 9e99cc2

## Phase 2: Folder Routing Logic (AppCoreShared)
- [x] Task: Implement `moveToSelects(variant:)` logic (physical move + DB update). 223ccaf
- [x] Task: Implement `moveToTrash(variant:)` logic. 223ccaf
- [x] Task: Reconstruct "Set as Capture Folder" logic. 223ccaf
- [x] Task: Commit Phase 2. 223ccaf

## Phase 3: Persistence Integration (DataCore)
- [x] Task: Add session folder path columns to `ZSESSION` in `DatabaseSchema`. 844f30a
- [x] Task: Update `SessionBase` hydration to load/save system folder paths. 844f30a
- [x] Task: Commit Phase 3. 844f30a

## Phase 4: UI & Validation (CaptureOneUI)
- [x] Task: Add "Set as Capture Folder" to the folder context menu. 3456647
- [x] Task: Create a test case: create session -> move image to selects -> verify disk & DB. 3456647
- [x] Task: Commit Phase 4. 3456647
