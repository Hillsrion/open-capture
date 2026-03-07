import Foundation
import ImageCore

/// Represents a single export operation in the queue.
/// Based on _TtC12AppCoreShared8BatchJob metadata.
public class BatchJob: BaseObject, Identifiable {
    public let variant: VariantBase
    public let recipe: OutputRecipe
    public let destinationPath: String
    
    public enum Status: Int {
        case pending = 0
        case processing = 1
        case completed = 2
        case failed = 3
    }
    
    @Published public var status: Status = .pending
    @Published public var progress: Double = 0.0
    
    public init(variant: VariantBase, recipe: OutputRecipe, destinationPath: String, context: ObjectContext) {
        self.variant = variant
        self.recipe = recipe
        self.destinationPath = destinationPath
        super.init()
    }
}

/// Manages the queue of BatchJobs.
/// Based on _TtC12AppCoreShared10BatchQueue.
public class BatchQueue: ObservableObject {
    @Published public var pendingJobs: [BatchJob] = []
    @Published public var completedJobs: [BatchJob] = []
    @Published public var activeJob: BatchJob?
    
    private let namingService = ExportNaming()
    private let translator = ExportTranslator()
    private let pipeline = ImageCorePipeline()
    
    public init() {}
    
    public func addJob(variant: VariantBase, recipe: OutputRecipe, outputFolder: URL) {
        // Evaluate naming
        let fileName = namingService.evaluate(format: recipe.fileNameTokens, for: variant)
        let formatExt = recipe.format.rawValue.lowercased()
        let fullPath = outputFolder.appendingPathComponent("\(fileName).\(formatExt)").path
        
        let job = BatchJob(variant: variant, recipe: recipe, destinationPath: fullPath, context: ObjectContext())
        pendingJobs.append(job)
        
        // Auto-start if not busy
        if activeJob == nil {
            processNext()
        }
    }
    
    private func processNext() {
        guard !pendingJobs.isEmpty else {
            activeJob = nil
            return
        }
        
        let job = pendingJobs.removeFirst()
        activeJob = job
        job.status = .processing
        
        // Use Translator
        let (pSettings, eSettings) = translator.translate(variant: job.variant, recipe: job.recipe)
        
        // Use Pipeline
        DispatchQueue.global().async {
            // Setup RawImageRep for the variant
            let size = CGSize(width: 1000, height: 1000) // Placeholder for real sensor size
            let rep = RawImageRep(model: "Generic Sensor", size: size)
            
            self.pipeline.processToFile(input: rep, settings: pSettings, exportSettings: eSettings, destination: job.destinationPath)
            
            DispatchQueue.main.async {
                job.status = .completed
                self.completedJobs.append(job)
                self.processNext()
            }
        }
    }
}
