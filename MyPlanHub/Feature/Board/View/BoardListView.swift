
import SwiftUI

struct BoardListView: View {
    
    @EnvironmentObject private var vm : BoardViewModel
    
    // This board list view will have a direct relationship with the boardlist state object defined below. We are also going to pass this from the board view.
    @StateObject var boardList: BoardList
    
    // This is set to observed object instead of state object,
    // because we are going to pass in the state object from the board view.
    @ObservedObject var board: Board

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            BoardListContainer
            
            List {
                ForEach(boardList.cardsList ?? []) { card in
                    CardItemView(boardList: self.boardList, card: card)
                        .onDrag {
                            NSItemProvider(object: card)
                        }
                }
                .onMove(perform: boardList.moveCards(fromOffsets:toOffset:))
                .onInsert(of: [Card.type_identifier], perform: onInsertCard(index:itemProviders:))
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
                
                
            }
            .listStyle(.plain)
            .background(.regularMaterial)
            
            Button {
                newCard()
            } label: {
                Text("+ Add new card item")
                    .bold().tint(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
            
        } // End of VStack
        .padding(.vertical)
        .background(.regularMaterial)
        .frame(width: 300)
        .cornerRadius(8)
    }
    
    // Refactoring out the boardlistview for cleaner code
    private var BoardListContainer: some View {
        HStack(alignment: .top) {
            Text(boardList.boardName)
                .font(.headline)
                .lineLimit(3)
            Spacer()
            Menu {
                Button {
                    editListNameAction()
                } label: {
                    Text("Rename")
                }
                
                Button("Delete list", role: .destructive) {
                    board.deleteBoardList(boardlist: boardList)
                    vm.setupAuth(board: self.board)
                }
                
            } label: {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .imageScale(.large)
                
            }
            
        }
        .padding(.horizontal)
    }
    // Making use of the toast alert view to add a new card and update the UI accorindlgy, saving changes to firebase.
    private func newCard() {
        showTextFieldToast(title: "New card for: \(boardList.boardName)") { text in
            // safely unwrap the text using guard let.
            // Handling empty text submission for a card item
            guard let text = text, !text.isEmpty else {return}
            // insert a new card item into the board list content
            let newCard = Card(cardContent: text, boardListID: boardList.id)

            boardList.cardsList?.append(newCard)
            print("BoardListView, boardList.cards: \(String(describing: boardList.cardsList))")
            vm.setupAuth(board: self.board)
        }
    }
    // method is invoked when the user drags a card and drops it either in the existing list of cards of another board list and the indexes of which the cards lay in the list is updated, or whether a board list is empty and it is the first card being added to the board list.
    private func onInsertCard(index: Int, itemProviders: [NSItemProvider]) {
        for itemProvider in itemProviders {
            itemProvider.loadObject(ofClass: Card.self) {
                NSItem, _ in
                // Getting the NSItem, ignore the error. Then casting the NSItem as a Card class in the guard.
                guard let card = NSItem as? Card else  {return}
                // Invoke the board move card method to another board list.
                // As this method updates a published property such as the list, it would be better to do this change on the main thread.
                DispatchQueue.main.async {
                    board.transferCard(card: card, to: boardList, at: index)
                }
                
            }
        }
    }
    
    private func editListNameAction() {
        showTextFieldToast(title: "Edit this list name: ", placeholder: boardList.boardName) { input in
            guard let newName = input,
                  !newName.isEmpty
            else {
                return
            }
            boardList.boardName = newName
            vm.setupAuth(board: self.board)
        }
    }
}
// References:
// Reordering items with drag and drop: https://stackoverflow.com/questions/62606907/swiftui-using-ondrag-and-ondrop-to-reorder-items-within-one-single-lazygrid/63438481#63438481
// UI, UX, Design Infrastructure: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
