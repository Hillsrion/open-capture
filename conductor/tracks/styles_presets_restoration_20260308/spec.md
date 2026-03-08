# Specification: HDR Merge & Panorama Stitch Restoration (ENG-010)

## Overview
This track focuses on the reconstruction of Capture One's advanced multi-image processing tools: HDR Merge and Panorama Stitch. These features allow users to combine multiple RAW files into a single, high-fidelity 32-bit DNG file. HDR Merge combines exposure brackets to extend dynamic range, while Panorama Stitch combines overlapping images to create wide-angle or high-resolution compositions.

## Functional Requirements
- **HDR Merge Engine:**
    - **Alignment:** Reconstruct the logic to align images with slight camera movement using feature matching (OpenCV-based simulation).
    - **De-ghosting:** Implement logic to detect and remove moving subjects (ghosts) during the merge process.
    - **32-bit Merge:** Reconstruct the mathematical merge that combines multiple 14/16-bit RAWs into a linear 32-bit DNG buffer.
- **Panorama Stitch Engine:**
    - **Spherical/Cylindrical Projection:** Implement the warping logic discovered in `CreateWarper` for different panorama projections.
    - **Feature Stitching:** Reconstruct the logic to find matching keypoints across overlapping images.
    - **Exposure Compensation:** Implement the `CExposureCompensation` logic to blend exposures seamlessly across the stitch.
- **DNG Generation:**
    - **32-bit Float Output:** Reconstruct the DNG writer logic to produce valid linear DNG files with full metadata preservation.
- **UI Interaction:**
    - **Merge Dialogs:** Reconstruct the modal dialogs for HDR and Panorama settings (Alignment, Auto-Crop, Projection Type).
    - **Background Processing:** Ensure merges are performed as background tasks with a progress indicator.

## Non-Functional Requirements
- **High Memory Management:** Merging large RAW files (e.g., 100MP) requires efficient tile-based processing to avoid out-of-memory errors.
- **Precision:** The resulting DNG must maintain the original raw data's integrity while offering expanded bit depth.

## Acceptance Criteria
- Successful merge of multiple exposure brackets into a single DNG.
- Successful stitch of overlapping images into a seamless panorama.
- Resulting DNG files are readable by the ImageCore pipeline and show extended dynamic range or wider FOV.
- Metadata (EXIF/IPTC) from the primary image is correctly carried over to the merged result.

## Out of Scope
- Advanced AI-based content-aware fill for missing panorama areas.
- Video-based panorama generation.
