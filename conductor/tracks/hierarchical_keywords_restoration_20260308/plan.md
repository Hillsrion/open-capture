# Implementation Plan: Hierarchical Keywords Restoration

## Phase 1: Data Models & Hierarchy (AppCoreShared)
- [x] Task: Reconstruct `KeywordEntry` (based on `MCMetadataKeywordLibraryEntry`). 1f798f9
- [x] Task: Implement hierarchical tree logic (Parent/Child relationships). 1f798f9
- [x] Task: Implement `KeywordLibrary` to manage the collection of entries. 1f798f9
- [x] Task: Commit Phase 1. 1f798f9

## Phase 2: Persistence & Schema (DataCore)
- [x] Task: Create `ZKEYWORD` table in `DatabaseSchema`. d91259a
- [x] Task: Add `ZNAME`, `ZPARENT`, `ZUUID` columns to the schema. d91259a
- [x] Task: Update `DatabaseReader` and `DatabaseWriter` to support keyword CRUD operations. d91259a
- [x] Task: Commit Phase 2. d91259a

## Phase 3: Integration & Cache (AppCoreShared)
- [x] Task: Reconstruct `DocumentKeywordCache` for session-based management. 2cba7e2
- [x] Task: Integrate keyword management into `VariantBase`. 2cba7e2
- [x] Task: Implement keyword assignment and removal logic. 2cba7e2
- [x] Task: Commit Phase 3. 2cba7e2

## Phase 4: UI & Validation (CaptureOneUI)
- [x] Task: Reconstruct `KeywordInspectorTool` with a hierarchical list view. a5707cb
- [x] Task: Implement keyword search and filtering in the tool. a5707cb
- [x] Task: Create a test case: create keyword -> nest under parent -> assign to image -> verify persistence. a5707cb
- [x] Task: Commit Phase 4. a5707cb
