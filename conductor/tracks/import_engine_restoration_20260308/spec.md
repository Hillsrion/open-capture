# Specification: Import Engine Restoration (CORE-007)

## Overview
This track focuses on reconstructing Capture One's ingestion engine. The import system is responsible for scanning source media (SD cards, folders), managing ingestion settings (destination, naming, backup), and applying initial metadata and styles during the copy process. We will reconstruct `POImporter` and its related data models and UI.

## Functional Requirements
- **Source Scanning:** Implement logic to scan folders and identify supportable image files (RAW, JPEG, TIFF).
- **Import Configuration:** Reconstruct `ImportMetadata` and `ImportSettings` to handle:
    - **Destination:** Folder routing (Current location, Inside Catalog, specific folder).
    - **Naming:** Token-based renaming logic (e.g., `[Image Name]_[Date]`).
    - **Backup:** Optional secondary copy to a backup location.
    - **Styles:** Applying a list of Style UUIDs during ingestion.
- **Ingestion Process:** Reconstruct `POImporter` to coordinate the file copying, metadata injection, and initial database registration (`DataCore`).
- **UI Interaction:** Reconstruct the `ImportDialog` (High-Fidelity) including:
    - Source selection popup.
    - Import settings inspector (Destination, Naming, Metadata, Styles).
    - Grid view for selecting specific images to import.
    - Progress reporting for the batch operation.

## Non-Functional Requirements
- **Concurrency:** File copying and database registration must be multi-threaded to ensure UI responsiveness.
- **Data Integrity:** Verification of successful file copies before finalizing database entries.
- **High Fidelity UI:** Match the original's layout, icons, and token interaction patterns.

## Acceptance Criteria
- Ability to select a source folder and see its contents in a grid.
- Configurable naming tokens that correctly rename files on disk.
- Successful copy of files to a selected destination with parallel metadata generation.
- Correct registration of imported images in the `DataCore` catalog database.

## Out of Scope
- Tethered capture (handled in TETH tracks).
- Catalog-to-Catalog importing (handled in future tracks).
