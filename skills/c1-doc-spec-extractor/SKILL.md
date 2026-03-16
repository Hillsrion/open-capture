---
name: c1-doc-spec-extractor
description: Analyzes Capture One User Guide (online or local specs.html) to extract UI specifications, button placements, options, and commands to deduce features and update the project backlog (Notion Tickets). Use when the user needs to ensure the reconstructed codebase matches the official documentation's UI layout and functionality.
---

# Capture One Documentation Spec Extractor

This skill provides a systematic workflow for crawling or parsing the Capture One User Guide to extract high-fidelity UI specifications, bypassing Cloudflare restrictions when necessary.

## Workflows

### 1. Exa-based Deep Extraction (Recommended for Online)
Use this when direct crawling via `web_fetch` is blocked by Cloudflare (403).
1.  **Construct Targeted Queries**: Use `web_search_exa` with `livecrawl: 'preferred'` and `numResults: 10`.
    -   *Query Pattern*: `site:support.captureone.com "Feature Name" OR "Tool Name"`.
2.  **Batch Processing**: Group similar features (e.g., "AI Masking" + "Subject Selection") to maximize context usage.
3.  **Content Refinement**: Extract raw text, identifying UI hierarchies (Sliders, Buttons, Dropdowns) even without HTML.
4.  **Visual Search**: Use `google_web_search` specifically for "Capture One [Feature] interface screenshot" to find visual references.

### 2. Local Parsing Workflow
Use this when a local `docs_raw/specs.html` containing a dump of the User Guide is available.
1.  **Run Parser**: Execute `python3 scripts/parse_local_specs.py docs_raw/specs.html docs_raw/`.
2.  **Inspect Extracted Files**: Individual articles will be saved as `docs_raw/Local_*.html`.

### 3. Analysis and Notion Integration
1.  **Deduce Features**: Map extracted UI items to functional commands and underlying logic (e.g., "Reset button" -> `resetCommand`).
2.  **Codebase Parity**: Use `grep_search` on `RawDumps/` to find matching symbols/classes (e.g., `AICropInspectorTool`).
3.  **Ticket Generation (Notion)**: Create entries in the **Tickets** database (ID: `b970db11-ba37-8351-bf14-01025baf506e`).
    -   **Issue**: Clear feature name.
    -   **Type**: Set to `Feature Request` or `Improvement`.
    -   **Priority**: Based on documentation prominence.
    -   **Sprints**: Link to the relevant active Sprint (ID: `6360db11-ba37-82bb-bc58-81e475e8da56`).
    -   **Page Content**: Include the mandatory **Demande** and **Plan** sections.
        -   **Demande**: Include the literal, unedited text retrieved by Exa/local parser for the specific feature.
        -   **Plan**: Detailed Markdown plan covering Engine Integration, UI Components, and Visual Fidelity.

## Extraction Template

For each UI tool/area, aim to extract:
-   **ID**: Internal ID from symbols (e.g., `_geometryKeystoneAmountKey`).
-   **Parent Container**: Tool Tab (Shape, Lens, Adjust, etc.).
-   **Elements**: List of buttons, sliders, menus.
-   **Special States**: Studio-only features, Pro-only modes.
-   **Visual Reference**: Link/path to the image illustrating this tool.

## Tools to Use
-   `web_search_exa`: Primary tool for Cloudflare bypass.
-   `google_web_search`: For finding interface screenshots.
-   `notion_search` / `add_database_entry`: For backlog management.
-   `grep_search`: For identifying decompiled symbols.
-   `generalist`: Delegate large-scale data harvesting.
