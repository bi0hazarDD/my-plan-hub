import SwiftUI

enum SheetView: Identifiable {
    var id: Self { self }
    case addBoard, addCard
}

struct HomeView: View {
    
    @EnvironmentObject private var vm: BoardViewModel
    //    @State private var testBoard = Board.testBoard
    
    @State private var showSheet: SheetView? = nil
    @State private var path = NavigationPath()
    @State private var latestBoardName : String = ""
    
    
    var body: some View {
        
        NavigationStack(path: $path) {
            VStack {
                List {
                    if !vm.fetchedBoards.isEmpty {
                        Section("Your boards"){
                            ForEach(vm.fetchedBoards, id: \.id) { board in
                                NavigationLink(destination: BoardView(board: board)) {
                                    HStack{
                                        Image(systemName: "ipad.landscape")
                                        if !board.BoardName.isEmpty {
                                            Text(board.BoardName)
                                                .foregroundColor(.blue)
                                                .bold()
                                                .padding()
                                        } else {
                                            Text("(No name)").foregroundColor(.blue)
                                                .bold()
                                                .padding()
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No boards available, create one by tapping on the top right!")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        vm.deleteAllUserBoards()
                        vm.fetchBoards()
                        print("Deleted all user boards function invoked")
                    } label: {
                        HStack {
                            Image(systemName: "xmark.bin")
                            Text("Delete all boards")
                                .foregroundColor(.red)
                                .bold()
                        }
                    }
                    .padding()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showSheet = .addBoard
                            print("Create a board")
                            
                        } label: {
                            Label(
                                title: {Text("Create a board")},
                                icon: {Image(systemName: "menubar.dock.rectangle")}
                            )}
                        
                        Button {
                            showSheet = .addCard
                            print("Add a Card")
                            
                        } label: {
                            Label(
                                title: {Text("Add a Card")},
                                icon: {Image(systemName: "note.text.badge.plus")}
                            )}
                        
                    } label: {
                        Label(
                            title: {Text("Add")},
                            icon: {Image(systemName: "plus.circle")}
                        )}
                } // end of Menu
            } // end of toolbar
            .navigationTitle("Home")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("navBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(item: $showSheet) { mode in
                content(for: mode)
            }
            .navigationDestination(for: String.self) { view in
                if view == "BoardView" {
                    BoardView(board: Board(name: self.latestBoardName))
                }
            }
            .onAppear {
                
                vm.fetchBoards()
                print("latestBoardName: \(latestBoardName)")
                print("HomeView: \(String(describing: vm.fetchedBoards.first?.lists))")
                print("HomeView Path: \(path)")
            }
        } // End of Navigation Stack
    }
    
    @ViewBuilder
    func content(for mode: SheetView) -> some View {
        switch mode {
        case .addBoard:
            AddBoardView(showAddBoardSheet: $showSheet, path: $path, latestBoardName: $latestBoardName)
        case .addCard:
            Text("Future possible work: Add card")
        }
    }
    
}



