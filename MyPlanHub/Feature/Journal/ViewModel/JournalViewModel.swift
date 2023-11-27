import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

final class JournalViewModel: ObservableObject {
    
    @Published var notes = [Note]()
    
    // saving Journal objects to firebase, similar process to BoardViewModel
    func saveJournal(journal: Journal) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("users").child(userID).child("journal")
        let data = try? JSONEncoder().encode(journal)
        
        if let data = data, let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            let journalRef = ref.child("\(journal.id)")
            
            journalRef.updateChildValues(jsonDict) { (error, ref) in
                if let error = error {
                    print("Error updating board data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // loading and reading Journal objects from firebase, similar process to BoardViewModel
    func loadJournal() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("users").child(userID).child("journal")
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let journalDict = snapshot.value as? [String: Any] else { return }
            // Create a local array to store the loaded notes
            var loadedNotes = [Note]()
            
            for (_, journalData) in journalDict {
                guard let journalDataDict = journalData as? [String: Any],
                      let notesData = journalDataDict["notes"] as? [[String: Any]] else { continue }
                
                for noteData in notesData {
                    if let note = try? JSONDecoder().decode(Note.self, from: JSONSerialization.data(withJSONObject: noteData)) {
                        loadedNotes.append(note)
                    }
                }
            }
            
            DispatchQueue.main.async {
                // Assign the loaded notes directly to the view model's `notes` array so that we are ready to update the UI
                self.notes = loadedNotes
            }
        }
    }
    // Deletes all Journal objects associated with the user.
    func deleteUserJournal() {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("users").child(userID).child("journal")
        ref.removeValue()
    }
}

// References:
// Write objects to firebase: https://medium.com/cleansoftware/firebase-database-minimalistic-step-by-step-deployment-tutorial-using-swift-5-21e934209929
// Read and write data to firebase: https://firebase.google.com/docs/database/ios/read-and-write
// Writing complex objects to firebase: https://stackoverflow.com/questions/61536726/swift-how-to-write-complex-objects-to-firebase-realtime-database
