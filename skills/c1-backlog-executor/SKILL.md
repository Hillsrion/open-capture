name: c1-backlog-executor
description: Expert workflow for implementing Capture One features from the Notion Sprints & Tickets system by cross-referencing decompiled symbols, functional specs, and visual assets.

# Capture One Reconstruction Workflow

This skill defines the methodology for high-fidelity reconstruction of Capture One 16.7 features. It ensures that every implementation is grounded in the original application's logic and visual standards.

## 1. Backlog Analysis & Operating Modes
- **Primary Source**: Query the `Tickets` database (ID: `b970db11-ba37-8351-bf14-01025baf506e`).
- **Modes of Operation**:
  - **Normal Mode**: Research -> `enter_plan_mode` -> Update Notion Ticket -> **Seek User Approval** -> Execute.
  - **Loop Mode**: (Triggered by user request)
    1. Research & Plan: Use `enter_plan_mode` and update Notion.
    2. **Delegation**: Invoke the `generalist` sub-agent to perform the implementation and validation. Provide the sub-agent with the Notion Plan and relevant file paths.
    3. Finalization: Review the sub-agent's summary, perform the final commit(s) in the main session, and update Notion status.
    4. **Seek Validation only at the end of the ticket** before the next one.
- **Sprint Isolation**: Filter by the active `Sprint` relation.
- **Plan Requirement**: Even in Loop Mode, you MUST enter `enter_plan_mode` and write a technical plan into the Notion ticket BEFORE modifying any code.

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
- **Atomic Commits**: You can perform multiple commits for a single large ticket. Every commit MUST include the Ticket ID.
  - **Format**: `[ID-<number>] <type>(<scope>): <description>`.
- **Notion Update**: 
  - Set the ticket status to `Done` only after the final implementation and build.
  - **Resolution Notes**: You MUST update the `Resolution Notes` property in Notion with a summary of the changes (typically a concatenation of your commit descriptions).
- **Next Loop**: Re-query the sprint backlog for the next `Not started` item.

## Reference Paths
- **Decompiled Headers**: `RawDumps/Headers/`
- **Reconstructed Source**: `src/Sources/`
- **UI Styles**: `src/Sources/CaptureOneUI/CaptureOneTheme.swift`
- **Controller**: `src/Sources/CaptureOneUI/AdjustmentToolController.swift`
- **Sprints Database**: `6360db11-ba37-82bb-bc58-81e475e8da56`
- **Tickets Database**: `b970db11-ba37-8351-bf14-01025baf506e`
