# Capture One Reconstruction Backlog

This backlog tracks all features and modules required to reach a 100% high-fidelity reconstruction of Capture One Pro (v16.5).

---

## 🟢 1. Core Data & Management (AppCoreShared / DataCore)
*Status: ~75% Complete*

| Task ID | Feature | Priority | Complexity | Status |
| :--- | :--- | :--- | :--- | :--- |
| CORE-001 | **Smart Albums & Advanced Filters** (SQL for ratings, tags, EXIF) | High | Med | ✅ Done |
| CORE-002 | **Metadata Sync** (XMP Sidecar support, EXIF/IPTC) | Med | Med | ✅ Done |
| CORE-003 | **Variant Cloning** (Logic for creating new variants) | High | Low | ✅ Done |
| CORE-004 | **Session/Catalog Switching** (Hot-swapping databases) | High | Med | ✅ Done |
| CORE-005 | **Hierarchical Keywords** (Taxonomy tree management) | Med | High | ✅ Done |
| CORE-006 | **EIP Packaging** (Zipping RAW + adjustments into .eip) | Low | Med | ⏳ Pending |
| CORE-007 | **Import Engine** (Card ingest, renaming, backup, apply styles) | High | High | ✅ Done |
| CORE-008 | **Session Folders Logic** (Capture, Selects, Output, Trash routing) | High | Low | ✅ Done |
| CORE-009 | **Rating & Color Tagging** (Stars and Color labels data models) | High | Low | ✅ Done |

---

## 🟡 2. Image Processing Engine (ImageCore / Metal)
*Status: ~25% Complete*

| Task ID | Feature | Priority | Complexity | Status |
| :--- | :--- | :--- | :--- | :--- |
| ENG-001 | **Bipolar Adjustments** (Exposure, Contrast kernels) | High | Low | ✅ Done |
| ENG-002 | **Levels & Curves Math** (Spline interpolation kernels) | High | High | ✅ Done |
| ENG-003 | **Clarity & Structure** (Classic, Punch, Natural algorithms) | High | High | ✅ Done |
| ENG-004 | **Advanced Color Editor & Skin Tone** (Hue/Sat masking) | High | Very High | ✅ Done |
| ENG-005 | **Layer Blending Engine** (Alpha masking & composition) | High | Very High | ✅ Done |
| ENG-006 | **Lens Correction** (Distortion, CA, Light Falloff, LCC) | Med | High | ✅ Done |
| ENG-007 | **Noise Reduction & Sharpening** (Luma, Color, Halo) | Med | High | ✅ Done |
| ENG-008 | **Film Grain Generator** (Procedural GPU noise) | Low | Med | ✅ Done |
| ENG-009 | **Export Engine** (Process Recipes, Watermarks, Resizing) | High | High | ✅ Done |
| ENG-010 | **HDR Merge & Panorama Stitch** (32-bit DNG generation) | Low | Very High | ✅ Done |
| ENG-011 | **Soft Proofing Engine** (ICC profile simulation for print/web) | Med | High | ⏳ Pending |

---

## 🟣 3. Smart & AI Features (ModelCore / OpenCV)
*Status: 0% Complete*

| Task ID | Feature | Priority | Complexity | Status |
| :--- | :--- | :--- | :--- | :--- |
| AI-001 | **Magic Brush / Eraser** (Luma/Color tolerance masking) | Med | High | ✅ Done |
| AI-002 | **Smart Adjustments** (Face-based Expo/WB matching) | Med | Very High | ⏳ Pending |
| AI-003 | **Auto Keystone** (Perspective correction via OpenCV) | Med | High | ⏳ Pending |

---

## 📷 4. Tethering & Capture (P1CaptureCore)
*Status: 0% Complete*

| Task ID | Feature | Priority | Complexity | Status |
| :--- | :--- | :--- | :--- | :--- |
| TETH-001 | **Camera Control API** (PTP/MTP protocol integration) | High | Very High | ⏳ Pending |
| TETH-002 | **Live View Engine** (Real-time video feed & overlay) | High | High | ⏳ Pending |
| TETH-003 | **Next Capture Naming & Adjustments** (Auto-apply) | Med | Med | ⏳ Pending |
| TETH-004 | **Focus Mask** (Real-time sharpness overlay) | Med | High | ⏳ Pending |

---

## 🔵 5. User Interface (CaptureOneUI)
*Status: ~25% Complete*

| Task ID | Feature | Priority | Complexity | Status |
| :--- | :--- | :--- | :--- | :--- |
| UI-001 | **High-Fidelity Sliders** (Thin track, bipolar mode) | High | Low | ✅ Done |
| UI-002 | **Curves Interactive Widget** (Bezier point editor) | High | High | ✅ Done |
| UI-003 | **Color Wheels UI** (360° color picker interface) | Med | High | ✅ Done |
| UI-004 | **Layer Inspector** (Layer stack, opacity, visibility) | High | Med | ✅ Done |
| UI-005 | **Grid View Browser** (Lazy loading, resizable thumbnails, list view) | High | High | ✅ Done |
| UI-006 | **Heal / Clone Brush Tools** (Source point selection UI) | Med | High | ✅ Done |
| UI-007 | **Annotations View** (Drawing layer on top of viewer) | Low | Med | ✅ Done |
| UI-008 | **Import Dialog** (Source selection, naming format, backup) | High | Med | ✅ Done |
| UI-009 | **Rating & Tagging Overlays** (Stars/Colors on thumbnails) | High | Low | ✅ Done |
| UI-010 | **Styles & Presets Browser** (Live preview on hover, brush styles) | High | Med | ✅ Done |
| UI-011 | **Dynamic Tokens System** (Drag-and-drop naming tags) | High | High | ✅ Done |
| UI-012 | **Print Layout Window** (Margins, multi-image grids) | Low | High | ⏳ Pending |
| UI-013 | **Workspace Manager** (Save/Load panel states, dual monitor) | Med | High | ⏳ Pending |

---

## 🔴 6. Integration & Ecosystem
*Status: ~10% Complete*

| Task ID | Feature | Priority | Complexity | Status |
| :--- | :--- | :--- | :--- | :--- |
| INT-001 | **Toolbar & Customization** (Drag & drop tool icons) | Med | Med | ⏳ Pending |
| INT-002 | **Keyboard Shortcuts System** (C1 legacy shortcuts map) | High | Low | ✅ Done |
| INT-003 | **Plugin Host Architecture** (PluginCore bridging) | Low | High | ⏳ Pending |
| INT-004 | **AppleScript Automation** (Scripting dictionary, batch jobs) | Low | High | ⏳ Pending |
| INT-005 | **Hardware Controllers** (Tangent, Loupedeck API mappings) | Low | High | ⏳ Pending |

---

## 🚀 Active Focus
Selecting next priority track from the backlog...