# Specification: Architecture Alignment with Capture One 2 (v16.5+)

## Objective
Update the reconstructed codebase to align with the symbols and structure discovered in the latest version ("Capture One 2.app"). This includes expanding core models, refining the workspace management architecture, and adopting established UI patterns (ViewModels, `COUIView`).

## Key Findings (Gap Analysis)
### 1. Core Models (`AppCoreShared`)
- **`VariantBase`**: Missing `adjustmentLayerRowID`, `combinedSettingsRowID`, `canvasSize`, `collectionLinks`, and methods for style/layer management (`variantByAddingStyle:sidecarsTracker:`).
- **`ImageBase`**: Missing `isTrashed`, `isInsideCatalog`, `gpsLatitude`, `gpsAltitude`, and `rawFileQuickHash`.
- **`MCVariant`**: Missing many non-destructive adjustment methods and interaction with `sidecarsTracker`.

### 2. Workspace Management (`Main Executable`)
- `WorkspaceManager` and `Workspace` reside in the main executable, suggesting they are top-level application state rather than low-level library models.
- `Workspace` conforms to `NSCoding` and has ~41 methods including `bundleWorkspace` and `windowWorkspaceDomain`.
- `WorkspaceLayout` is a missing class coordinating the visual arrangement.

### 3. UI Patterns (`CaptureOneUI`)
- Adoption of `COUIView` and `COUIContentView` as base classes.
- Heavy use of `ViewModel` suffixes for stateful views (e.g., `MatchLookViewModel`).
- Core views like `COImageBrowserView` use an `Interactor` pattern (`ImageBrowserInteractor`).

## Success Criteria
1. `VariantBase` and `ImageBase` implement all discovered ObjC members.
2. `Workspace` models are expanded to support persistence and domain-specific state.
3. Base UI classes (`COUIView`) are introduced.
4. Core tools use the `ViewModel` / `Interactor` pattern where observed in symbols.
