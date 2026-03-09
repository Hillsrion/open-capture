---
name: c1-doc-spec-extractor
description: Analyzes Capture One User Guide to extract UI specifications, button placements, options, and commands to deduce features and update the project backlog. Use when the user needs to ensure the reconstructed codebase matches the official documentation's UI layout and functionality.
---

# Capture One Documentation Spec Extractor

This skill provides a systematic workflow for crawling the Capture One User Guide to extract high-fidelity UI specifications.

## Workflow

1.  **Crawl Root URL**: Start at `https://support.captureone.com/hc/en-us/categories/360000279017-User-guide`.
2.  **Identify Sections**: Extract all section links (e.g., "User Interface", "Working with Colors", "Exposure and Contrast").
3.  **Extract Article Content**: For each section, visit all articles.
    -   **Extract Textual Specs**: Identify UI elements (buttons, sliders, fields), their locations (e.g., "Exposure tool in the Exposure tool tab"), and their associated options.
    -   **Identify Images**: Capture URLs of screenshots that show UI layouts.
    -   **YouTube Video Processing**: If a YouTube video is embedded:
        -   **Extract Transcript**: Use available tools or web search to retrieve the video's transcript.
        -   **Identify Key Frames**: Based on the transcript, identify timestamps where specific UI elements or workflows are demonstrated.
        -   **Visual Context**: Use the transcript and description to document UI placements that might be missing from static images.
4.  **Deduce Features**: map extracted UI items to functional commands and underlying logic (e.g., "Reset button" -> `resetCommand`).
5.  **Identify Gaps**: Compare the extracted specs with:
    -   Existing codebase (especially `reconstructed_codebase/Sources/CaptureOneUI/`).
    -   The current `@conductor/backlog.md`.
6.  **Update Backlog**: Add missing UI items and functional gaps to `conductor/backlog.md` with high precision.

## Extraction Template

For each UI tool/area, aim to extract:

-   **ID**: Internal ID if guessable, or descriptive name.
-   **Parent Container**: Tool Tab, Palette, or Toolbar.
-   **Elements**: List of buttons, sliders, menus.
-   **Sub-options**: Dropdowns, checkboxes, or hidden menus.
-   **Visual Reference**: Link to the image illustrating this tool.

## Tools to Use

-   `web_fetch`: To retrieve content from URLs.
-   `grep_search` / `read_file`: To inspect the existing codebase for parity checks.
-   `generalist`: Delegate the large-scale crawling and summarization to the generalist sub-agent to preserve main session context.
