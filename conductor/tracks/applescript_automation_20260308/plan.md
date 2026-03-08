# Implementation Plan: AppleScript Automation Restoration

## Objective
Reconstruct the AppleScript Automation bridge (INT-004), enabling external scripts to control the application, query documents (Sessions/Catalogs), and interact with variants.

## Key Files & Context
- `CaptureOneApp/CaptureOne.sdef`: The Scripting Definition File mapping AppleEvents to classes.
- `CaptureOneApp/Info.plist`: Needs to register the `NSAppleScriptEnabled` flag and point to the `.sdef`.
- `AppCoreShared/ApplicationScripting.swift`: Extensions on `NSApplication` for the root scripting object.
- `AppCoreShared/SessionScripting.swift`: Making `SessionBase` scriptable (Document).
- `AppCoreShared/VariantScripting.swift`: Making `VariantBase` scriptable.

## Implementation Steps

### Phase 1: Scripting Definition & App Setup
- [x] Task: Create `CaptureOne.sdef` with basic classes (`application`, `document`, `variant`). fc89694
- [x] Task: Update `CaptureOneApp/Info.plist` to enable scripting and reference the `.sdef`. fc89694
- [x] Task: Create `ApplicationScripting.swift` to expose the currently open document(s). fc89694
- [x] Task: Commit Phase 1 & Build Check. fc89694

### Phase 2: Document (Session) Scriptability (AppCoreShared)
- [ ] Task: Implement scripting extensions for `SessionBase` (exposing `name`, `path`).
- [ ] Task: Allow scripts to query `variants` within the active session.
- [ ] Task: Commit Phase 2 & Build Check.

### Phase 3: Variant Scriptability (AppCoreShared)
- [ ] Task: Implement scripting extensions for `VariantBase`.
- [ ] Task: Expose properties like `name`, `rating`, and `color tag` as read/write scriptable properties.
- [ ] Task: Commit Phase 3 & Build Check.

### Phase 4: AppleScript Commands (AppCoreShared)
- [ ] Task: Implement a custom script command (e.g., `process` or `export`) taking a variant as an argument.
- [ ] Task: Create a test case: write a sample AppleScript string -> execute via `NSAppleScript` -> verify variant state changes.
- [ ] Task: Commit Phase 4 & Build Check.

## Verification & Testing
- Test Case: Run `tell application "CaptureOneReconstructed" to get name of document 1` -> Verify it returns the session name.
- Test Case: Run `tell application "CaptureOneReconstructed" to set rating of variant 1 of document 1 to 5` -> Verify the variant rating updates in the UI.
