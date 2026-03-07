# Implementation Plan: Metadata Sync Restoration

## Phase 1: Metadata DB & Models (DataCore)
- [x] Task: Update `DatabaseSchema` with `ZMETADATA` and `ZSIDECAR` tables.
- [x] Task: Add basic `MetadataSynchronizer.syncToSidecar` logic.
- [x] Task: Commit Phase 1: Metadata DB & Models.

## Phase 2: XMP I/O Logic (DataCore/AppCoreShared)
- [x] Task: Implement `XMPGenerator` for writing metadata to XML (Rating, Tag, Creator).
- [x] Task: Implement `XMPParser` for reading metadata from XML.
- [x] Task: Commit Phase 2: XMP I/O Logic.

## Phase 3: EXIF Extraction (ImageCore)
- [x] Task: Add basic EXIF extraction (ISO, Aperture, Shutter) to `RawImageRep`.
- [x] Task: Map extracted EXIF to `ImageBase` properties.
- [x] Task: Commit Phase 3: EXIF Extraction.

## Phase 4: Metadata Inspector UI (CaptureOneUI)
- [x] Task: Reconstruct the `MetadataInspectorView`.
- [x] Task: Bind metadata fields to current selection.
- [x] Task: Commit Phase 4: Metadata UI.

## Phase 5: Validation
- [ ] Task: Verify end-to-end sync between UI and XMP sidecars.
- [ ] Task: Commit Phase 5: Finalization.
