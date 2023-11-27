
import Foundation

enum JournalKeys: String, CodingKey {
    case id, notes
}

class Journal: ObservableObject, Identifiable, Codable {
    
    var id = UUID()
    @Published var notes: [Note]
    
    init(notes: [Note]) {
        self.notes = []
    }
    // initializers required for Codable objects
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JournalKeys.self)
        self.id = try container.decode(UUID.self,forKey: .id)
        self.notes = try container.decodeIfPresent([Note].self, forKey: .notes) ?? []
    }
    // initializers required for Codable objects
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JournalKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(notes, forKey: .notes)
    }
}
