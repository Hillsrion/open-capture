# Capture One Feature Map (v16.5.9 Current State)

This document maps the evolution of Capture One features to their current functional state in version 16.5.9. It highlights what has been retired, consolidated, or replaced to guide the reconstruction of relevant logic.

## 1. Core Editing & Masking (Current)

### AI-Driven Masking (State-of-the-art)
- **Subject & Background Masking:** Replaces manual masking for common tasks.
- **AI Select Tool:** Instant masking of objects via click.
- **Match Look:** AI-powered style transfer (introduced in 16.5).
- **Status:** Active. These are the primary logic targets in `ImageProcessing` and `AppCoreShared`.

### Parametric & Layered Adjustments
- **Luma Range Masking (v12):** Still a core pillar, now fully integrated into the layer stack.
- **Layer Opacity (v11):** Universal control for almost all adjustment tools.
- **Status:** Active and Mature.

## 2. Organization & Workflow (Current)

### Catalog & Session Systems (Hybrid)
- **Catalogs (v7):** Centralized DAM logic (SQLite).
- **Sessions (Classic):** Decentralized, folder-based logic (Sidecar files).
- **Cull View (v23):** High-speed browsing interface for initial rating.
- **Status:** Active. These define the `MOCollection` and `DataCore` architecture.

### Tethering (Core Legacy)
- **Capture Pilot (v6):** Still active, providing wireless/iOS connectivity.
- **Wireless Tethering (v22):** Expanded to Canon/Sony.
- **Status:** Active. Primary logic in `P1CaptureCore` and `CameraCore`.

## 3. Retired or Replaced Functionality (To ignore or treat as legacy)

### UI Consolidation (v20 Changes)
- **The Batch Tab:** **REMOVED**. The Batch tool is now at the bottom of the Output tab. Logic for batching remains but the UI-to-Logic binding has moved.
- **Simplified Workspaces:** **CONSOLIDATED**. Multiple basic workspaces were merged into one.
- **Black & White Workspace:** **REMOVED** as a default. B&W tools are now part of the standard Color tab logic.

### Product Variants
- **Brand-Specific Versions (e.g., "for Fujifilm"):** **REMOVED**. The software is now a single unified "Pro" binary.
- **Capture One Express:** **REMOVED/DISABLED**. The free tier was killed in 2024.
- **Status:** The binary we are analyzing is the unified Pro/Studio version.

### Processing Engines
- **Legacy Engine Support:** Capture One maintains old "Engines" (Engine 9, 10, etc.) for compatibility with old edits. However, the **Engine 16.x** is the modern target.
- **Status:** Legacy code likely exists in `ImageCore` to support these old engines, but modern logic is the priority.

### Hardware Acceleration
- **OpenCL (Legacy):** While still present for Windows/Legacy Intel Macs, **Metal** is the primary acceleration path for modern macOS (arm64).
- **Status:** Focus on Metal-related symbols in reconstruction.

## 4. Modern Standards (New)
- **Content Credentials (C2PA):** New logic for image provenance (v16.5).
- **Cloud Settings:** Shift toward centralized configuration sync.
- **Apple ProRAW:** Specialized tone-mapping path for iPhone RAW files.
