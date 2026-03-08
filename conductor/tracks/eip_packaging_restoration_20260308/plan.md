# Implementation Plan: EIP Packaging Restoration

## Objective
Reconstruct the EIP (Enhanced Image Package) system (CORE-006), enabling the consolidation of RAW files and their associated adjustments (COsettings, Masks, LCC) into a single `.eip` archive for easy transport and archiving.

## Key Files & Context
- `AppCoreShared/EIPManager.swift`: New manager for packing and unpacking EIP files.
- `AppCoreShared/POImporter.swift`: Update to handle EIP files during ingest.
- `AppCoreShared/ExportTranslator.swift`: Integrate EIP packing during "Export Original" activities.
- `ImageCore/ImageCoreBase.swift`: `RawImageRep` needs to detect if it's inside an EIP.

## Implementation Steps

### Phase 1: Archive Format & Low-Level API (AppCoreShared)
- [x] Task: Reconstruct `EIPArchive` wrapper using `Zip` or a similar archive format (mimicking the `.eip` structure). fc89683
- [x] Task: Implement `EIP_Create`, `EIP_Extract`, and `EIP_Update` logic. fc89683
- [x] Task: Reconstruct `EIPPackageInfo` model (version, contents, original RAW extension). fc89683
- [x] Task: Commit Phase 1 & Build Check. fc89683

### Phase 2: Packing Logic (AppCoreShared)
- [ ] Task: Implement `packAsEIP` logic (gathering RAW, .cos, and subfolders like LCC/Masks).
- [ ] Task: Integrate EIP packing into `OriginalFilesExportActivity`.
- [ ] Task: Implement validation: `ICIF_CanEIP` (Checking if RAW format supports EIP).
- [ ] Task: Commit Phase 2 & Build Check.

### Phase 3: Unpacking & Ingest (AppCoreShared)
- [ ] Task: Update `POImporter` to detect and transparently handle `.eip` files.
- [ ] Task: Implement "Unpack EIP" workflow (extracting contents back to standard sidecar structure).
- [ ] Task: Add "Always Pack as EIP" setting to `ImportSettings`.
- [ ] Task: Commit Phase 3 & Build Check.

### Phase 4: UI & Tool Integration (CaptureOneUI)
- [ ] Task: Add "Pack as EIP" checkbox to the Export and Import dialogs.
- [ ] Task: Implement visual indicator for EIP files in the `Grid View Browser`.
- [ ] Task: Create a test case: pack variant as EIP -> verify contents -> unpack -> verify adjustments are intact.
- [ ] Task: Commit Phase 4 & Build Check.

## Verification & Testing
- Test Case: Pack a Nikon .NEF with masks as EIP -> Verify resulting file structure.
- Test Case: Import an EIP -> Verify Capture One reads the adjustments from within the archive.
- Test Case: Attempt to pack a non-supported format (e.g., JPEG) -> Verify `CanEIP` check fails.
