# Product Guidelines

## Documentation & Prose Style: Combined Technical and Log
- **Architectural Overviews:** Provide high-level technical documentation for all reconstructed modules, focusing on architectural patterns and module interactions.
- **Decompilation Reasoning:** For complex logic, include a reverse-engineering log that captures the step-by-step reasoning for decompilation decisions and interpretation of assembly.
- **Target Audience:** Reconstructed documentation is written for senior software engineers and security researchers.

## User Interface: Faithful Replication
- **Aesthetic:** Prioritize a faithful replication of the original Capture One user interface, branding, and interactive feedback.
- **Technology:** Use standard macOS frameworks (AppKit, SwiftUI) to recreate the original experience.
- **Goal:** The final software must feel, look, and behave like the original application.

## Code Organization: Bundle-Parity Structure
- **Directory Structure:** Reconstructed source code MUST match the original `.app` bundle structure and framework boundaries (e.g., `Headers/Frameworks/ImageCore/`, `Source/Main/`).
- **Module Boundaries:** Maintain clear isolation between reconstructed frameworks as they appear in the original binary.
- **Consistency:** Ensure that the file layout in the `src/` remains consistent with the original application's organization.

## Context Retention: Clean Reconstruction
- **Source Code Hygiene:** The final reconstructed source files should be "clean" and free of massive assembly or intermediate pseudo-code blocks.
- **Documentation Separation:** Use external documentation files (e.g., in `docs/`) to explain the "how" and provide detailed discovery notes, keeping the actual source files focused on functionality.
- **Traceability:** Maintain high-level traceability from reconstructed logic to the original binary sections in the external documentation.

# Operational Mandates
- **Git Commit Hygiene:** Every significant step in the reconstruction must be committed with a detailed description in the git history to preserve "context and history".
- **Token Usage Logs:** Maintain the `docs/token_usage.md` log to track context consumption for future analysis.
