# Specification: High-Fidelity Workspace Chrome & Shell Restoration

## Objective
Restore dedicated macOS window shells for Importer, Exporter, and Print workflows, replacing the current simplified SwiftUI sheets. This fulfills `WS-104` and prepares the infrastructure for floating panels (`WS-105`) and multi-monitor support (`WS-106`), matching the architecture of the decompiled `ImporterWindowController`, `ExporterWindowController`, and `PrintWindowController`.

## Key Files & Context
- `src/Sources/CaptureOneUI/COWindowManager.swift`: Central registry for window controllers.
- `src/Sources/CaptureOneUI/AppCommandCenter.swift`: Routing for shell actions.
- `src/Sources/AppCoreShared/WorkspaceModels.swift`: `WorkspaceWindowKind` enum.
- `src/Sources/CaptureOneUI/ImportDialog.swift`: Existing importer UI to be hosted in the new shell.
- `src/Sources/CaptureOneUI/ExportView.swift`: Existing exporter UI.
- `src/Sources/CaptureOneUI/PrintWindowController.swift`: (Currently a view, to be converted to a real NSWindowController).

## Success Criteria
1. `Import Images...` opens a dedicated `NSWindow` instead of a sheet.
2. `Export Images...` opens a dedicated `NSWindow`.
3. `Print...` opens a dedicated `NSWindow`.
4. All windows correctly load their respective workspace presets (chrome, tools, palettes) from the `Default.plist` via `WorkspaceManager`.
5. Palette undocking/redocking is functional and persists between launches.
6. Multi-monitor placement is respected for restored shells.
