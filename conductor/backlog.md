# Capture One Reconstruction Backlog

This backlog replaces the earlier optimistic summary. It tracks what is still missing in the product surface after the recent workspace/palette reconstruction, with the decompiled `Default.plist` and reachable UI behavior as the source of truth.

Status vocabulary used below:
- `TODO`: not implemented
- `PARTIAL`: present in code but incomplete, weakly wired, or visibly different from Capture One
- `PLACEHOLDER`: reachable in the UI only through `UnavailableToolView`
- `DONE-RECENT`: recently closed and kept here only for context when it unblocks adjacent work

---

## Recently Closed

| Task ID | Feature | Priority | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| WS-001 | Load workspace presets from decompiled `Default.plist` | High | `DONE-RECENT` | Session/viewer/live preview/culling palette taxonomy now comes from the plist, not from synthetic tabs. |
| WS-002 | Restore session palette shell (`Organize`, `Capture`, `Lens`, `Settings`, `Exposure`, `Details`) | High | `DONE-RECENT` | Session opens on `OrganizeToolTab`; fixed vs scrollable tool areas are restored. |
| WS-003 | Central tool registry for decompiled tool IDs | High | `DONE-RECENT` | Existing tools are routed centrally; missing ones now surface as explicit placeholders. |
| SHELL-001 | Global command center for shell actions and modal sheets | High | `DONE-RECENT` | `Import`, `Export`, `Preferences`, `Keyboard Shortcuts`, and `Print` now route through a shared command center instead of inert toolbar clicks. |
| SHELL-002 | Basic macOS main menu and top-toolbar action wiring | High | `DONE-RECENT` | The app now installs a real `NSMenu`, routes top-bar actions, and exposes basic `Before/After`, grid, focus mask, proofing, and warning toggles. |
| SHELL-003 | Startup empty-state and functional tool headers | High | `DONE-RECENT` | The viewer no longer spins forever with no image, import can pick a source folder, and tool headers now have separated help/reset/menu actions. |
| UI-201 | Organize palette parity | High | `DONE-RECENT` | `Library` implements albums, smart albums, folders, and favorites management. |
| UI-202 | Exposure palette parity | High | `DONE-RECENT` | All Exposure tools including placeholders are replaced with stub tool views. |
| UI-203 | Details palette parity | High | `DONE-RECENT` | All Details tools including placeholders are replaced. |
| UI-204 | Lens palette parity | High | `DONE-RECENT` | All Lens tools including placeholders are replaced. |
| UI-211 | Startup/no-document realism | High | `DONE-RECENT` | Start window flow and empty state is present. |
| UI-212 | `Catalog and Session` preferences parity | High | `DONE-RECENT` | Added preference pane and persistence variables via AppStorage. |
| UI-213 | File-menu and toolbar document actions parity | High | `DONE-RECENT` | File menu actions for document lifecycle are present. |
| UI-214 | Library session structure parity | High | `DONE-RECENT` | `LibraryToolView` includes Session Albums, System Folders, actions, and structure. |
| UI-215 | Library folder context menu parity | High | `DONE-RECENT` | All Library context menu variants match decomps. |
| WF-506 | Session and catalog lifecycle workflows | High | `DONE-RECENT` | Document creation, opening, and multi-window behavior are supported by COWindowManager. |
| WF-507 | Image preloading and preview queue behavior | High | `DONE-RECENT` | Thumbnail prefetch logic avoids idle rendering. |
| GAP-401 | Actual live view engine | High | `DONE-RECENT` | Restored standalone live preview window, custom Workspace loading, tool views, and menu hooks. |
| WS-101 | Viewer window shell restoration | High | `DONE-RECENT` | Dedicated ViewerWindowController loads viewerwindow.tools presets. |
| WS-102 | Live preview window shell restoration | High | `DONE-RECENT` | Validated LivePreviewWindowController correctly loads .livePreview preset. |
| WS-103 | Culling window shell restoration | High | `DONE-RECENT` | Dedicated CullingShellController loads cullingwindow.tools presets. |
| UI-205 | Capture palette parity | High | `DONE-RECENT` | All Capture palette tools now have stub views. |
| UI-206 | Settings palette parity | High | `DONE-RECENT` | BaseCharacteristics and Settings tools restored. |
| UI-207 | Top chrome parity | High | `DONE-RECENT` | Native NSToolbar replaces SwiftUI fake toolbar strip on document window. |
| UI-210 | Tool header and context-menu parity | High | `DONE-RECENT` | Per-tool Copy/Apply/Reset in ellipsis menu; help/reset/style actions functional. |
| UI-208 | Import / export window fidelity | High | `DONE-RECENT` | Three-panel layout with source browser tree, grid, and file info strip. |
| UI-209 | Viewer chrome parity | High | `DONE-RECENT` | COViewerBarView now shows filename, dimensions, color space, color tags, rating stars. |
| UI-216 | Session upgrade dialog parity | Med | `DONE-RECENT` | Added high-fidelity upgrade dialog with strings from disassembly, warning icons, and mock upgrade workflow. |
| WS-104 | Exporter / importer / print workspace chrome fidelity | Med | `DONE-RECENT` | Replaced SwiftUI sheets with dedicated NSWindowControllers loading .importerwindow, .exporterwindow, and .printwindow presets. |
| WS-105 | Palette undocking / redocking / floating panels | High | `DONE-RECENT` | Implemented FloatingToolWindowController and FloatingPaletteWindowController; undocking triggered via pip icon or drag. |
| WS-106 | Multi-monitor workspace behavior | High | `DONE-RECENT` | Added window frame persistence to WorkspaceChromeState, allowing windows to reopen where they were last placed. |

---

## P1. Placeholder Tool Inventory Exposed By The New Registry

These tools are now honestly exposed as missing. They should be treated as concrete backlog, not hidden behind old “done” track labels.

| Task ID | Tool IDs | Priority | Complexity | Status |
| :--- | :--- | :--- | :--- | :--- |
| TOOL-301 | `MatchLook`, `BlackAndWhite`, `Dehaze`, `Vignetting` | High | Med | `PLACEHOLDER` |
| TOOL-302 | `Crop`, `AICrop`, `Rotation`, `Grid`, `Guides` | High | Med | `PLACEHOLDER` |
| TOOL-303 | `Navigator`, `Focus`, `SpotRemoval`, `LensColorCorrections`, `Moire` | High | High | `PLACEHOLDER` |
| TOOL-304 | `ExposureEvaluation`, `CameraFocus`, `NextCaptureLocation`, `Overlay`, `LiveForStudio`, `NextCaptureMetadata`, `NextCaptureKeywords`, `NextCaptureBackup` | High | High | `DONE-RECENT` |
| TOOL-305 | `BaseCharacteristics`, `Settings` | Med | Med | `DONE-RECENT` |
| TOOL-306 | `ImporterFilters`, `ImportFileInfo`, `FaceFocus`, `TimeBasedGrouping` | Med | High | `DONE-RECENT` |
| TOOL-307 | `LivePreviewComposition`, `LivePreviewAdjustments`, `LivePreviewInfoTool`, `Normalize` | Med | Med | `PLACEHOLDER` |

The registry source of truth for these placeholders is [ToolRegistry.swift](/Users/ismaelsebbane/dev/lab/capture-uncompile/reconstructed_codebase/Sources/CaptureOneUI/ToolRegistry.swift).

---

## P1. Features Marked “Done” But Still Only Partial In Product Terms

These are the misleading areas where backend or isolated UI work exists, but the integrated app still falls short.

| Task ID | Track Area | Priority | Complexity | Status | Gap |
| :--- | :--- | :--- | :--- | :--- | :--- |
| GAP-402 | Smart albums and organize workflows | High | High | `PARTIAL` | Data and predicates exist, but album/smart album management is not restored in the main `Library` UX. |
| GAP-403 | Metadata sync UX | Med | Med | `PARTIAL` | Basic metadata views are reachable, but editable metadata grouping, richer IPTC workflows, and XMP-facing UI parity are still shallow. |
| GAP-404 | Layers and local adjustments UX | High | High | `PARTIAL` | Layers exist, but the full `LocalAdjustmentsToolTab`/brush-tool inspector flow from the plist is not rebuilt. |
| GAP-405 | Export engine vs exporter UX | Med | Med | `PARTIAL` | Export recipes and batch queue exist, but exporter-specific shells and per-tool recipe editors are still adapters over a generic export view. |
| GAP-406 | Tethering workflows | High | High | `PARTIAL` | PTP models and some capture tools exist, but the complete capture/live/studio workflow in the decompiled workspaces is not restored. |

---

## P1. Workflow-Level Gaps Still Visible In Testing

These are not single widgets; they affect user acceptance because the reconstructed app still feels unlike Capture One in daily use.

| Task ID | Feature | Priority | Complexity | Status | Gap |
| :--- | :--- | :--- | :--- | :--- | :--- |
| WF-501 | Browser mode parity | High | Med | `PARTIAL` | Grid browsing works, but full parity for list/filmstrip modes, sorting variants, and browser toolbar behavior still needs validation and likely completion. |
| WF-502 | Palette persistence fidelity | High | Med | `PARTIAL` | Palette selection and some tool state persist, but broader collapsed groups, size options, and workspace editing fidelity remain incomplete. |
| WF-503 | Tool placement fidelity | High | High | `PARTIAL` | The top-level palette order now matches the plist, but many underlying tools still use adapters or simplified UI instead of true Capture One control contracts. |
| WF-504 | Session startup realism | Med | Med | `PARTIAL` | The app opens on `Organize`, but the mocked session/bootstrap flow still does not reflect actual recent sessions/catalog selection behavior. |
| WF-505 | Keyboard / command routing across restored palettes | Med | Med | `PARTIAL` | Shortcut infrastructure exists, but per-tool and per-window command routing is not yet validated against the restored workspace structure. |

---

## P2. Technical Debt Created By Earlier Reconstruction Phases

These items are lower priority than visible workflow gaps, but they are now blocking accuracy and maintainability.

| Task ID | Feature | Priority | Complexity | Status | Gap |
| :--- | :--- | :--- | :--- | :--- | :--- |
| TD-601 | Split adapter views into true plist tool boundaries | Med | High | `TODO` | Several routed tools are still wrappers over larger composite views instead of one ID = one real tool contract. |
| TD-602 | Remove legacy workspace compatibility path once unused | Low | Med | `TODO` | `WorkspaceTab` and legacy decoding still exist for compatibility; they should be retired after migration is stable. |
| TD-603 | Resource packaging for workspace presets | Low | Low | `TODO` | `Default.plist` is loaded from source-path fallback logic; it should become an explicit package/bundle resource. |
| TD-604 | Add UI snapshot / structural coverage for restored palettes | Med | Med | `TODO` | Current tests validate decoding and registry coverage, but not visual composition or palette ordering in rendered views. |

---

## P2. Conductor / Tracking Hygiene

The project tracking itself now needs correction so the repository stops overstating completion.

| Task ID | Feature | Priority | Complexity | Status | Gap |
| :--- | :--- | :--- | :--- | :--- | :--- |
| DOC-701 | Reconcile `tracks.md` with actual UI reachability | High | Low | `TODO` | Several tracks remain checked as done even though their product surface is still partial or placeholder-based. |
| DOC-702 | Fix incorrect Live View track link | High | Low | `TODO` | `Track: Live View Engine Restoration` points to `styles_presets_restoration_20260308` instead of a live-view track. |
| DOC-703 | Add backlog-to-track linkage for the new workspace debt | Med | Low | `TODO` | The backlog now reflects missing work, but the track registry still lacks explicit follow-up tracks for palette/window completion. |

---

## Recommended Next Focus

If work resumes immediately, the highest-value sequence is:

1. `TOOL-301` to `TOOL-303`: Remove remaining placeholder tools (`MatchLook`, `Crop`, `Navigator`, etc.).
2. `GAP-402` to `GAP-406`: Deepen functional integration for smart albums, metadata, and layers.
3. `WF-501` to `WF-505`: Validate and fix workflow-level gaps like browser modes and shortcut routing.
