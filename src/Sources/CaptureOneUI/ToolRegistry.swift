import SwiftUI
import AppCoreShared
import ImageCore

public enum ToolRuntimeSupport {
    case implemented
    case adapter
    case unavailable
}

public struct ToolRegistryContext {
    public let config: ToolConfiguration
    public let adjustmentController: AdjustmentToolController
    public let session: SessionBase
    public let recipeManager: OutputRecipeManager
    public let batchQueue: BatchQueue
    public let keywordCache: DocumentKeywordCache

    public init(
        config: ToolConfiguration,
        adjustmentController: AdjustmentToolController,
        session: SessionBase,
        recipeManager: OutputRecipeManager,
        batchQueue: BatchQueue,
        keywordCache: DocumentKeywordCache
    ) {
        self.config = config
        self.adjustmentController = adjustmentController
        self.session = session
        self.recipeManager = recipeManager
        self.batchQueue = batchQueue
        self.keywordCache = keywordCache
    }
}

public enum ToolRegistry {
    public static func support(for toolID: String) -> ToolRuntimeSupport {
        entry(for: toolID).support
    }

    public static func view(for toolID: String, context: ToolRegistryContext) -> AnyView {
        entry(for: toolID).build(context)
    }

    private static func entry(for toolID: String) -> ToolEntry {
        switch toolID {
        case "Library":
            return .implemented { context in AnyView(LibraryToolView(session: context.session)) }
        case "MetadataFilters":
            return .implemented { context in
                AnyView(FilterToolView(predicate: Binding(
                    get: { context.adjustmentController.activePredicate },
                    set: { context.adjustmentController.activePredicate = $0 }
                )))
            }
        case "Keywords":
            return .implemented { context in AnyView(KeywordsAssignmentToolView(context: context)) }
        case "KeywordLibrary":
            return .implemented { context in AnyView(KeywordInspectorTool(cache: context.keywordCache)) }
        case "Metadata":
            return .implemented { context in
                AnyView(MetadataInspectorView(image: context.adjustmentController.currentVariant?.image))
            }
        case "Camera":
            return .implemented { _ in AnyView(CameraSettingsTool()) }
        case "CameraSettings":
            return .implemented { _ in AnyView(CameraSettingsTool()) }
        case "NextCaptureNaming":
            return .implemented { _ in AnyView(NextCaptureNamingToolView()) }
        case "NextCaptureAdjustments":
            return .implemented { _ in AnyView(NextCaptureAdjustmentsToolView()) }
        case "NextCaptureLocation":
            return .implemented { context in AnyView(NextCaptureLocationToolView(config: context.config)) }
        case "NextCaptureMetadata":
            return .implemented { context in AnyView(NextCaptureMetadataToolView(config: context.config)) }
        case "NextCaptureKeywords":
            return .implemented { context in AnyView(NextCaptureKeywordsToolView(config: context.config)) }
        case "LivePreviewComposition":
            return .implemented { _ in AnyView(UnavailableToolView(toolID: "LivePreviewComposition")) }
        case "LivePreviewAdjustments":
            return .implemented { _ in AnyView(UnavailableToolView(toolID: "LivePreviewAdjustments")) }
        case "LivePreviewInfoTool":
            return .implemented { _ in AnyView(UnavailableToolView(toolID: "LivePreviewInfoTool")) }
        case "Normalize":
            return .implemented { _ in AnyView(NormalizeToolView()) }
        case "NextCaptureBackup":
            return .implemented { context in AnyView(NextCaptureBackupToolView(config: context.config)) }
        case "Overlay":
            return .implemented { _ in AnyView(OverlayToolView()) }
        case "LiveForStudio":
            return .implemented { _ in AnyView(LiveForStudioToolView()) }
        case "CameraFocus":
            return .implemented { context in AnyView(UnavailableToolView(toolID: "CameraFocus")) }
        case "ExposureEvaluation":
            return .implemented { context in AnyView(ExposureEvaluationToolView(adjustmentController: context.adjustmentController, config: context.config)) }
        case "Histogram":
            return .implemented { _ in AnyView(HistogramToolView()) }
        case "LocalAdjustments":
            return .implemented { context in AnyView(LocalAdjustmentsToolView(context: context)) }
        case "StyleBrushes":
            return .implemented { _ in AnyView(BrushSettingsToolView()) }
        case "MatchLook":
            return .implemented { _ in AnyView(MatchLookToolView()) }
        case "WhiteBalance":
            return .implemented { context in
                AnyView(WhiteBalanceToolView(
                    kelvin: Binding(
                        get: { context.adjustmentController.kelvin },
                        set: { context.adjustmentController.kelvin = $0 }
                    ),
                    tint: Binding(
                        get: { context.adjustmentController.tint },
                        set: { context.adjustmentController.tint = $0 }
                    )
                ))
            }
        case "Exposure":
            return .implemented { context in
                AnyView(ExposureToolView(
                    exposure: Binding(
                        get: { context.adjustmentController.exposure },
                        set: { context.adjustmentController.exposure = $0 }
                    ),
                    contrast: Binding(
                        get: { context.adjustmentController.contrast },
                        set: { context.adjustmentController.contrast = $0 }
                    ),
                    brightness: Binding(
                        get: { context.adjustmentController.brightness },
                        set: { context.adjustmentController.brightness = $0 }
                    ),
                    saturation: Binding(
                        get: { context.adjustmentController.saturation },
                        set: { context.adjustmentController.saturation = $0 }
                    )
                ))
            }
        case "ShadowHighlight":
            return .implemented { context in
                AnyView(HDRToolView(
                    highlights: Binding(
                        get: { context.adjustmentController.highlights },
                        set: { context.adjustmentController.highlights = $0 }
                    ),
                    shadows: Binding(
                        get: { context.adjustmentController.shadows },
                        set: { context.adjustmentController.shadows = $0 }
                    ),
                    whites: Binding(
                        get: { context.adjustmentController.whites },
                        set: { context.adjustmentController.whites = $0 }
                    ),
                    blacks: Binding(
                        get: { context.adjustmentController.blacks },
                        set: { context.adjustmentController.blacks = $0 }
                    )
                ))
            }
        case "Levels":
            return .implemented { context in AnyView(LevelsInspectorToolView(controller: context.adjustmentController)) }
        case "Curves":
            return .implemented { context in AnyView(CurvesInspectorToolView(controller: context.adjustmentController)) }
        case "SelectiveColorControl":
            return .implemented { context in AnyView(AdvancedColorEditorView(controller: context.adjustmentController)) }
        case "ColorBalance":
            return .implemented { context in AnyView(ColorBalanceToolView(controller: context.adjustmentController)) }
        case "BlackAndWhite":
            return .implemented { context in AnyView(BlackAndWhiteToolView(controller: context.adjustmentController)) }
        case "Clarity":
            return .implemented { context in
                AnyView(ClarityToolView(
                    amount: Binding(
                        get: { context.adjustmentController.clarityAmount },
                        set: { context.adjustmentController.clarityAmount = $0 }
                    ),
                    structure: Binding(
                        get: { context.adjustmentController.structureAmount },
                        set: { context.adjustmentController.structureAmount = $0 }
                    ),
                    method: Binding(
                        get: { context.adjustmentController.clarityMethod },
                        set: { context.adjustmentController.clarityMethod = $0 }
                    )
                ))
            }
        case "Dehaze":
            return .implemented { context in AnyView(DehazeToolView(controller: context.adjustmentController)) }
        case "Vignetting":
            return .implemented { context in AnyView(VignettingToolView(controller: context.adjustmentController)) }
        case "Crop":
            return .implemented { context in AnyView(CropToolView(controller: context.adjustmentController)) }
        case "AICrop":
            return .implemented { _ in AnyView(AICropToolView()) }
        case "Rotation":
            return .implemented { context in AnyView(RotationToolView(controller: context.adjustmentController)) }
        case "Perspective":
            return .implemented { context in
                AnyView(KeystoneToolView(
                    tiltX: Binding(get: { context.adjustmentController.keystoneTiltX }, set: { context.adjustmentController.keystoneTiltX = $0 }),
                    tiltY: Binding(get: { context.adjustmentController.keystoneTiltY }, set: { context.adjustmentController.keystoneTiltY = $0 }),
                    amount: Binding(get: { context.adjustmentController.keystoneAmount }, set: { context.adjustmentController.keystoneAmount = $0 }),
                    aspect: Binding(get: { context.adjustmentController.keystoneAspect }, set: { context.adjustmentController.keystoneAspect = $0 }),
                    skew: Binding(get: { context.adjustmentController.keystoneSkew }, set: { context.adjustmentController.keystoneSkew = $0 }),
                    focalLength: Binding(get: { context.adjustmentController.keystoneFocalLength }, set: { context.adjustmentController.keystoneFocalLength = $0 })
                ))
            }
        case "LensCorrection":
            return .implemented { context in
                AnyView(LensCorrectionToolView(
                    distortion: Binding(
                        get: { context.adjustmentController.lensDistortion },
                        set: { context.adjustmentController.lensDistortion = $0 }
                    ),
                    sharpnessFalloff: Binding(
                        get: { context.adjustmentController.lensSharpnessFalloff },
                        set: { context.adjustmentController.lensSharpnessFalloff = $0 }
                    ),
                    lightFalloff: Binding(
                        get: { context.adjustmentController.lensLightFalloff },
                        set: { context.adjustmentController.lensLightFalloff = $0 }
                    ),
                    shiftX: Binding(
                        get: { context.adjustmentController.lensShiftX },
                        set: { context.adjustmentController.lensShiftX = $0 }
                    ),
                    shiftY: Binding(
                        get: { context.adjustmentController.lensShiftY },
                        set: { context.adjustmentController.lensShiftY = $0 }
                    )
                ))
            }
        case "Grid":
            return .implemented { context in AnyView(GridToolView(controller: context.adjustmentController)) }
        case "Guides":
            return .implemented { context in AnyView(GuidesToolView(controller: context.adjustmentController)) }
        case "BaseCharacteristics":
            return .implemented { context in AnyView(BaseCharacteristicsToolView(config: context.config)) }
        case "Styles":
            return .implemented { context in AnyView(StyleInspectorTool(controller: context.adjustmentController)) }
        case "Settings":
            return .implemented { context in AnyView(SettingsToolView(config: context.config)) }
        case "Navigator":
            return .implemented { _ in AnyView(NavigatorToolView()) }
        case "Focus":
            return .implemented { _ in AnyView(FocusToolView()) }
        case "Sharpening":
            return .implemented { context in
                AnyView(SharpeningToolView(
                    amount: Binding(
                        get: { context.adjustmentController.sharpAmount },
                        set: { context.adjustmentController.sharpAmount = $0 }
                    ),
                    radius: Binding(
                        get: { context.adjustmentController.sharpRadius },
                        set: { context.adjustmentController.sharpRadius = $0 }
                    ),
                    threshold: Binding(
                        get: { context.adjustmentController.sharpThreshold },
                        set: { context.adjustmentController.sharpThreshold = $0 }
                    ),
                    halo: Binding(
                        get: { context.adjustmentController.sharpHalo },
                        set: { context.adjustmentController.sharpHalo = $0 }
                    )
                ))
            }
        case "Noise":
            return .implemented { context in
                AnyView(NoiseReductionToolView(
                    luminance: Binding(
                        get: { context.adjustmentController.nrLuminance },
                        set: { context.adjustmentController.nrLuminance = $0 }
                    ),
                    details: Binding(
                        get: { context.adjustmentController.nrDetails },
                        set: { context.adjustmentController.nrDetails = $0 }
                    ),
                    color: Binding(
                        get: { context.adjustmentController.nrColor },
                        set: { context.adjustmentController.nrColor = $0 }
                    ),
                    singlePixel: Binding(
                        get: { context.adjustmentController.nrSinglePixel },
                        set: { context.adjustmentController.nrSinglePixel = $0 }
                    )
                ))
            }
        case "Film Grain":
            return .implemented { context in AnyView(FilmGrainToolView(controller: context.adjustmentController)) }
        case "SpotRemoval":
            return .implemented { _ in AnyView(SpotRemovalToolView()) }
        case "LensColorCorrections":
            return .implemented { _ in AnyView(LensColorCorrectionsToolView()) }
        case "Moire":
            return .implemented { context in AnyView(MoireToolView(controller: context.adjustmentController)) }
        case "Annotations":
            return .implemented { context in
                if let variant = context.adjustmentController.currentVariant {
                    return AnyView(AnnotationsInspectorTool(variant: variant))
                }
                return AnyView(UnavailableToolView(toolID: "Annotations"))
            }
        case "SmartAdjustments":
            return .implemented { context in AnyView(SmartAdjustmentsToolView(controller: context.adjustmentController)) }
        case "ExportDialogRecipeList":
            return .implemented { context in AnyView(ExportRecipesToolView(recipeManager: context.recipeManager)) }
        case "ExportLocation":
            return .implemented { context in AnyView(ExportLocationToolView(recipeManager: context.recipeManager)) }
        case "ExportNaming":
            return .implemented { _ in AnyView(ExportNamingToolView()) }
        case "FormatAndSize":
            return .implemented { context in AnyView(ExportFormatToolView(recipeManager: context.recipeManager)) }
        case "OutputMetadata":
            return .implemented { _ in AnyView(ExportMetadataToolView()) }
        case "Watermark":
            return .implemented { _ in AnyView(ExportWatermarkToolView()) }
        case "ExportQueue":
            return .implemented { context in AnyView(ExportQueueToolView(batchQueue: context.batchQueue)) }
        case "OutputAdjustments", "ExportProcess", "OutputContentCredentials", "OutputCrossRecipeTokensInspectorTool":
            return .implemented { context in
                AnyView(UnavailableToolView(toolID: toolID))
            }
        case "ImporterFilters":
            return .implemented { context in AnyView(ImporterFiltersToolView(config: context.config)) }
        case "ImportFileInfo":
            return .implemented { context in AnyView(ImportFileInfoToolView(config: context.config)) }
        case "FaceFocus":
            return .implemented { context in AnyView(FaceFocusToolView(config: context.config)) }
        case "TimeBasedGrouping":
            return .implemented { context in AnyView(TimeBasedGroupingToolView(config: context.config)) }
        default:
            return .unavailable(toolID)
        }
    }
}

private struct ToolEntry {
    let support: ToolRuntimeSupport
    let build: (ToolRegistryContext) -> AnyView

    static func implemented(_ build: @escaping (ToolRegistryContext) -> AnyView) -> ToolEntry {
        ToolEntry(support: .implemented, build: build)
    }

    static func adapter(_ build: @escaping (ToolRegistryContext) -> AnyView) -> ToolEntry {
        ToolEntry(support: .adapter, build: build)
    }

    static func unavailable(_ toolID: String) -> ToolEntry {
        ToolEntry(support: .unavailable) { _ in
            AnyView(UnavailableToolView(toolID: toolID))
        }
    }
}

public struct UnavailableToolView: View {
    let toolID: String

    public init(toolID: String) {
        self.toolID = toolID
    }

    public var body: some View {
        COToolSection(toolID, toolID: toolID) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Restoration pending")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                Text("This tool is part of the decompiled workspace layout but does not have a dedicated SwiftUI implementation yet.")
                    .font(.system(size: 10))
                    .foregroundColor(CaptureOneTheme.Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
    }
}

private struct LevelsInspectorToolView: View {
    @ObservedObject var controller: AdjustmentToolController

    var body: some View {
        POLevelsControl(
            blackPoint: Binding(
                get: { controller.levelsBlackPoint },
                set: { controller.levelsBlackPoint = $0 }
            ),
            whitePoint: Binding(
                get: { controller.levelsWhitePoint },
                set: { controller.levelsWhitePoint = $0 }
            ),
            midtone: Binding(
                get: { controller.levelsMidtone },
                set: { controller.levelsMidtone = $0 }
            ),
            targetBlack: Binding(
                get: { controller.levelsTargetBlack },
                set: { controller.levelsTargetBlack = $0 }
            ),
            targetWhite: Binding(
                get: { controller.levelsTargetWhite },
                set: { controller.levelsTargetWhite = $0 }
            )
        )
    }
}

private struct CurvesInspectorToolView: View {
    @ObservedObject var controller: AdjustmentToolController

    var body: some View {
        POCurvesControl(points: Binding(
            get: { controller.curvesPoints },
            set: { controller.curvesPoints = $0 }
        ))
    }
}

private struct LocalAdjustmentsToolView: View {
    let context: ToolRegistryContext

    var body: some View {
        if let variant = context.adjustmentController.currentVariant {
            LayerInspectorView(variant: variant)
        } else {
            UnavailableToolView(toolID: "LocalAdjustments")
        }
    }
}
