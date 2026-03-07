# Implementation Plan: Smart Albums & Filtering Restoration

## Phase 1: Filtering Engine & SQL Logic (DataCore)
- [x] Task: Reconstruct `FilterPredicate` model for building SQL WHERE clauses.
- [x] Task: Implement `DatabaseReader.fetchVariants(with: Predicate)` using SQLite.
- [x] Task: Update `ZCOLLECTION` schema to store predicate JSON/Data.
- [x] Task: Commit Phase 1: Filtering Logic.

## Phase 2: Sidebar Filter Tool (CaptureOneUI)
- [x] Task: Reconstruct the `FilterToolView` in the sidebar.
- [x] Task: Add a multi-select Rating filter and Color Tag filter to the tool.
- [x] Task: Implement a text-based search field.
- [x] Task: Commit Phase 2: Filter Tool.

## Phase 3: Smart Albums (AppCoreShared / DataCore)
- [ ] Task: Implement `SmartAlbum` subclass of `CollectionBase`.
- [ ] Task: Add "Create Smart Album" dialog and persistence logic.
- [ ] Task: Connect Smart Albums to the filtering engine.
- [ ] Task: Commit Phase 3: Smart Albums Integration.

## Phase 4: Validation & Optimization
- [ ] Task: Verify filtering with a simulated large catalog.
- [ ] Task: Optimize SQL indexes for common filter combinations (Rating + Color).
- [ ] Task: Commit Phase 4: Optimization.
