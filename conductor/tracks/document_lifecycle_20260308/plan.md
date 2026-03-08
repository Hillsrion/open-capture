# Implementation Plan: Document Lifecycle & Preferences

## Phase 1: Main Menu Document Actions
- [x] Task: Update the `Commands` body inside `CaptureOneApp.swift` to include standard File menu commands (`New Catalog`, `New Session`, `Open...`, `Open Recent`). 05700d8
- [x] Task: Ensure `AppCommandCenter` routes these commands properly. 05700d8
- [x] Task: Commit Phase 1. 05700d8

## Phase 2: Catalog and Session Preferences
- [x] Task: Add a new `CatalogAndSessionPreferencesView` matching the UI-212 requirements. 7ee6f2e
- [x] Task: Integrate this tab into `AppPreferencesView`. 7ee6f2e
- [x] Task: Add necessary keys to UserDefaults for `Open in new window`, `Enable Session Folders`, `Include Output Folder`. 7ee6f2e
- [x] Task: Commit Phase 2. 7ee6f2e

## Phase 3: Window-per-Document and Startup Parity
- [x] Task: Refactor the main App WindowGroup to be `WindowGroup(for: SessionBase.ID.self)` or use `DocumentGroup` if natively applicable, allowing multiple windows. 343a4eb
- [x] Task: Implement a barebones "Start Window" state that appears when no document is open. 343a4eb
- [x] Task: Commit Phase 3. 343a4eb

## Phase 4: Image Preloading and Guards [checkpoint: 319abc5d]
- [x] Task: Add guard inside `ThumbnailManager` or similar to explicitly prevent preloading operations if a document is not actively set. 319abc5
- [x] Task: Add baseline logic for ahead-of-scroll prefetching hooks. 319abc5
- [x] Task: Commit Phase 4. 319abc5
