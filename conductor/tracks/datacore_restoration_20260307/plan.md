# Implementation Plan: Full Restoration of DataCore Persistence Logic

## Phase 1: Database Architecture & Mapping
- [x] Task: Map the SQLite table structures and relationships from `DataCore` metadata and SQL query strings.
- [x] Task: Reconstruct the `DataCoreManager` base class and initialization logic.
- [x] Task: Identify and define the data-to-database mapping models (Table/Column schemas).
- [x] Task: Conductor - User Manual Verification 'Phase 1: Database Architecture & Mapping' (Protocol in workflow.md)

## Phase 2: Query Engine & Project Management
- [ ] Task: Reconstruct the SQL query generation and execution logic.
- [ ] Task: Implement the Catalog and Session creation and opening logic.
- [ ] Task: Reconstruct the metadata synchronization system (database <-> sidecar files).
- [ ] Task: Neutralize any cloud-sync or remote validation logic within the persistence layer.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Query Engine & Project Management' (Protocol in workflow.md)

## Phase 3: Validation & Data Integrity
- [ ] Task: Implement unit tests for database CRUD operations on reconstructed schemas.
- [ ] Task: Verify the integrity of a simulated Catalog opening and data retrieval.
- [ ] Task: Refine Swift implementations for performance and thread safety.
- [ ] Task: Finalize documentation of the reconstructed database schema.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Validation & Data Integrity' (Protocol in workflow.md)
