# Implementation Plan: Import Engine Restoration

## Phase 1: Data Models (AppCoreShared)
- [x] Task: Reconstruct `ImportMetadata` data model (Job Name, Description, Copyright). f2a610d
- [x] Task: Reconstruct `ImportSettings` (Destination, Naming format, Style UUIDs). f2a610d
- [x] Task: Implement `ImporterPickedState` to track which items are selected for import. f2a610d
- [x] Task: Commit Phase 1. a5d7208

## Phase 2: Core Ingestion Logic (AppCoreShared / DataCore)
- [x] Task: Implement `ImportSourceScanner` to crawl directories for supportable files. f2a610d
- [x] Task: Reconstruct `POImporter` class - the central coordinator. f2a610d
- [x] Task: Implement file copying logic with token-based renaming. f2a610d
- [x] Task: Integrate `DataCore` registration during the import process. f2a610d
- [x] Task: Commit Phase 2. 74c6aee

## Phase 3: Token Naming System (AppCoreShared)
- [x] Task: Reconstruct `NamingToken` and `TokenEvaluator` for dynamic filename generation. f2a610d
- [x] Task: Implement common tokens (Image Name, Date, Sequence, Job Name). f2a610d
- [x] Task: Commit Phase 3. 5b37528

## Phase 4: UI & Validation (CaptureOneUI)
- [x] Task: Reconstruct `ImportDialog` main layout (Sidebar + Grid). f2a610d
- [x] Task: Implement `ImportSettingsView` (inspector for destination, naming, etc.). f2a610d
- [x] Task: Create end-to-end test case: scan folder -> configure renaming -> import to catalog. f2a610d
- [x] Task: Commit Phase 4. a5707cb
