
import SwiftUI

struct JournalView: View {
    @EnvironmentObject private var journalViewModel : JournalViewModel
    
    @State var journal = Journal(notes: [])
    
    @State private var newNote = ""
    
    var body: some View {
        ZStack {
            
            NavigationView {
                VStack {
                    HStack {
                        CustomTextFieldView(text: $newNote, placeholder: "Add a new note to your journal!", keyboardType: .namePhonePad, sfSymbol: "pencil.and.outline")
                        Button(action: addNote) {
                            Text("Add")
                        }
                    }
                    
                    if !journalViewModel.notes.isEmpty{
                        List {
                            ForEach(journalViewModel.notes) { note in
                                Text(note.content)
                            }
                        }
                        .listStyle(.automatic)
                        .cornerRadius(8)
                    } else {
                        VStack {
                            Text("Create your first note by typing in the field and tap 'Add'!")
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                        }
                        .background(.gray)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.40), radius: 5, x: 0, y: 2)
                    }
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            resetJournal()
                            
                        } label: {
                            HStack {
                                Image(systemName: "xmark.bin")
                                Text("Reset Journal")
                            }
                        }
                        .padding()
                    }
                }
                .navigationBarTitle("Journal")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color("navBackground"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .padding()
                .onAppear {
                    journalViewModel.loadJournal()
                }
            }
        }
    }
    // making use of a local journal objects and the view model to delete existing note data from the database.
    private func resetJournal() {
        journalViewModel.notes = []
        journal = Journal(notes: [])
        journalViewModel.deleteUserJournal()
        print("JournalView: Reset Journal")
    }
    // making use of a local journal objects and the view model to push new note data to the database. Reset the string value of newNote once the add button is pressed so the user is ready to add a new note.
    private func addNote() {
        guard !newNote.isEmpty else {
            return
        }
        journal.notes.append(Note(content: newNote, journalID: journal.id))
        saveJournal()
        newNote = ""
    }
    // update child values on the database using the view model controller.
    private func saveJournal() {
        journalViewModel.saveJournal(journal: self.journal)
        journalViewModel.loadJournal()
    }
}
