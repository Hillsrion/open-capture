# Specification: Session Folders Logic (CORE-008)

## Overview
This track focuses on reconstructing the logic for Session System Folders in Capture One. A Session consists of four primary folders: Capture, Selects, Output, and Trash. We will implement the management logic for these folders, including path resolution, virtual collection mapping, and the ability to "Set as" a specific system folder.

## Functional Requirements
- **System Folder Constants:** Define external constants for default folder names (`Capture`, `Selects`, `Output`, `Trash`).
- **Path Management:** Reconstruct logic to resolve the physical paths for each system folder relative to the `.cosessiondb` location.
- **Set as System Folder:** Implement methods to change the current system folder (e.g., `setCaptureFolder:`, `setSelectsFolder:`).
- **Virtual Collections:** Ensure the library sidebar's virtual collections correctly point to the active physical system folders.
- **Routing Logic:** Implement the "Move to Selects" and "Move to Trash" logic, ensuring files are physically moved on disk and database entries updated.

## Non-Functional Requirements
- **Data Integrity:** Operations like "Move to Trash" must be atomic and reversible (moving to the Trash folder vs permanent deletion).
- **Disk Synchronization:** Ensure the UI stays in sync with physical folder changes.

## Acceptance Criteria
- Correct initialization of default session folders upon session creation.
- Successful routing of images when using "Move to Selects" or "Move to Trash".
- Ability to select any folder on disk and "Set as Capture Folder".
- Updated metadata reflects the correct system folder assignment.

## Out of Scope
- Catalog-specific folder logic (Catalogs handle folders differently).
- Networking/Cloud synchronization of session folders.
