import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

final class BoardViewModel: ObservableObject {
    
    // Writing to Firebase Realtime Database
    @Published var fetchedBoards = [Board]()
    
    func setupAuth(board: Board) {
        // safely unwrap userID using firebase Auth
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        writeBoardData(with: userID, board: board)
    }
    
    // Write board data to realtime database, firstly by encoding the board object into JSON, transformed into a dictionary using JSONSerializaiton as [String: Any]. Use of updateChildValues to also update the board object is board values are changed.
    
    func writeBoardData(with uid: String, board: Board) {
        let firebaseRef = Database.database().reference()
        let data = try? JSONEncoder().encode(board)
        
        if let data = data, let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            let boardRef = firebaseRef.child("users").child(uid).child("boards").child("\(board.id)")
            
            boardRef.updateChildValues(jsonDict) { (error, ref) in
                if let error = error {
                    print("Error updating board data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Fetch all boards associated with the currently signed in user by initially unwrapping the userid. next, get the reference of the database and the pointer to where we want to retrieve the data from. next, observing the values and taking a snapshot to peek into values for each board object that currently exists, transform these boards into a dictionary called 'boardsDict'. This dictionary of boards gets transformed into JSON which then gets decoded and stored into another dictionary of key value pairs of [boardID : Board] objects, named fetchedBoards. the values of this are simply board objects, therefore these are transferred to an array of board objects called 'boards', which are then assigned to the view model Published property fetchedBoards, which is displayed in the BoardView.
    func fetchBoards() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userID).child("boards")
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else {return}
            
            do {
                if let boardsDict = snapshot.value as? [String: Any] {
                    let data = try JSONSerialization.data(withJSONObject: boardsDict, options: [])
                    let fetchedBoards = try JSONDecoder().decode([String: Board].self, from: data)
                    
                    let boards = Array(fetchedBoards.values)
                    
                    self.fetchedBoards = boards
                    
                } else {
                    // No boards found for the current user
                    self.fetchedBoards = [] // Set the fetchedBoards to an empty array
                    print("fetchedBoards(): Setting fetchedBoards to empty arr")
                }
            } catch {
                print("Error decoding boards:", error)
            }
        }
    }
    // Delete all existing boards on the database associated with this user, safely unwrapping their userID and pointing to the 'boards' node.
    func deleteAllUserBoards() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("users").child(userID).child("boards")
        ref.removeValue()
    }
}

// References:
// Write objects to firebase: https://medium.com/cleansoftware/firebase-database-minimalistic-step-by-step-deployment-tutorial-using-swift-5-21e934209929
// Read and write data to firebase: https://firebase.google.com/docs/database/ios/read-and-write
// Writing complex objects to firebase: https://stackoverflow.com/questions/61536726/swift-how-to-write-complex-objects-to-firebase-realtime-database
