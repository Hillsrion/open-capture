# Implementation Plan — Architecture Alignment (v2)

## Phase 1: Core Model Expansion (AppCoreShared)
- [x] Task: Update `VariantBase` with `adjustmentLayerRowID`, `combinedSettingsRowID`, `canvasSize`, and `collectionLinks`.
- [x] Task: Update `ImageBase` with `isTrashed`, `isInsideCatalog`, `gpsLatitude`, `gpsAltitude`, and `rawFileQuickHash`.
- [x] Task: Integrate `sidecarsTracker` (mock or stub) into `MCVariant` methods.
- [x] Task: Commit Phase 1.

## Phase 2: Workspace Evolution (CaptureOneApp / AppCoreShared)
- [x] Task: Expand `Workspace` to support `NSCoding` (or `Codable` equivalent for all discovered keys).
- [x] Task: Implement `WorkspaceLayout` to manage window/palette coordination.
- [x] Task: Add `allWorkspaces` and `systemWorkspacesAsMenu` logic to `WorkspaceManager`.
- [x] Task: Commit Phase 2.

## Phase 3: UI Architecture Refinement (CaptureOneUI)
- [x] Task: Create `COUIView` and `COUIContentView` as base SwiftUI/AppKit bridge classes.
- [x] Task: Refactor `MatchLookToolView` to use `MatchLookViewModel`.
- [x] Task: Refactor `COImageBrowserView` to utilize `ImageBrowserInteractor`.
- [x] Task: Commit Phase 3.

## Phase 4: Missing Managers & Logic
- [x] Task: Reconstruct `SearchManager` stub for filter tool logic.
- [x] Task: Reconstruct `BrushSettingsManager` stub for cursor tool coordination.
- [x] Task: Commit Phase 4.
