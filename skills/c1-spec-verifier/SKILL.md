name: c1-spec-verifier
description: Expert workflow for creating verification tickets in Notion for every specification in the Global Specs Database, and systematically auditing the reconstructed codebase against these specs.

# Capture One Spec Verification Workflow

## Core Execution Mode
- **Default Behavior**: When the user says "reprends la vérification" (resume verification) or similar, the skill's primary objective is to **Audit AND Act**. If discrepancies or missing features are found, implement the fixes immediately in the codebase.
- **Verification-Only Mode**: Only if the user explicitly specifies "vérifie seulement" (only verify) or "crée les tickets" (only create tickets), should the skill stop at the audit phase and simply log discrepancies in the `Spec Verification Tracker` and `Reconstruction Backlog`.
- **Delegation Strategy (Efficiency)**: For tasks involving more than 2 tickets or high-volume build logs, the agent MUST delegate the execution to the `generalist` sub-agent. This keeps the main session context lean by compressing dozens of technical turns into a single summary.

## 1. Database Setup & Initialization
- **Target Databases**: 
  - `Global Specs Database` (ID: `3200db11-ba37-819a-9122-c59d20dedc49`) - The source of truth.
  - `Spec Verification Tracker` (ID: `3210db11-ba37-81e6-b1ab-ef081a9271da`) - Tracks the audit status of every spec.
- **Initialization**: Query the `Global Specs Database` to retrieve all specifications. For each spec, check if a corresponding verification ticket exists in the `Spec Verification Tracker`. If not, create one.

## 2. Ticket Structure & Schema
Every verification ticket in the `Spec Verification Tracker` should contain:
- **Title**: "[Spec Title] - Verification"
- **Status**: `To Verify`, `In Progress`, `Partially Implemented`, `Verified/Done`, `Failed`.
- **Ticket_ID**: Semantic identifier (e.g., `UI-801`) used in commit messages.
- **Spec Relation**: A link/relation to the original spec in the `Global Specs Database`.
- **Category**: (UI & Layout, Editing Tools, etc.) inherited from the original spec.
- **Checklist/Notes**: The body of the ticket must include a breakdown of the specific UI components and logic expected from the spec.

## 3. Verification Process (The Audit Phase)
For a given ticket in `To Verify` or `In Progress` status:
1. **Spec Extraction**: Read the detailed content (blocks) of the original spec from the `Global Specs Database`. Extract the UI components, keyboard shortcuts, and logic rules. Note the `YT_ID` property.
2. **Visual & Source Verification (Local Reference)**: 
   - Ensure the `yt-downloader` skill is activated.
   - **Avoid Duplicates**: Before downloading, check if reference files (e.g., `ref_[name].en.srt` or extracted frames) already exist on disk.
   - Use `yt-dlp` to download the reference video and transcript if missing.
   - Extract frames locally using `ffmpeg` if missing.
   - **Crucial Transcript Cross-Referencing**: Grep the transcript for keywords to identify the exact timestamps where the UI is used.
   - **Frame Analysis**: Visually verify 100% fidelity (order, naming, icons, icons casing).
3. **Codebase Audit (Wiring & Logic)**:
   - **Binding Verification**: Ensure UI components are correctly wired to `AdjustmentToolController`, `AppCommandCenter`, or `CameraModels`.
   - **Persistence Audit**: Verify that changes in the UI are correctly captured in the `commitChanges` or `saveWorkspace` logic.
   - **Modifier Key Logic**: Search for handling of `Shift`, `Option` (Alt), or `Command` modifiers mentioned in the spec or discovered in disassembly.
4. **Symbolic Accuracy Audit**:
   - **Field Naming**: Search for the tool's core class in `RawDumps/Headers/`.
   - **Match Nomenclature**: Ensure the reconstructed Swift properties match the decompiled symbols (e.g., `vignettingAmount` vs `vignetteLevel`).
5. **Interactive Integrity**:
   - **Hit-Testing**: Verify that custom UI elements have correct `contentShape` and capture clicks reliably.
   - **Actor Isolation**: Ensure @Published updates and UI-driven actions are marked with `@MainActor`.
6. **Discrepancy Logging**: If differences or nomenclature deviations are found, note them in the verification ticket and fix them immediately (unless in Verification-Only mode).

## 4. Technical Validation & Stability
- **Build Mandatory**: After each implementation fix, execute `cd src && swift build`. No ticket can be marked `Verified/Done` if the project does not compile.
- **Redundancy Check**: Systematically verify for redeclarations (`invalid redeclaration`) when adding new component files.
- **Commitment**: Every modification must be committed with the format: `feat(ui): [description] [Ticket: UI-XXX]`. Use `git commit --amend` if build fixes are needed for the same ticket.

## 5. Resolution & Status Updates
- **Full Compliance**: If the implementation matches the spec and decompiled truth 100% and the build passes, update the ticket status to `Verified/Done`.
- **Partial Compliance**: If core functionality exists but UI details or edge cases are missing, update the status to `Partially Implemented` and list missing items.
- **Actionable Output**: If `Partially Implemented`, generate a corresponding task in the `Reconstruction Backlog` (ID: `3200db11-ba37-81de-badb-e66c9dd6649a`) linking back to the verification ticket.

## Reference Paths & Commands
- **Global Specs Database ID**: `3200db11-ba37-819a-9122-c59d20dedc49`
- **Spec Verification Tracker ID**: `3210db11-ba37-81e6-b1ab-ef081a9271da`
- **Reconstruction Backlog ID**: `3200db11-ba37-81de-badb-e66c9dd6649a`
- **MCP Notion Tools**: `mcp_notion_query_database`, `mcp_notion_create_page`, `mcp_notion_update_page`, `mcp_notion_get_page`.
- **Codebase Search**: `grep_search`, `glob` on `src/` and `RawDumps/Headers/`.
