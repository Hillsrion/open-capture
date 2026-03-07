# Specification: Levels and Curves Tool Restoration

## Goal
Reconstruct the **Levels** and **Curves** tools with high fidelity, including the mathematical processing kernels (ImageCore) and the interactive UI widgets (CaptureOneUI).

## Context
Levels and Curves are fundamental tools in Capture One for controlling tonal range and color balance. They require complex mathematical interpolation (splines for curves) and real-time histogram feedback.

## Key Components
1.  **ImageCore Kernels**:
    *   `applyLevels`: Map input black, mid, and white points to the output range.
    *   `applyCurves`: Interpolate points using Catmull-Rom or Cubic splines to create a Look-Up Table (LUT).
2.  **CaptureOneUI Widgets**:
    *   `POLevelsControl`: Interactive histogram with 5 draggable handles (Shadows, Midtones, Highlights for Input/Output).
    *   `POCurvesControl`: Bezier/Spline editor with support for multiple channels (RGB, Luma, Red, Green, Blue).
3.  **AppCoreShared / ModelCore Integration**:
    *   Data models for storing curve points and levels values in `MCVariant`.

## References
*   `RawDumps/Headers/Main/LevelsInspectorTool_Structure.txt`
*   `RawDumps/Headers/Main/CurvesInspectorTool_Structure.txt`
*   `RawDumps/Headers/Main/POLevelsControl_Structure.txt`
*   `RawDumps/Headers/Main/POCurvesControl_Structure.txt`
