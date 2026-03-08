# Implementation Plan: Styles & Presets Browser Restoration

## Phase 1: Data Models & Registry (AppCoreShared)
- [x] Task: Reconstruct `Style` and `StylePack` models. 2895357
- [x] Task: Implement `StyleManager` to discover and register built-in and user styles. 2895357
- [x] Task: Implement the `StyleTreeItem` hierarchy for the browser. 2895357
- [x] Task: Commit Phase 1. 2895357

## Phase 2: Live Preview Logic (AppCoreShared / CaptureOneUI)
- [x] Task: Implement `temporarilyApplyStyle(style:)` in `AdjustmentToolController`. 56f245c
- [x] Task: Bind hover events from the browser to the temporary adjustment state. 56f245c
- [x] Task: Ensure the `COViewerView` re-renders immediately during hover previews. 56f245c
- [x] Task: Commit Phase 2. 56f245c

## Phase 3: Style Application & Stacking (AppCoreShared)
- [x] Task: Implement `applyStyle(style:)` with "Stack Styles" support logic. eca7fcf
- [x] Task: Implement `applyStylesToVariants(styles:variants:)` for batch processing. eca7fcf
- [x] Task: Integrate with `VariantBase` layers if the style should be applied as a layer. eca7fcf
- [x] Task: Commit Phase 3. eca7fcf

## Phase 4: UI & Final Polish (CaptureOneUI)
- [x] Task: Reconstruct `StyleInspectorTool` using `OutlineView` or a hierarchical list. a5707cb
- [x] Task: Implement `StyleWithShortcutTableCellView` for high-fidelity row rendering. a5707cb
- [x] Task: Create a test case: hover over style -> verify preview -> click style -> verify application. a5707cb
- [x] Task: Commit Phase 4. a5707cb
