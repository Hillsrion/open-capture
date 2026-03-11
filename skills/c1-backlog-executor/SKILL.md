name: c1-backlog-executor
description: Expert workflow for implementing Capture One features from the Notion Reconstruction Backlog by cross-referencing decompiled symbols, functional specs, and visual assets.

# Capture One Reconstruction Workflow

This skill defines the methodology for high-fidelity reconstruction of Capture One 16.7 features. It ensures that every implementation is grounded in the original application's logic and visual standards.

## 1. Backlog Analysis & Prioritization
- **Notion Source**: Query the `Reconstruction Backlog` database (ID: `3200db11-ba37-81de-badb-e66c9dd6649a`).
- **Ticket Parsing**: Extract the Title, Description, and `Spec_Reference`. 
- **Goal Alignment**: Understand if the task is **Core Engine** (logic/algorithms) or **UI Layout** (SwiftUI/fidelity).

## 2. Technical Research (The "Truth" Phase)
- **Symbol Mapping**: Use `grep_search` on `RawDumps/Headers/` to find original property keys (e.g., `ZEXPOSURE`, `ZKEYSTONE_TILTX`) and class names (`CImgOp...`, `MC...`).
- **Logic Recovery**: Analyze `RawDumps/Source/` or symbol files to understand the mathematical relationship between values.
- **Fidelity Check**: For UI, cross-reference the `Global Specs Database` on Notion and local video transcripts/frames (using `openc1-spec-manager` skill) to match the exact 16.7 nomenclature and layout.

## 3. Implementation Strategy
- **Base Structure**: Always check if the required properties exist in `AdjustmentToolController.swift` and `IC_ProcessSettings` (in `ImageCoreBase.swift`).
- **Persistence**: Ensure new properties are added to `commitChanges` and `refreshToolValues` in the controller to maintain sync with the underlying `MCVariant` model.
- **UI Components**: Use `COToolSection` and `COToolValueSlider` to maintain consistency with the reconstructed design system.

## 4. Execution & Validation
- **Atomic Implementation**: Work on one ticket at a time.
- **Build Verification**: Run `cd src && swift build` after every significant change. Never proceed to the next ticket if the build fails.
- **Surgical Edits**: Use the `replace` tool with enough context to ensure precision, especially in large files like `AdjustmentToolController.swift`.

## 5. Post-Action & Synchronization
- **Commit**: One commit per ticket. Use descriptive messages (e.g., `feat(ui/engine): implement auto-keystone line detection`).
- **Notion Update**: Set the ticket status to `Done` immediately after a successful build and commit.
- **Next Loop**: Re-query the backlog for the next `To Do` item.

## Reference Paths
- **Decompiled Headers**: `RawDumps/Headers/`
- **Reconstructed Source**: `src/Sources/`
- **UI Styles**: `src/Sources/CaptureOneUI/CaptureOneTheme.swift`
- **Controller**: `src/Sources/CaptureOneUI/AdjustmentToolController.swift`
