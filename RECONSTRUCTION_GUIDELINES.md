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

## 6. UI Bridging Strategy (AppKit to SwiftUI)
- **Architectural Shift:** The original codebase is built on **AppKit** (`NSControl`, `NSCell`, `NSView`) with imperative drawing logic (`drawRect:`). Our reconstruction uses **SwiftUI** for its modern state management and declarative UI.
- **High-Fidelity Translation:**
    1. **Style Extraction:** Analyze AppKit drawing methods (e.g., `drawBarInside:flipped:`) to extract constants like track thickness, corner radius, and shadow offsets.
    2. **SwiftUI Implementation:** Replicate these visuals manually in SwiftUI using `GeometryReader`, `Path`, and custom `Shape` modifiers. Do not rely on native SwiftUI defaults (which follow macOS system styles, not C1 custom styles).
    3. **Bipolar Logic:** For sliders that start from the center (Exposure, Contrast), implement custom range-mapping in the SwiftUI view to draw the active track correctly from the zero-point.
    4. **Compatibility Layer:** Provide `NSColor` extensions and AppKit-to-SwiftUI color mappings in `CaptureOneTheme.swift` to ensure consistency when bridging legacy AppKit code with new SwiftUI views.
