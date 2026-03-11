---
name: openc1-spec-manager
description: Manage the relationship between local video assets (frames, transcripts) and the Open C1 Global Specs Database on Notion. Use this to systematically update specs, verify synchronization, and extract UI details from local data.
---

# Open C1 Spec Manager Skill

This skill provides the procedural knowledge to link local video-derived assets with the **Global Specs Database** on Notion (ID: `3200db11-ba37-819a-9122-c59d20dedc49`).

## Local Data Structure

Assets are stored in `.entire/tmp/yt_downloads/` (git-ignored):
- `transcripts/`: `.srt` files named by YouTube ID.
- `frames/`: Sub-folders per YouTube ID containing `frame_XXXX.jpg`.

## Core Workflows

### 1. Synchronize Video to Notion
When a new video is processed locally, use this workflow to create/update its entry:
1. **Locate ID**: Identify the YouTube ID from the folder name.
2. **Metadata**: Extract the Title and Category from the video filename or transcript header.
3. **Database Check**: Search the Notion database for the ID/Title to avoid duplicates.
4. **Content Generation**: 
   - Parse the transcript for "Button", "Slider", "Tab", "Shortcut", and "Window".
   - Group findings into "UI Components", "Interaction Logic", and "Location".
5. **Update**: Use `add_database_entry` or `append_blocks` to update Notion.

### 2. UI Element Extraction
To extract precise specs from a local transcript:
- **Scan for Location**: Look for "Tab", "Toolbar", "Menu".
- **Scan for Actions**: Look for verbs following button names ("Click", "Drag", "Hold").
- **Frame Matching**: Cross-reference timestamps in the transcript with `frame_XXXX.jpg` (e.g., `00:01:20` maps to `frame_0080.jpg` if extracting at 1fps).

### 3. Image Integrity Verification
- Ensure every technical spec page has at least **3 illustrative frames**.
- If a page is empty or low on visuals, use `upload_file_to_notion` with `mode: secure` from the corresponding `frames/ID/` directory.

## Automation Helpers

### Transcript Parsing Pattern (Grep)
Use this to quickly find UI mentions in local `.srt` files:
```bash
grep -iE "button|slider|dropdown|menu|shortcut|tab|window" .entire/tmp/yt_downloads/transcripts/ID.en.srt
```

## Notion Database Reference
- **Name**: Global Specs Database
- **ID**: `3200db11-ba37-819a-9122-c59d20dedc49`
- **Key Fields**: Title, Category, Source (URL), Tags.
