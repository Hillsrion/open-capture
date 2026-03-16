name: c1-backlog-executor
description: Expert workflow for implementing Capture One features from the Notion Sprints & Tickets system by cross-referencing decompiled symbols, functional specs, and visual assets.

# Capture One Reconstruction Workflow

This skill defines the methodology for high-fidelity reconstruction of Capture One 16.7 features. It ensures that every implementation is grounded in the original application's logic and visual standards.

## 1. Backlog Analysis & Operating Modes
- **Sprint Management**: 
  - Set the parent Sprint to `In Progress` when starting the first ticket.
  - Set the parent Sprint to `Done` once the last ticket of that sprint is `Resolved`.
- **Token Efficiency Rules**:
  - **Notion Limit**: ALWAYS use `limit: 1` when querying the `Tickets` database to find a specific task to prevent context bloating.
  - **Notion Fire-and-Forget**: Combine status updates and property changes into a single `mcp_notion_update_page` call. Do not use `get_page` unless you absolutely need the full page content blocks; use properties from the query instead.
  - **Surgical Reading**: Prefer `grep_search` with `context`, `before`, or `after` parameters instead of `read_file` when investigating Swift files to keep the main orchestrator context clean.
- **Modes of Operation**:
  - **Normal Mode**: Research -> `enter_plan_mode` -> Update Notion Ticket (Add Plan + Set Status to `In Progress`) -> **Seek User Approval** -> Execute.
  - **Loop Mode**: (Triggered by user request)
    1. Research & Plan: Use `enter_plan_mode` and update Notion (Add Plan + Set Status to `In Progress`).
    2. **Delegation**: Invoke the `generalist` sub-agent. **INSTRUCTION**: Instruct the agent to be persistent (up to 15-20 turns) to resolve technical hurdles, but to stop and report if it enters a circular logic or hits a dead end.
    3. Finalization: Review the sub-agent's summary, perform the final commit(s), and update Notion status to `Resolved`.
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
  - **Format**: `<type>(<scope>): [ID-<number>] <description>` (e.g., `feat(ui/engine): [ID-11] implement auto-keystone line detection`).
- **Ticket Review**: 
  - Immediately after the implementation builds successfully, invoke `@codebase_investigator` to review the code against Capture One 16.7 fidelity and pro-level quality standards.
  - **Lightweight Fixes**: If the review finds minor issues (e.g., synchronous blocking, simple math errors), apply the fixes immediately and commit them.
  - **Heavy Corrections**: If the review uncovers deep architectural flaws, create a corrective ticket using the `c1-ticket-creator` skill and ask the user for guidance.
- **Notion Update**: 
  - Set the ticket status to `Resolved` only after the final implementation, review, and potential lightweight fixes.
  - **Resolution Notes**: You MUST update the `Resolution Notes` property in Notion with a summary of the changes.
- **Next Loop**: In Loop Mode, proceed to the next ticket automatically. Seek user validation ONLY at the very end of the sprint or loop scope.

## Reference Paths
- **Decompiled Headers**: `RawDumps/Headers/`
- **Reconstructed Source**: `src/Sources/`
- **UI Styles**: `src/Sources/CaptureOneUI/CaptureOneTheme.swift`
- **Controller**: `src/Sources/CaptureOneUI/AdjustmentToolController.swift`
- **Sprints Database**: `6360db11-ba37-82bb-bc58-81e475e8da56`
- **Tickets Database**: `b970db11-ba37-8351-bf14-01025baf506e`
