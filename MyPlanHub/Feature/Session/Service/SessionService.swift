import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase
import Firebase

enum SessionStateEnum {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionStateEnum {get}
    var userDetails: SessionUserDetails? {get}
    func logout()
}

final class SessionServiceViewModelController: ObservableObject, SessionService {
    // marked these two as published because we are going to use these later to listen to changes
    // and if there are changes, then redraw our view.
    @Published var state: SessionStateEnum = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    // initializion below ensures that the user refresh method reads the values from the database for the currently logged in user. Used in the info view.
    init() {
        setupFirebaseAuthHandler()
    }
    // signs the user out of the application using Firebase's package
    func logout() {
        try? Auth.auth().signOut()
    }
}

extension SessionServiceViewModelController {
    // method invoked on the InfoView to update all child values associated with the user, given the dictionary of data. Custom RegistrationKeys are utilized to assign key:value pairs for the dictionary to be read in by Firebase. Use of safe unwrapping techniques for error handling.
    func updateUserInfo(firstName: String, lastName: String, occupation: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = Database.database().reference().child("users").child(uid)
        
        let updatedInfo: [String: Any] = [
            UserRegistrationKeys.firstName.rawValue: firstName,
            UserRegistrationKeys.lastName.rawValue: lastName,
            UserRegistrationKeys.occupation.rawValue: occupation
        ]
        
        userRef.updateChildValues(updatedInfo) { error, _ in
            if let error = error {
                print("Failed to update user info: \(error)")
            } else {
                print("User info updated successfully")
            }
        }
    }

}
// Initialized when the user logs into the app, the purpose of these methods are to are to ensure that once after the user is logged in through the Firebase Auth functions, their details are obtained safely, through the use of a handler to check if any objects are returned as nil, as this would mean the last action was a logout. Otherwise, a !nil object proves says that the user is currently logged in. As such, modifications to the state take place through a ternary operator.
private extension SessionServiceViewModelController {
    
    func setupFirebaseAuthHandler() {
        // After we assign the handler, we are going to check if the user object comes back as nil,
        // if it user == nil then it assumes you are logged out, otherwise state is loggedIn.
        handler = Auth
            .auth()
            .addStateDidChangeListener {[weak self] res, user in
                guard let self = self else {return}
                self.state = user == nil ? .loggedOut : .loggedIn
            
                if let uid = user?.uid {
                    self.handleUserRefresh(with: uid)
                }
            }
    }
    // method for retrieving the most up to date user details from the firebase realtime database once verification of the user being logged-in is confirmed. dispatch information to the main thread so that updates to the UI may take place.
    func handleUserRefresh(with uid: String) {
        Database
            .database()
            .reference()
            .child("users")
            .child(uid)
            .observe(.value) { [weak self] snapshot in
                guard let self = self,
                    let value = snapshot.value as? NSDictionary,
                    let firstName = value[UserRegistrationKeys.firstName.rawValue] as? String,
                    let lastName = value[UserRegistrationKeys.lastName.rawValue] as? String,
                    let occupation = value[UserRegistrationKeys.occupation.rawValue] as? String,
                      let email = value[UserRegistrationKeys.email.rawValue] as? String
                else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.userDetails = SessionUserDetails(email: email, firstName: firstName,
                                                          lastName: lastName,
                                                          occupation: occupation)
                }
                      
            }
    }
}
