# Capture One UI Component Architecture

This document provides a highly detailed, component-level schema of the Capture One user interface, reconstructed from exhaustive visual analysis of 58 official tutorials (versions 15, 16, 17). It serves as the definitive reference for SwiftUI/AppKit implementation.

---

## 1. Main Window (`COMainWindowView`)
The primary interface is a split-view containing the Top Toolbar, the Central Viewer, the Filmstrip, and the Tool Tab Bar.

### 1.1. Top Toolbar (`COMainToolbar`)
*Layout: Horizontal Stack (`HStack`)*

#### Left Group (Global Actions)
- `[Button]` **Import**: Opens `ImportDialog`.
- `[Button]` **Export**: Focuses `ExportToolTab` or executes Quick Export.
- `[Button]` **Cull**: Bascules UI to `CullingWindowController`.
- `[Button]` **Share online**: Opens `LiveSessionPopover`.

#### Center-Left Group (Workflow)
- `[Button]` **Reset** (Curved arrow icon). *State*: Disabled if no edits.
  - *Long Press*: Menu -> Reset Global, Reset excluding Composition.
- `[Button]` **Undo** (Left arrow). *Shortcut*: Cmd+Z.
- `[Button]` **Redo** (Right arrow). *Shortcut*: Cmd+Shift+Z.
- `[Button]` **Auto Adjust** (Magic wand / 'A').
  - *Long Press*: Opens `AutoAdjustSettingsPopover` (Checkboxes: WB, Exposure, HDR, Levels).

#### Center Group (Cursor Tools)
*Implementation*: `NSPopUpButton` or custom dropdown. Active tool highlights in orange.
- `[Dropdown]` **Select / Pan / Loupe**:
  - `Select` (V)
  - `Pan` (H): Hand icon.
  - `Loupe` (P)
- `[Dropdown]` **Crop / Rotate**:
  - `Crop` (C)
  - `Rotate` (R)
  - `Straighten`
  - `Keystone` -> Vertical, Horizontal, All
- `[Dropdown]` **Retouch**:
  - `Heal Brush` (Q)
  - `Clone Brush` (S)
- `[Dropdown]` **Masking**:
  - `Draw Mask` (B)
  - `Erase Mask` (E)
  - `Linear Gradient` (G)
  - `Radial Gradient` (T)
  - `Magic Brush`
  - `Magic Eraser`
- `[Dropdown]` **Annotations**:
  - `Annotations` (J)
  - `Erase Annotations`

#### Right Group (Toggles & Sync)
- `[Dropdown]` **Before / After** (Y): Overlapping squares icon.
  - Options: `Full View`, `Split Screen Slider`.
- `[Toggle]` **Grid**: Shows/hides composition grid.
- `[Toggle]` **Exposure Warnings**: Orange triangle icon. Overlays red/blue for clipping.
- `[Button]` **Copy** (Up arrow): Copies active variant's adjustments to clipboard.
- `[Button]` **Apply** (Down arrow): Pastes clipboard to selected variants.

---

### 1.2. Tool Tab Bar (`InspectorToolTabView`)
*Layout: `NSTabView` containing `NSScrollView`s. Tool panels are stacked vertically via `VStack`.*

#### 📁 LIBRARY TAB (`LibraryToolTab`)
- **Folders Tool**
  - `[Header]` "Folders" + `[...]` (Menu: Show in Finder, Set as Capture Folder).
  - `[OutlineView]` OS directory tree.
- **Session Folders Tool**
  - `[List]` 4 fixed items with icons: `Capture`, `Selects`, `Output`, `Trash`.
- **Session Favorites Tool**
  - `[List]` User-added folders.
  - `[Button]` `+` (Opens file picker to add folder).
- **Filters Tool**
  - `[SearchField]`
  - `[Accordion]` Rating (Stars 1-5 + Badge count).
  - `[Accordion]` Color Tag (Red, Yellow, Green, etc. + Badge count).
- **Batch Rename Tool**
  - `[Dropdown]` Method: `Text and Tokens`, `Find and Replace`.
  - `[TextField]` Format (with `[...]` button for Token selector modal).
  - `[Button]` Rename (Orange).

#### 📷 CAPTURE TAB (`CaptureToolTab`)
- **Camera Tool**
  - `[Button]` Live View (Video camera icon).
  - `[Label]` Connection Status (Green dot if connected).
  - `[ProgressBar]` Battery level.
- **Camera Settings Tool**
  - `[Dropdown]` Format (RAW, JPEG).
  - `[Dropdown]` Shutter Speed.
  - `[Dropdown]` Aperture.
  - `[Dropdown]` ISO.
  - `[Dropdown]` Exposure Comp.
  - `[Button]` AF.
- **Next Capture Adjustments Tool**
  - `[Dropdown]` All Other (`Copy from Last`, `Copy from Primary`, `Defaults`).
  - `[Dropdown]` ICC Profile.
  - `[Dropdown]` Style.
- **Capture One Live Tool**
  - `[TextField]` Session Name.
  - `[Dropdown]` Duration (24h, 1 week, 1 month).
  - `[Button]` Copy Link.

#### 🎨 COLOR TAB (`ColorToolTab`)
- **Base Characteristics Tool**
  - `[Dropdown]` ICC Profile (e.g., ProStandard).
  - `[Dropdown]` Curve (Auto, Film Standard, Linear).
- **White Balance Tool**
  - `[Dropdown]` Mode (Custom, Shot, Daylight...).
  - `[Button]` Pick White Balance (Pipette).
  - `[Slider]` Kelvin (2000 - 10000).
  - `[Slider]` Tint (-50 to +50).
- **Color Editor Tool**
  - `[Tabs]` Basic | Advanced | Skin Tone
  - *Basic*: 8 `[Color Patches]`, `[Pipette]` Direct Color Editor, `[Sliders]` Hue/Sat/Lightness.
  - *Advanced*: `[Color Wheel]` with draggable handles, `[List]` of up to 25 selections.
  - *Skin Tone*: `[Pipette]`, **Uniformity** `[Sliders]` (Hue/Sat/Light), **Amount** `[Sliders]` (Hue/Sat/Light).
- **Color Balance Tool**
  - `[Tabs]` Master | Shadows | Midtones | Highlights.
  - `[Color Wheel]` 2D hue/saturation picker.
  - `[Slider]` Luminance (Vertical, left side).
- **Black & White Tool**
  - `[Checkbox]` Enable Black & White.
  - `[Sliders]` 6 color channels (Red, Yellow, Green, Cyan, Blue, Magenta).
  - `[Section]` Split Toning -> `[Sliders]` Hue/Sat for Highlights & Shadows.

#### ☀️ EXPOSURE TAB (`ExposureToolTab`)
- **Layers Tool**
  - `[Header]` `[+]` (New Layer dropdown), `[-]` (Delete), `[Refine Mask]` (Brush icon), `[Combine Masks]` (Intersection icon), `[Luma Range]`.
  - `[TableView]` Layer stack. Columns: Type Icon, Name TextField, Visibility Checkbox.
  - `[Slider]` Opacity (0-100) for selected layer.
- **Smart Adjustments Tool**
  - `[Thumbnail]` Reference Image.
  - `[Button]` Set as Reference.
  - `[Checkbox]` Exposure, `[Checkbox]` White Balance.
  - `[Button]` Apply.
- **Exposure Tool**
  - `[Button]` Auto (A).
  - `[Sliders]` Exposure (-4 to +4), Contrast, Brightness, Saturation.
- **High Dynamic Range Tool**
  - `[Sliders]` Highlight, Shadow, White, Black.
- **Levels Tool**
  - `[Tabs]` RGB | R | G | B.
  - `[Histogram]`.
  - `[Handles]` Input: Black, Mid-point, White. Output: Black, White.
- **Curves Tool**
  - `[Tabs]` RGB | Luma | R | G | B.
  - `[Graph]` Spline editor with draggable points.
- **Clarity Tool**
  - `[Dropdown]` Method (Natural, Punch, Neutral, Classic).
  - `[Sliders]` Clarity, Structure.

#### 📐 SHAPE TAB (`ShapeToolTab`)
- **Lens Correction Tool**
  - `[Dropdown]` Profile (Generic, Specific Lens).
  - `[Sliders]` Distortion, Sharpness Falloff, Light Falloff.
- **Crop Tool**
  - `[Dropdown]` Ratio (Unconstrained, 16:9, etc.).
  - `[Dropdown]` Grid (Rule of Thirds).
  - `[Button]` Invert.
- **AI Crop Tool** (Studio)
  - `[Tabs]` Subject | Face | Auto.
  - `[Dropdown]` Constraints (Fixed, Flexible).
  - `[TextFields]` Margins (Top, Bottom, Left, Right).
  - `[Grid]` 3x3 Alignment selector.
- **Keystone Tool**
  - `[SegmentedControl]` Vertical, Horizontal, All.
  - `[Sliders]` Amount, Aspect.
  - `[Button]` Auto (A) / Apply.
- **Vignetting Tool**
  - `[Dropdown]` Method (Circular, Elliptic).
  - `[Slider]` Amount (-100 to +100).

#### 🔍 DETAILS TAB (`DetailsToolTab`)
- **Focus Tool**
  - `[Canvas]` 100/200% Preview Area.
  - `[Dropdown]` Zoom Level.
  - `[Button]` Pick Focus Point.
- **Sharpening Tool**
  - `[Sliders]` Amount, Radius, Threshold, Halo Suppression.
- **Noise Reduction Tool**
  - `[Sliders]` Luminance, Detail, Color, Single Pixel.
- **Film Grain Tool**
  - `[Dropdown]` Type (Silver Rich, Cubic, etc.).
  - `[Sliders]` Impact, Granularity.

#### 📤 EXPORT TAB (`ExportToolTab`)
- **Export Recipes Tool**
  - `[TableView]` Recipe list. *State*: Checkbox toggles export inclusion. Clicking text turns it **Orange** (Active for editing below).
  - `[Buttons]` `+` / `-`.
- **Export Location Tool**
  - `[Dropdown]` Destination.
  - `[TextField]` Sub Folder (supports Tokens).
  - `[Text]` Sample Path output.
- **Export Naming Tool**
  - `[TextField]` Format (with Token button).
- **Export Format & Size Tool**
  - `[Dropdown]` Format (JPEG, TIFF).
  - `[Slider]` Quality.
  - `[Dropdown]` ICC Profile.
  - `[Dropdown]` Scale.
- **Export Metadata Tool**
  - `[Checkboxes]` Copyright, GPS, Camera Data.
  - `[Checkbox]` Annotations as a Layer (for PSD).
- **Summary Footer**
  - `[Text]` "Exporting X images".
  - `[Button]` Export (Orange).
  - `[Button]` Show in Finder (Folder icon).

---

## 2. MODAL & FLOATING WORKSPACES

### 2.1. Cull View (`COCullWindow`)
*Fullscreen overlay for rapid selection.*
- **Top Bar**:
  - `[Dropdown]` Zoom Level (100%, 200%).
  - `[Dropdown]` Face Focus (Eyes, Face).
  - `[Canvas]` Face Focus preview.
- **Center**:
  - Main high-res Viewer.
- **Right Sidebar (Group Overview)**:
  - `[Toggle]` Enable Groups.
  - `[Slider]` Similarity Threshold.
  - `[ScrollView]` Vertical thumbnails of groups.
- **Bottom Bar (Filmstrip)**:
  - `[ScrollView]` Horizontal thumbnails of images in current group.
  - `[Badges]` Stars (1-5), Color tags.

### 2.2. Import Window (`COImportWindow`)
- **Left Sidebar**:
  - `[OutlineView]` Source disks/folders.
  - `[Checkbox]` Include Subfolders.
- **Center**:
  - `[Grid]` Image thumbnails with selection checkboxes.
  - `[Button]` Pick All, Unpick All.
- **Right Sidebar**:
  - `[Dropdown]` Destination (Catalog vs Folder).
  - `[TextField]` Format Naming (Tokens).
  - `[Dropdown]` Apply Styles.
- **Bottom Right**:
  - `[Button]` Import All (Orange).

### 2.3. Luma Range Modal (`COLumaRangePopover`)
- **Range Slider**:
  - Gradient bar (Black to White).
  - 4 `[Draggable Handles]`: Shadow Falloff, Shadow Limit, Highlight Limit, Highlight Falloff.
- **Controls**:
  - `[Slider]` Radius.
  - `[Slider]` Sensitivity.
  - `[Checkbox]` Display Mask.
  - `[Button]` Apply.

### 2.4. Combine Masks Modal (`COCombineMasksWindow`)
- `[TableView]` List of active layers with checkboxes.
- `[Dropdown]` Operation (And, Or, Subtract).
- `[Checkbox]` Create new layer.
- `[Button]` Combine.

---

## 3. GLOBAL UI STATES & LOGIC

- **Orange Highlight**: The universal accent color denoting the *currently active* item being edited (e.g., active layer, active export recipe).
- **Floating Tools**: Any tool in the Tab Bar can be dragged by its header to detach into a floating `NSWindow`.
- **Keyboard Speed Edit**: Holding a bound key (e.g., Q for Exposure) + scrolling the mouse adjusts the parameter globally without focusing the UI slider.
- **Vector Overlays**: Linear Gradient, Radial Gradient, and Keystone tools draw resolution-independent vector lines directly onto the Central Viewer canvas when active.