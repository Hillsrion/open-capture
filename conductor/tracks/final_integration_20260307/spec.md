# Specification: Final Integration and Compilation of Reconstructed Frameworks

## Overview
This track focuses on integrating the reconstructed modules (`AppCoreShared`, `ImageCore`, `DataCore`, `CaptureOneUI`) into a unified, compilable Swift project. We will use Swift Package Manager (SPM) to manage targets and dependencies, ensuring that all components can be built as a single cohesive unit.

## Functional Requirements
- **Unified Build System:** Implement a `Package.swift` file defining the modular architecture.
- **Dependency Resolution:** Correctly map and resolve internal dependencies (e.g., UI depending on Engine and Persistence).
- **Source Reorganization:** Move all reconstructed source and test files into the SPM-compliant `Sources/` and `Tests/` directory structure.
- **Successful Compilation:** Achieve a zero-error build using the `swift build` command.
- **Cross-Framework Interop:** Ensure that classes and protocols are correctly accessible across target boundaries (using `public` access modifiers).

## Non-Functional Requirements
- **Modular Integrity:** Maintain the original framework boundaries as separate SPM targets.
- **Code Cleanliness:** Fix any symbol collisions or type mismatches discovered during the integration phase.
- **Reproducibility:** Ensure the build is reproducible in a standard macOS/Swift environment.

## Acceptance Criteria
- A valid `Package.swift` file at the root of `reconstructed_codebase/`.
- Successful execution of `swift build` without errors.
- Successful execution of `swift test` for all integrated test suites.

## Out of Scope
- Reconstruction of new, non-analyzed frameworks.
- Implementation of a functional `.app` bundle (this track focuses on library compilation).
