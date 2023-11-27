
import Foundation

class Card: NSObject, ObservableObject, Identifiable, Codable {
    private(set) var id = UUID()
    
    var boardListID: UUID
    // Our swiftUI view will have a reference to this observable object, i.e., this content String.
    // Therefore, when this content is updated, the view will be updated (redrawn) when using the published property wrapper.
    @Published var cardContent: String
    
    enum CardKeys: String, CodingKey {
        case id, boardListID, content
    }
    
    init(cardContent: String, boardListID: UUID) {
        self.cardContent = cardContent
        self.boardListID = boardListID
        // Because Card is a subclass of NSObject, there is a need to call the parent initializers.
        super.init()
    }
    
    // As we have published variables, we need to define the encoding and decoding explicitly as we are conforming to the Codable protocol.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CardKeys.self)
        // set by invoking decode method
        self.id = try container.decode(UUID.self, forKey: .id)
        self.boardListID = try container.decode(UUID.self, forKey: .boardListID)
        self.cardContent = try container.decode(String.self, forKey: .content)
        // Because Card is a subclass of NSObject, need to call the parent initializers.
        super.init()
    }
    // As we have published variables, we need to define the encoding and decoding explicitly as we are conforming to the Codable protocol.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CardKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(boardListID, forKey: .boardListID)
        try container.encode(cardContent, forKey: .content)
    }
}

// Implement protocols

// NSITemProdiverWriting implementation
// This will be invoked when the user drags this card in the user interface of the board.

extension Card: NSItemProviderWriting {
    // type identifer used in the BoardView to identify the thing being dragged is indeed a card, and uses this type identifier.
    static let type_identifier = "com.westminster.MyPlanHub.Card"
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [type_identifier]
    }
    
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
        do {
            JSONEncoder().outputFormatting = .prettyPrinted
            // invoke the completion handler passing the data, pass nil for the error 2nd parameter
            completionHandler(try JSONEncoder().encode(self), nil)
        } catch {
            // Passing nil for the data parameter, pass the actual error
            completionHandler(nil, error)
        }
        // returning nil as we do not need the Progress object.
        return nil
    }
}

// NSITemProdiverReading implementation
// This will be invoked when the user after dragging, drops this card in another location on the user interface for the board.

extension Card: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        // same identifier as before
        [type_identifier]
    }
    // Decode this data into the shortcut model
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        // Self = Card class, .self = type for the first parameter.
        // Passing the data in the second parameter
        try JSONDecoder().decode(Self.self, from: data)
    }

}

// References:
// Apple Documentation for NSItemProvider: https://developer.apple.com/documentation/foundation/nsitemproviderwriting/2888302-loaddata
// NSObject, NSItemProviderWriting: https://stackoverflow.com/questions/75073430/nsitemproviderwriting-for-dragging-content-to-finder
// NSObject, NSItemProviderWriting, NSItemProviderReading: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
