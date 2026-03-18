import SwiftUI
import AppCoreShared
import DataCore

public struct SmartAlbumEditorView: View {
    @ObservedObject var collection: CollectionBase
    var session: SessionBase
    var onDismiss: () -> Void
    
    @State private var name: String
    @State private var predicate: COFilterPredicate
    
    public init(collection: CollectionBase, session: SessionBase, onDismiss: @escaping () -> Void) {
        self.collection = collection
        self.session = session
        self.onDismiss = onDismiss
        self._name = State(initialValue: collection.name ?? "New Smart Album")
        self._predicate = State(initialValue: COFilterPredicate())
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("Edit Smart Album")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Name:")
                    .frame(width: 80, alignment: .trailing)
                TextField("Smart Album Name", text: $name)
                    .textFieldStyle(.roundedBorder)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Match the following conditions:")
                    .font(.subheadline)
                
                HStack {
                    Text("Rating >=")
                        .frame(width: 80, alignment: .trailing)
                    Picker("", selection: $predicate.minRating) {
                        Text("Any").tag(Int?.none)
                        ForEach(1...5, id: \.self) { rating in
                            Text("\(rating) Stars").tag(Int?.some(rating))
                        }
                    }
                    .frame(width: 120)
                }
                
                HStack {
                    Text("Color Tag:")
                        .frame(width: 80, alignment: .trailing)
                    Picker("", selection: Binding<Int?>(
                        get: { predicate.colorTags?.first },
                        set: { if let val = $0 { predicate.colorTags = [val] } else { predicate.colorTags = nil } }
                    )) {
                        Text("Any").tag(Int?.none)
                        Text("Red (1)").tag(Int?.some(1))
                        Text("Orange (2)").tag(Int?.some(2))
                        Text("Yellow (3)").tag(Int?.some(3))
                        Text("Green (4)").tag(Int?.some(4))
                        Text("Blue (5)").tag(Int?.some(5))
                        Text("Pink (6)").tag(Int?.some(6))
                        Text("Purple (7)").tag(Int?.some(7))
                    }
                    .frame(width: 120)
                }
                
                HStack {
                    Text("Search Text:")
                        .frame(width: 80, alignment: .trailing)
                    TextField("Text", text: Binding(
                        get: { predicate.searchText ?? "" },
                        set: { predicate.searchText = $0.isEmpty ? nil : $0 }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
            
            HStack {
                Spacer()
                Button("Cancel") {
                    onDismiss()
                }
                Button("Save") {
                    saveChanges()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 400)
    }
    
    private func saveChanges() {
        collection.name = name
        let sql = predicate.toSQL()
        
        do {
            try DataCoreManager.shared.writer().updateSmartAlbumPredicate(uuid: collection.uuid, predicateSQL: sql)
        } catch {
            print("Failed to save smart album predicate: \(error)")
        }
        
        session.isDirty = true
        onDismiss()
    }
}
