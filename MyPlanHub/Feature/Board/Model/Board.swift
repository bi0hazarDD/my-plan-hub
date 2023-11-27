
import Foundation

class Board: ObservableObject, Identifiable, Codable {
//    private(set)
    var id = UUID()
    // name of the actual board
    @Published var BoardName : String
    // a parent list contains all the subsequent lists in the boards i.e., categories, with their individual cards, boardID and the name of the category. Will be shown in horizontal scrollview.BoardPersistence().load() ?? Board.testBoard
    @Published var lists: [BoardList]?
    
    init(name: String) {
        self.BoardName = name
        self.lists = []
    }
    
    enum BoardKeys: String, CodingKey {
        case id, name, lists
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BoardKeys.self)
        self.id = try container.decode(UUID.self,forKey: .id)
        self.BoardName = try container.decode(String.self, forKey: .name)
        self.lists = try container.decodeIfPresent([BoardList].self, forKey: .lists) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BoardKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(BoardName, forKey: .name)
        try container.encode(lists, forKey: .lists)
    }
    
    func transferCard(card: Card, to destinationBoardList: BoardList, at index: Int) {
        // An initial guard block ensures no errors and allows for additional checks.
        // This is the initial board list index of the card that is currently being dragged.
        // i.e., the source board list
        guard let initialIndex = boardListIndex(id: card.boardListID),
              let finalIndex = boardListIndex(id: destinationBoardList.id),
              // Checking to see that we are not dragging and dropping into the same board list.
                initialIndex != finalIndex,
              // this index is the index of the list at which the user picked the card up in that current time. e.g., could be the first card in the list i.e., index 0.
              let initialCardIndex = getCardIndex(id: card.id, boardIndex: initialIndex)
        else {
            // i.e., the user must have attempted to drag and drop in the same box
            print("BOARD_MODEL_ERROR: User attempted to drag and drop in the same board list.")
            print("BOARD_MODEL_ERROR: Returning ...")
            return
        }
        
        // Now that our checks are done, we can safely assume that the initial index and final index values are obtained, and the user is not attempting to drag and drop the card inside the same initial board list.
        destinationBoardList.cardsList?.insert(card, at: index)
        card.boardListID = destinationBoardList.id
        // Next remove the card from the initial board list where the card was dragged out of.
        lists?[initialIndex].cardsList?.remove(at: initialCardIndex)
            
    }
    
    private func getCardIndex(id: UUID, boardIndex: Int) -> Int? {
        lists?[boardIndex].cardIndex(id: id)
    }
    
    private func boardListIndex(id: UUID) -> Int? {
        lists?.firstIndex {
            $0.id == id
        }
    }
    
    // Action of user creating a new board and inserting it into the lists array associated with this board.
    func createBoardList(name: String) {
        // adding a new board list to the board, with a name parameter and the boardID of this current board.
        
        lists?.append(BoardList(boardName: name, boardID: self.id))
    }
    
    // Action of user deleting an exisitng board by accessing its index through the boardListIndex method and removing it from the lists array associated with this board.
    
    func deleteBoardList(boardlist: BoardList) {
        guard let index = boardListIndex(id: boardlist.id)
        else {
            return
        }
        // after guard check, we can complete the action of removing the boardlist at the index that this boardlist currently resides in the main Board.
        lists?.remove(at: index)
    }

}

// References:
// Apple Documentation for NSItemProvider: https://developer.apple.com/documentation/foundation/nsitemproviderwriting/2888302-loaddata
// NSObject, NSItemProviderWriting: https://stackoverflow.com/questions/75073430/nsitemproviderwriting-for-dragging-content-to-finder
// NSObject, NSItemProviderWriting, NSItemProviderReading: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
