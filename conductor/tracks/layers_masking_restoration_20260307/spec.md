# Specification: Layers & Masking Restoration

## Objective
Reconstruct the logic and UI for multi-layered image adjustments. Capture One supports multiple layers (Adjustment, Cloning, Healing) each with its own mask, opacity, and set of adjustments.

## Scope
- **Data Models**:
    - Update `VariantBase` to manage an array of `LayerBase` objects.
    - Reconstruct `LayerBase` with properties like `name`, `opacity`, `isVisible`, `maskUUID`, and `layerType`.
- **Masking Engine**:
    - Reconstruct basic mask representation (bitmap or raster-based).
    - Implement alpha-blending logic in `ImageCorePipeline`.
- **UI Components**:
    - Reconstruct the `LayersInspectorView` (layer stack, add/remove, toggle visibility).
    - Implement an opacity slider for the selected layer.
- **ImageCore Integration**:
    - Update `IC_ProcessSettings` to support a stack of layer settings.
    - Update `ImageCorePipeline` to process adjustments per-layer and blend them.

## Success Criteria
- [ ] Users can create and manage multiple adjustment layers.
- [ ] Each layer can have an independent opacity (0-100%).
- [ ] Toggling layer visibility instantly updates the image preview.
- [ ] Adjustments are correctly blended according to layer masks and opacity.
