# Specification: Fix and complete the disassembly of Capture One binaries and frameworks

## Overview
The initial attempts to disassemble the main binary and several frameworks using `otool` resulted in process termination (Killed: 9). This indicates memory exhaustion or resource limits. This track focuses on fixing the disassembly script and ensuring that all binaries are successfully disassembled and stored for further analysis.

## Functional Requirements
- Identify the root cause of the `Killed: 9` errors.
- Implement a more robust disassembly strategy (e.g., batching, incremental processing, or using a more efficient tool).
- Ensure that the disassembly output for `Capture One` and all frameworks is complete.
- Verify that the generated disassembly files are stored in the correct locations within `Source/`.

## Non-Functional Requirements
- Resource efficiency: Avoid system-wide performance degradation during disassembly.
- Context retention: Ensure that the process is restartable and progress is logged.

## Acceptance Criteria
- All binaries listed in the app bundle have corresponding (non-truncated) disassembly files in `Source/`.
- No `Killed: 9` or segmentation fault errors occur during the process.
- The Git history contains a clear record of the successful disassembly steps.

## Out of Scope
- Full decompilation into high-level pseudo-code (this is Phase 3 of the main plan, but this track specifically addresses the disassembly infrastructure).
