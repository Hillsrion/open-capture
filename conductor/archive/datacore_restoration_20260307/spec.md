# Specification: Full Restoration of DataCore Persistence Logic

## Overview
`DataCore` is the persistence layer of Capture One, responsible for managing SQLite databases for Catalogs and Sessions, metadata storage (IPTC/XMP), and project-level synchronization. This track aims for a full Swift restoration of its logic, ensuring seamless data flow between memory and disk while maintaining a strictly offline execution model.

## Functional Requirements
- **Database Architecture:** Reconstruct the logic for managing SQLite schemas, including table definitions for variants, images, collections, and keywords.
- **Catalog & Session Management:** Restore the logic for creating, opening, and verifying Capture One documents (Catalogs and Sessions).
- **SQL Query Engine:** Reconstruct the internal SQL query generation and execution wrappers used for high-performance data retrieval.
- **Metadata Persistence:** Restore the logic for synchronizing image metadata between the database and sidecar files (XMP).
- **Offline Integrity:** Systematically remove any logic related to cloud database synchronization or server-side metadata validation.

## Non-Functional Requirements
- **Modern Swift Restoration:** Full port from assembly/ObjC to idiomatic Swift.
- **Thread Safety:** Maintain the original multi-threaded database access patterns (queues/locks).
- **Standalone Compilability:** The reconstructed module must compile as a modular Swift framework.

## Acceptance Criteria
- Compilable Swift source for `DataCore` manager and database wrappers.
- Verified logic for basic CRUD operations on reconstructed schemas.
- Documentation of the database schema structure.

## Out of Scope
- Cloud-based synchronization features (dropped).
- Remote telemetry/analytics within the persistence layer.
