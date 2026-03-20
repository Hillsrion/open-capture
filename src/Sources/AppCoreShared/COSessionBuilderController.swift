import Foundation
import Combine

/// Controller responsible for managing the session creation state and logic.
public class COSessionBuilderController: ObservableObject {
    
    public enum CreationMode: Int {
        case manual = 0
        case automated = 1
    }
    
    @Published public var sessionName: String = "Untitled Session"
    @Published public var location: URL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
    @Published public var mode: CreationMode = .manual
    
    // Manual Mode
    @Published public var captureFolder: String = "Capture"
    @Published public var selectsFolder: String = "Selects"
    @Published public var outputFolder: String = "Output"
    @Published public var trashFolder: String = "Trash"
    
    // Automated Mode
    @Published public var automatedList: String = "Capture, Selects, Output, Trash"
    
    private let templateService = COFolderTemplateService()
    private let scaffolder = COFileSystemScaffolder()
    private let evaluator = TokenEvaluator()
    
    public init() {}
    
    public var previewPaths: [String] {
        let list = templateService.parseDelimitedList(automatedList)
        let expanded = templateService.expandHierarchy(list)
        let context = TokenEvaluator.Context(imageName: "Image", date: Date(), sequence: 1, jobName: sessionName)
        return templateService.evaluatePaths(expanded, evaluator: evaluator, context: context)
    }
    
    public func createSession() throws -> URL {
        let finalSubfolders: [String]
        let context = TokenEvaluator.Context(imageName: "Image", date: Date(), sequence: 1, jobName: sessionName)
        
        switch mode {
        case .manual:
            let manualPaths = [captureFolder, selectsFolder, outputFolder, trashFolder]
            finalSubfolders = templateService.evaluatePaths(manualPaths, evaluator: evaluator, context: context)
        case .automated:
            let list = templateService.parseDelimitedList(automatedList)
            let expanded = templateService.expandHierarchy(list)
            finalSubfolders = templateService.evaluatePaths(expanded, evaluator: evaluator, context: context)
        }
        
        return try scaffolder.createSessionScaffold(at: location, sessionName: sessionName, subfolders: finalSubfolders)
    }
}
