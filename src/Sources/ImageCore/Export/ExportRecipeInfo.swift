import Foundation

/// Protocol defining the necessary properties for an export recipe used in PSD rendering.
/// This allows decoupling ImageCore from the concrete OutputRecipe in AppCoreShared.
public protocol ExportRecipeInfo {
    var name: String { get }
    var includeAnnotations: Bool { get }
    var annotationsAsLayer: Bool { get }
}
