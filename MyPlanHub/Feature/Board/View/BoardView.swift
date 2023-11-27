
import SwiftUI

struct BoardView: View {
    
    @EnvironmentObject private var vm : BoardViewModel
    
    @StateObject var board: Board
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var dragging: BoardList?
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 30) {
                    ForEach(board.lists ?? []) { boardlist in
                        BoardListView(boardList: boardlist, board: board)
                        // The result of implementing the board drop delegate methods, allowing the user to drop cards into the entire frame of a board list view, inserting them at the first of the queue if the destination list is empty.
                            .onDrag({
                                self.dragging = boardlist
                                return NSItemProvider(object: boardlist)
                            })
                            .onDrop(of: [Card.type_identifier,BoardList.type_identifier], delegate: BoardDropDelegateController(lists: $board.lists, currentBoardList: $dragging, board: board, boardList: boardlist))
                    }
                    
                    Button {
                        addListAction()
                    } label: {
                        Text("+ Add another list")
                            .padding()
                            .bold()
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(width: 150)
                    .background(.regularMaterial)
                    .cornerRadius(8)
                    
                }
                .padding()
            }
            .background(Image("sunset").resizable())
            .edgesIgnoringSafeArea(.bottom)
            .navigationViewStyle(.automatic)
            .toolbar(.hidden, for: .tabBar)
            .animation(.easeIn, value: board.lists)
        } // End of Navigation View
        .navigationBarBackButtonHidden()
        .navigationTitle(self.board.BoardName)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(board.$lists) { _ in
            vm.setupAuth(board: board)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    vm.setupAuth(board: self.board)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward.circle")
                        .tint(.red)
                        .padding(0)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    renameBoardAction()
                } label: {
                    Image(systemName: "pencil.circle")
                        .tint(.blue)
                        .padding(0)
                }
            }
        }
        // When the app goes to the background, the board will be saved using the save function from the BoardPersistence class.
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            vm.setupAuth(board: self.board)
        }
//        .onAppear {
//            print("BoardView, board.lists: \(String(describing: board.lists))")
//            vm.setupAuth(board: self.board)
//        }
    }
    // renaming the board using the toast function made, returns the string the user inputs and sets it to the board objects board name
    private func renameBoardAction() {
        showTextFieldToast(title: "Rename your board",placeholder: board.BoardName) { input in
            guard let boardName = input,
                  !boardName.isEmpty
            else {
                return
            }
            board.BoardName = boardName
            vm.setupAuth(board: self.board)
        }
    }
    // append the lists array of BoardLists with a new board list object, and update UI accorndingly.
    private func addListAction() {
        showTextFieldToast(title: "Enter a new list name:") { input in
            guard let boardListName = input,
                  !boardListName.isEmpty
            else {
                return
            }
            let newList = BoardList(boardName: boardListName, boardID: self.board.id)
            board.lists?.append(newList)
            vm.setupAuth(board: self.board)
        }
    }
}

// References: //    https://stackoverflow.com/questions/57517803/how-to-remove-the-default-navigation-bar-space-in-swiftui-navigationview
// UI, UX, Design Infrastructure: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
