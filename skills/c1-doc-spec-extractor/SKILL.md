---
name: c1-doc-spec-extractor
description: Analyzes Capture One User Guide (online or local specs.html) to extract UI specifications, button placements, options, and commands to deduce features and update the project backlog. Use when the user needs to ensure the reconstructed codebase matches the official documentation's UI layout and functionality.
---

# Capture One Documentation Spec Extractor

This skill provides a systematic workflow for crawling or parsing the Capture One User Guide to extract high-fidelity UI specifications.

## Workflows

### 1. Web Crawling Workflow
1.  **Crawl Root URL**: Start at `https://support.captureone.com/hc/en-us/categories/360000279017-User-guide`.
2.  **Identify Sections**: Extract all section links.
3.  **Extract Article Content**: For each section, visit all articles.
    -   **Extract Textual Specs**: Identify UI elements (buttons, sliders, fields) and their locations.
    -   **Identify Images**: Capture URLs of screenshots.

### 2. Local Parsing Workflow (Recommended for speed)
Use this when a local `docs_raw/specs.html` containing a dump of the User Guide is available.
1.  **Run Parser**: Execute `python3 scripts/parse_local_specs.py docs_raw/specs.html docs_raw/`.
2.  **Inspect Extracted Files**: Individual articles will be saved as `docs_raw/Local_*.html`.
3.  **Analyze**: Process these files as if they were crawled.

### 3. Analysis and Integration (Common to both)
1.  **YouTube Video Processing**: If a YouTube video is embedded, extract transcript and identify key frames for UI demonstration.
2.  **Deduce Features**: Map extracted UI items to functional commands and underlying logic (e.g., "Reset button" -> `resetCommand`).
3.  **Identify Gaps**: Compare extracted specs with existing codebase and `@conductor/backlog.md`.
4.  **Update Backlog**: Add missing UI items and functional gaps to `conductor/backlog.md`.

## Extraction Template

For each UI tool/area, aim to extract:
-   **ID**: Internal ID if guessable, or descriptive name.
-   **Parent Container**: Tool Tab, Palette, or Toolbar.
-   **Elements**: List of buttons, sliders, menus.
-   **Sub-options**: Dropdowns, checkboxes, or hidden menus.
-   **Visual Reference**: Link/path to the image illustrating this tool.

## Tools to Use
-   `web_fetch` / `web_search_exa`: For crawling.
-   `scripts/parse_local_specs.py`: For local parsing.
-   `grep_search` / `read_file`: For codebase parity checks.
-   `generalist`: Delegate large-scale crawling or parsing.
