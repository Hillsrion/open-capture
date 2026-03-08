# Specification: Hierarchical Keywords Restoration (CORE-005)

## Overview
This track focuses on the reconstruction of Capture One's hierarchical keyword management system. Keywords are stored in a centralized library and can be organized into a tree structure. Each variant can reference multiple keywords from this library. The reconstruction will include the data models, database mapping, and the UI for managing the keyword taxonomy.

## Functional Requirements
- **Keyword Data Model:** Reconstruct `MCMetadataKeywordLibraryEntry` with `UUID` and `name`.
- **Hierarchy Logic:** Implement a tree structure where each keyword can have a `parent` keyword.
- **Database Mapping:** Map the `ZKEYWORD` table in `DataCore`, including columns for `ZNAME`, `ZPARENT`, and `ZUUID`.
- **Keyword Cache:** Reconstruct `DocumentKeywordCache` to manage in-memory keyword state for a session.
- **Variant Binding:** Allow `VariantBase` to associate with multiple keywords via a join table or serialized list (based on `MCAdjLayerKeyMetadataContentKeywords`).
- **UI Interaction:** Reconstruct the Keyword library inspector with a hierarchical list view.

## Non-Functional Requirements
- **Efficiency:** Keyword lookups and hierarchy traversals must be performant for large libraries (1000+ keywords).
- **Persistence:** Keyword associations must be correctly persisted and synchronized with XMP sidecars (as planned in `CORE-002`).

## Acceptance Criteria
- Ability to create, nested, and delete keywords in the centralized library.
- Successful assignment of hierarchical keywords to images.
- Keywords are correctly persisted in the SQLite database.
- Keyword changes trigger updates in the UI and metadata sync logic.

## Out of Scope
- IPTC/EXIF standard metadata fields (handled in separate metadata tracks).
- AI-based auto-keyword tagging.
