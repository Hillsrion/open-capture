# Reconstruction Guidelines & Mandates

This file contains foundational mandates for the Capture One reconstruction project. These instructions take precedence over general defaults.

## 1. Documentation Standards
- **Content:** Write "real" technical documentation (architectural overviews, module interactions, reconstructed API references) instead of just action summaries.
- **Location:** Documentation should be stored in `reconstructed_codebase/docs/`.
- **Frequency:** Update documentation alongside every major phase or significant module extraction.
- **Tone:** Professional, senior-engineer level technical documentation.

## 2. Token Consumption Reporting
- **Requirement:** After each session or major block of work, provide a "Session Token Report".
- **Data Points:**
    - Estimated tokens processed in tool calls (especially `read_file`, `grep_search`, `run_shell_command`).
    - Estimated output tokens.
    - Context usage trends.
- **Storage:** Maintain a log at `reconstructed_codebase/docs/token_usage.md`.

## 3. Skill Management
- **Action:** If a specific workflow or complex reverse-engineering task becomes repetitive, use the `skill-creator` tool to formalize it into a Gemini CLI skill.
- **Documentation:** Any new skill must be documented in the project's technical docs.

## 4. Source Control
- **Commits:** Use git commits for action summaries ("what" was done).
- **Docs:** Use the `docs/` folder for "why" and "how it works" (the reconstructed engineering logic).
