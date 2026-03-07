# Specification: Smart Albums & Advanced Filtering Restoration

## Objective
Reconstruct the logic and UI for "Smart Albums" (saved searches) and real-time filtering in the browser. This allows users to organize their images based on dynamic criteria like ratings, color tags, and (eventually) metadata like ISO, Aperture, or Keyword.

## Scope
- **Database Schema**: Update the `ZCOLLECTION` and `ZALBUM` schema (DataCore) to support predicate-based collections.
- **Filtering Engine**: 
    - Implement a SQL-based filtering engine that generates `WHERE` clauses from criteria.
    - Support filtering by:
        - Star Rating (0-5, range support).
        - Color Tag (multi-select).
        - Filename/Text search.
- **UI Components**:
    - Reconstruct the "Filters" tool in the sidebar.
    - Add the "Smart Album" creation dialog.
    - Implement real-time update of the `COImageBrowserView` based on active filters.

## Success Criteria
- [ ] Users can create "Smart Albums" that automatically update based on rating/color tag changes.
- [ ] Users can apply ad-hoc filters in the browser (e.g., "Show all 5-star Green images").
- [ ] Filtering is performant even with large catalogs (using indexed SQL queries).
- [ ] Predicates are persisted in the database for Smart Albums.
