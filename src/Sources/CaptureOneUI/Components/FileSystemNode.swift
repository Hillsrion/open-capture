import SwiftUI
import AppCoreShared

/// Reconstructed hierarchical file system node for System Folders.
public class FileSystemNode: ObservableObject, Identifiable {
    public let id: String
    public let path: String
    public let name: String
    
    @Published public var children: [FileSystemNode]? = nil
    @Published public var isExpanded: Bool = false
    
    public var isLoaded: Bool { children != nil }
    
    public init(path: String) {
        self.id = path
        self.path = path
        self.name = (path as NSString).lastPathComponent
    }
    
    public func loadChildren() {
        guard !isLoaded else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileManager = FileManager.default
                let contents = try fileManager.contentsOfDirectory(atPath: self.path)
                
                var newChildren: [FileSystemNode] = []
                for item in contents {
                    let fullPath = (self.path as NSString).appendingPathComponent(item)
                    var isDir: ObjCBool = false
                    if fileManager.fileExists(atPath: fullPath, isDirectory: &isDir), isDir.boolValue {
                        // Ignore hidden folders
                        if !item.hasPrefix(".") {
                            newChildren.append(FileSystemNode(path: fullPath))
                        }
                    }
                }
                
                newChildren.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                
                DispatchQueue.main.async {
                    self.children = newChildren
                }
            } catch {
                DispatchQueue.main.async {
                    self.children = []
                }
            }
        }
    }
}
