name: c1-spec-verifier
description: Expert workflow for creating verification tickets in Notion for every specification in the Global Specs Database, and systematically auditing the reconstructed codebase against these specs.

# Capture One Spec Verification Workflow

This skill defines the methodology for tracking, verifying, and auditing the implementation status of all Capture One 16.7 features defined in the Global Specs Database.

## 1. Database Setup & Initialization
- **Target Databases**: 
  - `Global Specs Database` (ID: `3200db11-ba37-819a-9122-c59d20dedc49`) - The source of truth.
  - `Spec Verification Tracker` - A newly created or existing Notion database used specifically to track the implementation and QA status of every spec.
- **Initialization**: Query the `Global Specs Database` to retrieve all available specifications. For each spec, check if a corresponding verification ticket exists in the `Spec Verification Tracker`. If not, create one.

## 2. Ticket Structure & Schema
Every verification ticket in the `Spec Verification Tracker` should contain:
- **Title**: "[Spec Title] - Verification"
- **Status**: `To Verify`, `In Progress`, `Partially Implemented`, `Verified/Done`, `Failed`.
- **Spec Relation**: A link/relation to the original spec in the `Global Specs Database`.
- **Category**: (UI & Layout, Editing Tools, etc.) inherited from the original spec.
- **Checklist/Notes**: The body of the ticket must include a breakdown of the specific UI components and logic expected from the spec.

## 3. Verification Process (The Audit Phase)
For a given ticket in `To Verify` or `In Progress` status:
1. **Spec Extraction**: Read the detailed content (blocks) of the original spec from the `Global Specs Database`. Extract the UI components, keyboard shortcuts, and logic rules. Note the `YT_ID` property.
2. **Visual & Source Verification (Local Reference)**: 
   - Ensure the `yt-downloader` skill is activated.
   - Use `yt-dlp` to download the reference video: `mkdir -p .entire/tmp/yt_downloads/frames/<YT_ID> && cd .entire/tmp/yt_downloads/frames/<YT_ID> && yt-dlp "https://www.youtube.com/watch?v=<YT_ID>" -o "video.mp4"`
   - If `yt-dlp` fails due to format issues, try with `-f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"`.
   - Download the transcript: `yt-dlp --write-auto-subs --write-subs --sub-langs "en.*" --skip-download --convert-subs srt "https://www.youtube.com/watch?v=<YT_ID>" -o "transcript.srt"`
   - Extract frames locally using `ffmpeg`: `ffmpeg -i "video.mp4" -vf "fps=1" frame_%04d.jpg`
   - **Important**: Do not commit these frames to git. They are local analytical references to ensure structural fidelity (icons, layout, component order).
3. **Codebase Audit**: 
   - Use `grep_search` and `glob` to locate the relevant implementation files in `src/Sources/CaptureOneUI/` and `src/Sources/AppCoreShared/` or `DataCore/`.
   - Use `read_file` to analyze the implementation.
4. **Fidelity Comparison**: Compare the implemented SwiftUI code and business logic against:
   - The spec's textual requirements.
   - The actual extracted local frames (UI layout, exact text casing, tool position).
   - Decompiled symbols (using `grep_search` in `RawDumps/Headers/`) to ensure correct property names and internal logic mapping.
5. **Discrepancy Logging**: If differences, missing features (e.g., missing context menu options, missing auto-favorite toggle), or deviations are found, note them in the verification ticket.

## 4. Resolution & Status Updates
- **Full Compliance**: If the implementation matches the spec and decompiled truth 100%, update the ticket status to `Verified/Done`.
- **Partial Compliance**: If core functionality exists but UI details or edge cases are missing, update the status to `Partially Implemented` and list the missing items in the ticket body.
- **Actionable Output**: If a ticket is `Partially Implemented`, generate a corresponding task/ticket in the `Reconstruction Backlog` (ID: `3200db11-ba37-81de-badb-e66c9dd6649a`) linking back to the verification ticket so the `c1-backlog-executor` can fix it.

## Reference Paths & Commands
- **Global Specs Database ID**: `3200db11-ba37-819a-9122-c59d20dedc49`
- **Reconstruction Backlog ID**: `3200db11-ba37-81de-badb-e66c9dd6649a`
- **MCP Notion Tools**: `mcp_notion_query_database`, `mcp_notion_create_page`, `mcp_notion_update_page`, `mcp_notion_get_page`.
- **Codebase Search**: `grep_search`, `glob` on `src/` and `RawDumps/Headers/`.