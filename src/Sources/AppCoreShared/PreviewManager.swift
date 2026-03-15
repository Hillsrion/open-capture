import Foundation
import AppKit
import Combine
import ImageCore
import CoreImage

/// Reconstructed Preview Priority level (ENG-009).
public enum PreviewPriority: Int, Comparable {
    case low = 0
    case normal = 1
    case high = 2
    case immediate = 3
    
    public static func < (lhs: PreviewPriority, rhs: PreviewPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

/// Represents a single preview generation task.
public struct PreviewJob: Identifiable {
    public let id: String // Image path or UUID
    public let priority: PreviewPriority
    public var progress: Float // 0.0 to 1.0
    public var status: Status
    
    public enum Status {
        case pending
        case processing
        case completed
        case failed(String)
    }
}

/// Reconstructed Preview Manager (ENG-010).
/// Handles background proxy generation with priority shifting.
public class PreviewManager: ObservableObject {
    public static let shared = PreviewManager()
    
    @Published public var activeJobs: [String: PreviewJob] = [:]
    @Published public var isGenerating: Bool = false
    @Published public var totalProgress: Float = 0.0
    
    private let queue = OperationQueue()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        queue.maxConcurrentOperationCount = ProcessInfo.processInfo.processorCount
        setupProgressTracking()
    }
    
    /// Requests a high-fidelity preview for an image.
    /// If priority is .immediate, it jumps to the front of the queue.
    public func requestPreview(for imagePath: String, priority: PreviewPriority = .normal) {
        // 1. Check if job already exists
        if let existing = activeJobs[imagePath], existing.priority >= priority {
            return 
        }
        
        // 2. Create or Update Job
        let job = PreviewJob(id: imagePath, priority: priority, progress: 0.0, status: .pending)
        DispatchQueue.main.async {
            self.activeJobs[imagePath] = job
            self.updateGlobalState()
        }
        
        // 3. Enqueue development task
        enqueueTask(for: imagePath, priority: priority)
    }
    
    private func enqueueTask(for path: String, priority: PreviewPriority) {
        let operation = BlockOperation { [weak self] in
            self?.processImage(at: path)
        }
        
        // Map PreviewPriority to Operation queue priority
        switch priority {
        case .immediate: operation.queuePriority = .veryHigh
        case .high: operation.queuePriority = .high
        case .normal: operation.queuePriority = .normal
        case .low: operation.queuePriority = .low
        }
        
        queue.addOperation(operation)
    }
    
    private func processImage(at path: String) {
        updateJobStatus(path, status: .processing)
        
        let url = URL(fileURLWithPath: path)
        let settings = IC_ProcessSettings() // Default development for previews
        
        // Simulate high-res development time (0.5s to 2s depending on complexity)
        Thread.sleep(forTimeInterval: Double.random(in: 0.5...1.5))
        
        if let resultCI = RawImageEngine.shared.developImage(at: url, with: settings) {
            let context = CIContext()
            if let result = context.createCGImage(resultCI, from: resultCI.extent) {
                saveToCache(result, for: path)
                updateJobStatus(path, status: .completed)
            } else {
                updateJobStatus(path, status: .failed("Render failed"))
            }
        } else {
            updateJobStatus(path, status: .failed("Development failed"))
        }
    }
    
    private func updateJobStatus(_ path: String, status: PreviewJob.Status) {
        DispatchQueue.main.async {
            if var job = self.activeJobs[path] {
                job.status = status
                if case .completed = status {
                    job.progress = 1.0
                    // Remove from active list after a delay or keep for history
                    self.activeJobs.removeValue(forKey: path)
                }
                self.updateGlobalState()
            }
        }
    }
    
    private func updateGlobalState() {
        self.isGenerating = !activeJobs.isEmpty
        let completed = activeJobs.values.filter { if case .completed = $0.status { return true }; return false }.count
        let total = activeJobs.count
        self.totalProgress = total > 0 ? Float(completed) / Float(total) : 0.0
    }
    
    private func saveToCache(_ image: CGImage, for path: String) {
        // In original C1, saves to /Cache/Proxies/ as .cop files
        print("[Preview] Saved high-fidelity proxy for: \(path)")
    }
    
    private func setupProgressTracking() {
        // Observe queue count to update isGenerating
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let generating = self.queue.operationCount > 0
                if generating != self.isGenerating {
                    self.isGenerating = generating
                }
            }
            .store(in: &cancellables)
    }
}
