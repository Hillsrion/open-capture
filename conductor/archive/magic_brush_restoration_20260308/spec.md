# Specification: Magic Brush & Smart Masking (AI-001)

## Overview
This track focuses on the reconstruction of Capture One's AI-powered masking engine. The "Magic Brush" allows users to create complex masks by simply brushing over an area; the engine automatically expands the selection based on color and luminance tolerance. The reconstruction will also include the infrastructure for CoreML-based masking (Subject/Face detection).

## Functional Requirements
- **Magic Brush Engine:**
    - **Tolerance Logic:** Reconstruct the algorithm that samples the color/luma under the cursor and expands the mask to contiguous pixels within a specified tolerance.
    - **Refine Edge:** Implement the edge-aware refinement logic discovered in `setMagicBrushRefineEdgeMax`.
    - **Magic Eraser:** Implement the inverse logic for smart subtraction from existing masks.
- **AI Masking Infrastructure:**
    - **Model Loading:** Reconstruct the logic to load CoreML models (`FaceMaskingModel`, `subjectMaskingFP16`).
    - **AI Segmentation:** Implement the high-level API to trigger full-image segmentation for "Select Subject" or "Select Background".
- **Data Models:** Reconstruct `MagicBrushSettings` (Tolerance, Refine Edge, Size) and `VariantMagicBrushLayer`.
- **UI Interaction:**
    - **Brush Settings Tool:** Reconstruct the floating/docked inspector for Magic Brush parameters.
    - **Interactive Feedback:** Ensure the mask overlay (red tint) updates in real-time during brushing.

## Non-Functional Requirements
- **Low Latency:** AI-based operations must be highly optimized using the GPU (Metal/CoreML) to avoid UI stutters.
- **Precision:** The tolerance engine must provide granular control, matching the v16.5 high-fidelity mask boundaries.

## Acceptance Criteria
- Magic Brush correctly selects contiguous areas based on tolerance settings.
- Magic Eraser removes areas from the mask with similar smart logic.
- "Select Subject" successfully generates a rough binary mask using a (mocked or loaded) CoreML model.
- Settings are correctly persisted and linked between Brush and Eraser when the "Link" option is checked.

## Out of Scope
- Manual brush engine (handled in `ENG-005`).
- Feathering and Flow logic for standard brushes.
