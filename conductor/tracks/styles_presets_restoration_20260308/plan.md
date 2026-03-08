# Implementation Plan: Keyboard Shortcuts System Restoration

## Phase 1: Data Models & Default Mappings (AppCoreShared)
- [x] Task: Reconstruct `KeyboardShortcut` and `ShortcutSet` data models. 1143a74
- [x] Task: Define the `Default` and `LightroomLegacy` shortcut mappings. 1143a74
- [x] Task: Implement the `ShortcutManager` singleton for registry and lookup. 1143a74
- [x] Task: Commit Phase 1. 1143a74

## Phase 2: Input Handling & Execution (CaptureOneUI / AppCoreShared)
- [x] Task: Implement the global key event monitor (NSEvent monitor). 970b58f
- [x] Task: Implement the action resolution logic (mapping shortcut to action closure). 970b58f
- [x] Task: Implement conflict detection for custom shortcut assignments. 970b58f
- [x] Task: Commit Phase 2. 970b58f

## Phase 3: Tooltip & UI Integration (CaptureOneUI)
- [x] Task: Reconstruct the tooltip shortcut display logic (discoverd in `EnhancedTooltipScene`). 9f74746
- [x] Task: Implement the `ShortcutEditorView` for creating custom mappings. 9f74746
- [x] Task: Bind the `POSlider` and other components to their respective shortcuts. 9f74746
- [x] Task: Commit Phase 3. 9f74746

## Phase 4: Persistence & Cloud Sync (AppCoreShared)
- [x] Task: Implement local JSON serialization for custom shortcut sets. a5707cb
- [x] Task: Reconstruct `CloudSettingsKeyboardShortcutsHandler` for sync support. a5707cb
- [x] Task: Create a test case: map `⌘R` to `Reset` -> trigger key -> verify adjustment reset. a5707cb
- [x] Task: Commit Phase 4. a5707cb
