import Foundation
import Combine
import AppCoreShared

/// Reconstructed main controller for the multi-pane import workflow (AI-005).
/// Coordinates scanning, grouping, and final ingestion.
public class COImportViewController: ObservableObject {
    
    @Published public var importer = POImporter()
    @Published public var groupingAI = COImageGroupingAI()
    
    /// The 4 main panes as requested: Source, Destination, Naming, Options.
    public enum ImportPane {
        case source
        case destination
        case naming
        case options
    }
    
    @Published public var activePane: ImportPane = .source
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        // Observe changes to discovered URLs to trigger initial grouping.
        importer.$discoveredURLs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] urls in
                self?.groupingAI.performGrouping(urls: urls)
            }
            .store(in: &cancellables)
            
        // Observe similarity changes to re-run grouping.
        groupingAI.$similarityThreshold
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.groupingAI.performGrouping(urls: self.importer.discoveredURLs)
            }
            .store(in: &cancellables)
    }
    
    public func togglePick(for url: URL) {
        importer.pickedState.togglePicked(for: url)
    }
    
    public func pickAll() {
        importer.pickedState.selectAll(importer.discoveredURLs)
    }
    
    public func unpickAll() {
        importer.pickedState.clear()
    }
    
    public func startImport() {
        importer.startImport()
    }
    
    public func scanSource(url: URL) {
        importer.scanSource(url: url)
    }
}
