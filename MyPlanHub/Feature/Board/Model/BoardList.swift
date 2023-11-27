
import Foundation

enum BoardListKeys: String, CodingKey {
    case id, boardID, name, cards
}

class BoardList: NSObject, ObservableObject, Identifiable, Codable {
    
    private(set) var id = UUID()
    
    var boardID: UUID
    
    @Published var boardName: String
    @Published var cardsList: [Card]?
    
    
    init(boardName: String, boardID: UUID) {
        self.boardName = boardName
        self.cardsList = []
        self.boardID = boardID
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BoardListKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.boardID = try container.decode(UUID.self, forKey: .boardID)
        self.boardName = try container.decode(String.self, forKey: .name)
        self.cardsList = try container.decodeIfPresent([Card].self, forKey: .cards) ?? []
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BoardListKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(boardID, forKey: .boardID)
        try container.encode(boardName, forKey: .name)
        try container.encode(cardsList, forKey: .cards)
    }
}

extension BoardList: NSItemProviderWriting {
    static let type_identifier = "com.westminster.MyPlanHub.BoardList"
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [type_identifier]
    }
    
    func cardIndex(id: UUID) -> Int? {
        cardsList?.firstIndex {
            $0.id == id
        }
    }
    
    func addNewCardItem(_ content: String) {
        cardsList?.append(Card(cardContent: content, boardListID: self.id))
    }
    
    func removeExistingCardItem(_ card: Card) {
        // if the guard fails, i.e., if we do not find an ID for this card , simply return nothing
        guard let i = cardIndex(id: card.id) else {return}
        cardsList?.remove(at: i)
    }
    
    func moveCards(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        cardsList?.move(fromOffsets: offsets, toOffset: offset)
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            JSONEncoder().outputFormatting = .prettyPrinted
            completionHandler(try JSONEncoder().encode(self), nil)
        } catch {
            completionHandler(nil,error)
        }
        return nil
    }
}

extension BoardList: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [type_identifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}

// References:
// Reordering items with drag and drop: https://stackoverflow.com/questions/62606907/swiftui-using-ondrag-and-ondrop-to-reorder-items-within-one-single-lazygrid/63438481#63438481
// Apple Documentation for NSItemProvider: https://developer.apple.com/documentation/foundation/nsitemproviderwriting/2888302-loaddata
// NSObject, NSItemProviderWriting: https://stackoverflow.com/questions/75073430/nsitemproviderwriting-for-dragging-content-to-finder
// NSObject, NSItemProviderWriting, NSItemProviderReading: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
