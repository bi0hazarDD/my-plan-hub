
import SwiftUI

struct AddBoardView: View {
    
    @EnvironmentObject private var vm : BoardViewModel
    
    @Binding var showAddBoardSheet: SheetView?
    @Binding var path: NavigationPath
    
    @Binding var latestBoardName: String 
    @State var createBoardTapped = false
    
    
    var body: some View {
        
        NavigationStack {
            NavigationView {
                VStack {
                    Form {
                        Section("Name of Board") {
                            CustomTextFieldView(text: $latestBoardName, placeholder: "New Board", keyboardType: .namePhonePad, sfSymbol: "menubar.dock.rectangle")
                        }
                    } // End of Form
                }  // end of  VStack
            }// end of Navigation View
            .navigationTitle("Board")
            .navigationBarTitle(Text("Create a board"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        print("Dismissing sheet view...")
                        self.showAddBoardSheet = nil
                    }) {
                        Image(systemName: "xmark")
                            .padding()
                    }
                ,trailing:
                
                Button {
                    print("Clicked Create Button")
                    self.createBoardTapped = true
                    path.append("BoardView")
                    self.showAddBoardSheet = nil
                    
                } label: {
                    Text("Create")
                        .bold()
                        .padding()
                }
            )
            
        } // end of navigation Stack
    }
}



