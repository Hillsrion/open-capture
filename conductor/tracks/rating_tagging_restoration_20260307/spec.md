# Specification: Rating & Color Tagging Restoration

## Objective
Reconstruct the logic and UI for rating images (0-5 stars) and applying color tags (Red, Orange, Yellow, Green, Blue, Purple, Pink). This is a core part of the Capture One workflow for culling and organizing images.

## Scope
- **Data Models**: Update `MCVariant` and related models in `AppCoreShared` to store and persist rating and color tag values.
- **UI Components**:
    - Reconstruct the star rating control (0-5 stars).
    - Reconstruct the color tag picker (circular or square color swatches).
    - Implement keyboard shortcut bindings (1-5 for stars, 6-9 and + for colors).
- **Overlays**: Add rating and color tag indicators to the `COImageBrowserView` thumbnails.
- **Filtering**: Update the browser filtering logic to allow filtering by rating and color.

## Success Criteria
- [ ] Users can set star ratings via UI and keyboard shortcuts.
- [ ] Users can apply color tags via UI and keyboard shortcuts.
- [ ] Star ratings and color tags are persisted in the `MCVariant` dictionary.
- [ ] Thumbnails in the browser display the current rating and color tag.
- [ ] The browser updates instantly when a rating or tag is changed.
