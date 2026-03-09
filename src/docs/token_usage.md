# Token Consumption Log

## Session 2026-03-07T01:30 (Initial Reconstruction)
- **Tool Call Inputs:** ~120k tokens.
- **Tool Call Outputs:** ~3.2M tokens.
- **Outcome:** Partial disassembly achieved, but hit resource limits (Killed: 9).

## Session 2026-03-07T03:40 (Disassembly Infrastructure Fix)
- **Tool Call Inputs:** ~250k tokens (multiple script iterations and manual tests).
- **Tool Call Outputs:** ~5M tokens (Full metadata extraction and verification).
- **Files Generated on Disk:** ~8GB total (Reconstructed source and assembly).
- **Optimization:** Shifted to `objdump` and architecture-specific thinning to avoid process termination. Use of `git notes` for auditable tracking.
