# Specification: Clarity & Structure Restoration

## Objective
Reconstruct the Clarity and Structure tools, which are core adjustments in Capture One for enhancing midtone contrast and high-frequency details.

## Scope
- **Kernels**: Implement `ClarityKernels` simulating the 4 methods (Classic, Punch, Neutral, Natural) and Structure enhancement.
- **UI Components**:
    - Reconstruct `ClarityToolView` with sliders for Amount and Structure, and a picker for the Method.
- **Integration**:
    - Add the tool to the `AdjustmentToolController` state.
    - Bind it to `MCVariant` and `IC_ProcessSettings` (already partially done).
    - Insert the view into the Culling window's ADJUST tab.

## Success Criteria
- [ ] Users can adjust Clarity Amount (-100 to 100) and Structure (-100 to 100).
- [ ] Users can select between Classic, Punch, Neutral, and Natural methods.
- [ ] Changes are persisted in `MCVariant` and passed to the `ImageCorePipeline`.
