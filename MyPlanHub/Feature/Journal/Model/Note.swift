
import Foundation

enum NoteKeys: String, CodingKey {
    case id, content
}

class Note: ObservableObject, Codable, Identifiable {
    var id = UUID()
    @Published var content: String
    
    init(content: String, journalID: UUID) {
        self.content = content
    }
    // initializers required for Codable objects
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NoteKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
    }
    // initializers required for Codable objects
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NoteKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
    }
}
