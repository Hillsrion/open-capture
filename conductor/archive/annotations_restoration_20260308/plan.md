# Implementation Plan: Annotations System Restoration

## Phase 1: Data Models & Persistence (ModelCore / AppCoreShared)
- [x] Task: Reconstruct `MCAnnotationsLine` and `MCAnnotationsNote` models. ad74fcd
- [x] Task: Reconstruct the `MCAnnotations` container. ad74fcd
- [x] Task: Integrate annotations storage into `VariantBase`. ad74fcd
- [x] Task: Commit Phase 1. ad74fcd

## Phase 2: Drawing Engine & Coordinates (CaptureOneUI)
- [x] Task: Implement the freehand drawing logic using `DragGesture`. a5707cb
- [x] Task: Implement coordinate mapping between viewer space and raw image space. a5707cb
- [x] Task: Reconstruct the `AnnotationsOverlayView` using SwiftUI `Canvas` or `Path`. a5707cb
- [x] Task: Commit Phase 2. 85b0c8c

## Phase 3: Text Notes & Interaction (CaptureOneUI)
- [x] Task: Implement the text note placement and editing UI. a5707cb
- [x] Task: Reconstruct the eraser logic for removing strokes/notes. a5707cb
- [x] Task: Implement toggles for "Display Annotations" and "Always Show". a5707cb
- [x] Task: Commit Phase 3. 4ebff03

## Phase 4: Integration & Validation (CaptureOneUI)
- [x] Task: Reconstruct `AnnotationsInspectorTool` in the sidebar. a5707cb
- [x] Task: Create a test case: draw stroke -> zoom in -> verify alignment -> save session -> verify persistence. a5707cb
- [x] Task: Commit Phase 4. a5707cb
