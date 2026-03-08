# Specification: Document Lifecycle & Preferences

## Context
Per `backlog.md` (UI-212, UI-213, WF-506, WF-507, UI-211), the app is missing significant document lifecycle management. There is no real recent-documents/start window flow, no accurate preference pane for `Catalogs and Sessions`, no robust window-per-document behavior with session switching, and no ahead-of-scroll image preloading.

## Objectives
- **UI-213 & WF-506**: Implement full Document actions: `New Catalog...`, `New Session...`, `Open...`, and `Open Recent`. Establish window-per-document infrastructure.
- **UI-212**: Implement `Catalog and Session` preferences pane in `AppPreferencesView`.
- **UI-211**: Implement a minimal startup window instead of mocking a single unpopulated session.
- **WF-507**: Add an explicit guard and prefetch logic inside thumbnail pipeline that is document-aware.

## Scope
- Modify `AppCommandCenter` and `SessionManager` (or equivalent) to support a robust open/close flow.
- Add macOS menus for New and Open.
- Create Start Window / recent documents state.
- Update `AppPreferencesView` to include the `Catalog and Session` tab.
