# Specification: Metadata Sync Restoration (XMP, EXIF/IPTC)

## Objective
Reconstruct the logic for synchronizing metadata between the Capture One database and external sidecar files (XMP). This includes reading/writing XMP files and extracting basic EXIF/IPTC metadata from RAW images.

## Scope
- **Data Models**: Add `ZMETADATA` and `ZSIDECAR` tables to `DatabaseSchema` (DataCore).
- **Metadata Logic**:
    - Implement `XMPParser` and `XMPGenerator` for standard sidecar synchronization.
    - Support core metadata: Rating, Color Tag, Creator, Copyright, Description, Keywords.
- **ImageCore Integration**:
    - Basic EXIF extraction (ISO, Aperture, Shutter, Focal Length) from `RawImageRep`.
- **UI Components**:
    - Reconstruct the `MetadataInspectorTool` showing EXIF and allowing edit of IPTC fields.

## Success Criteria
- [ ] Metadata changed in UI (Rating, Keywords) is correctly written to an `.xmp` sidecar.
- [ ] Changes in an external `.xmp` file are detected and updated in the DB.
- [ ] EXIF data (ISO, f/, etc.) is correctly displayed for RAW files.
- [ ] Metadata is correctly synchronized when an image is moved or renamed.
