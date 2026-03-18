import SwiftUI
import AppCoreShared
import Foundation

/// Reconstructed hierarchical file system node for System Folders.
public class FileSystemNode: ObservableObject, Identifiable {
    public let id: String
    public let path: String
    public let name: String
    
    @Published public var children: [FileSystemNode]? = nil
    @Published public var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                loadChildren()
                startMonitoring()
            } else {
                stopMonitoring()
            }
        }
    }
    
    public var isLoaded: Bool { children != nil }
    
    private var fileDescriptor: CInt = -1
    private var source: DispatchSourceFileSystemObject?
    
    public init(path: String) {
        self.id = path
        self.path = path
        self.name = (path as NSString).lastPathComponent
    }
    
    deinit {
        stopMonitoring()
    }
    
    public func loadChildren() {
        guard !isLoaded else { return }
        reloadChildren()
    }
    
    private func reloadChildren() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                let fileManager = FileManager.default
                let contents = try fileManager.contentsOfDirectory(atPath: self.path)
                
                var newPaths = Set<String>()
                for item in contents {
                    let fullPath = (self.path as NSString).appendingPathComponent(item)
                    var isDir: ObjCBool = false
                    if fileManager.fileExists(atPath: fullPath, isDirectory: &isDir), isDir.boolValue {
                        // Ignore hidden folders
                        if !item.hasPrefix(".") {
                            newPaths.insert(fullPath)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    var currentChildren = self.children ?? []
                    
                    // Remove children that no longer exist
                    currentChildren.removeAll { !newPaths.contains($0.path) }
                    
                    // Find children that need to be added
                    let existingPaths = Set(currentChildren.map { $0.path })
                    let pathsToAdd = newPaths.subtracting(existingPaths)
                    
                    for pathToAdd in pathsToAdd {
                        currentChildren.append(FileSystemNode(path: pathToAdd))
                    }
                    
                    // Sort children
                    currentChildren.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                    
                    self.children = currentChildren
                }
            } catch {
                DispatchQueue.main.async {
                    if self.children == nil {
                        self.children = []
                    }
                }
            }
        }
    }
    
    private func startMonitoring() {
        guard source == nil else { return }
        
        fileDescriptor = open(path, O_EVTONLY)
        guard fileDescriptor != -1 else { return }
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: queue)
        
        source?.setEventHandler { [weak self] in
            self?.reloadChildren()
        }
        
        source?.setCancelHandler { [weak self] in
            guard let self = self else { return }
            close(self.fileDescriptor)
            self.fileDescriptor = -1
        }
        
        source?.resume()
    }
    
    private func stopMonitoring() {
        source?.cancel()
        source = nil
    }
}
