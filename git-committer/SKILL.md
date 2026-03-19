---
name: git-committer
description: Automates high-fidelity git commits with context-aware messages and ticket ID extraction. Use when the user requests to "commit" or "wrap up" changes, especially in projects using Conventional Commits and ticket-based workflows (e.g., ENG-XXX, UI-XXX).
---

# Git Committer

This skill automates the process of creating high-quality, atomic git commits by analyzing the codebase and current diffs.

## Workflow

1. **Analyze Diff**: Run `git diff HEAD` and `git status` to identify modified and untracked files.
2. **Extract Context**:
    - Identify the primary architectural layer being modified (e.g., `ImageCore`, `CaptureOneUI`, `DataCore`).
    - Search the diff for ticket patterns like `ENG-\d+` or `UI-\d+` to include in the message.
3. **Atomic Grouping**: If changes span unrelated layers (e.g., a shader fix and a UI layout change), group them into separate commits.
4. **Draft Message**: Propose a message following the Conventional Commits standard:
   - `type(scope): [ID] description`
   - Use types: `fix`, `feat`, `refactor`, `perf`, `chore`.
   - Use the architectural layer as the scope.
5. **Execute**: Stage the files and perform the commit.

## Principles

- **Context Efficiency**: This skill is designed to prevent large diffs from bloating the main conversation history. By delegating the commit process to this skill (or a sub-agent using it), the main session only receives a success summary.
- **Safety**: Do not commit if there are obvious build errors or if the user hasn't confirmed the changes (unless in YOLO/autonomous mode).
- **Transparency**: Always show the proposed commit message before executing, unless the user explicitly said "just commit everything".

## Conventional Commit Examples

- `fix(ImageCore): [ENG-204] normalize exposure evaluation math`
- `feat(CaptureOneUI): [UI-202] implement HDR slider with high-fidelity feedback`
- `refactor(DataCore): [ENG-115] optimize variant metadata lookup`
