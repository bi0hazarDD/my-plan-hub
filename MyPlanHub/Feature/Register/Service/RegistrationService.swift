import Foundation
import Combine
import Firebase
import FirebaseDatabase
import FirebaseAuth

// These are the keys that we will be storing in firebase realtime database.

enum UserRegistrationKeys: String {
    case email
    case firstName
    case lastName
    case occupation
}

protocol RegistrationService {
    
    // registering with details being the struct with the values from said struct that we will pass in
    // The return type AnyPublisher means we will return a publisher that we can subscribe to and,
    // if it is successful then we will return Void. This is because, if a user is successful, we
    // do not need to return anything back.
    
    // if there is an error, we want to throw back this error so we return this.
    
    func register(with details: UserRegistrationInfo) -> AnyPublisher<Void, Error>
}

// Here we say our implementation should use our RegistrationService protocol
// set as final so other classes canot sub-class this class.

final class RegistrationServiceController: RegistrationService {
    // Write out logic and create a publisher
    
    // we are using Combine to create a publisher and handle if we get a success or failure from
    // Firebase, i.e., Deferred and Future are from the combine framework.
    // using the createUser() method provided by FirebaseAuth package.
    func register(with details: UserRegistrationInfo) -> AnyPublisher<Void, Error> {
        
        Deferred {
            Future { promise in
                Auth.auth().createUser(withEmail: details.email,
                                       password: details.password) { res, error in
                    // When we get the callback from firebase, we will check the error.
                    // If it exists, we will use our Future to push that error
                    
                    // We unwrap the error, and we push the error so that we can subscribe to
                    // any errors that we recieve.
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        // We successfully created the user. now need to create the user with the additional data that we have in registration details. have to use the Firebase Realtime function to associate this data. with that user.So need a set of keys to associate the data, as the function works with dictionaries. So, from the result that we get back from the user that we created, and if we can safely unwrap their userID, then we are going to create a dictionary with values to store in firebase realtime database.
                        
                        if let uid = res?.user.uid {
                            // KEY : VALUE pairs to send to firebase
                            let values = [UserRegistrationKeys.firstName.rawValue: details.firstName,
                                          UserRegistrationKeys.lastName.rawValue : details.lastName,
                                          UserRegistrationKeys.occupation.rawValue : details.occupaiton,
                                          UserRegistrationKeys.email.rawValue : details.email
                            ] as [String : Any]
                            
                            // Accessing the database, referencing it, getting our table users and
                            // creating a child node with the users ID so we can associate that data
                            // with the user.
                            // Update then the child values with the values we created. Error handling.
                            
                            Database.database()
                                .reference()
                                .child("users")
                                .child(uid)
                                .updateChildValues(values) { error, ref in
                                    
                                    if let err = error {
                                        promise(.failure(err))
                                    } else {
                                        promise(.success(()))
                                    }
                                }
                        // end of user id unwrap
                        } else {
                            promise(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
                        }
                    } // end of else statement for error unwrap
                    
                } // end of Auth.auth()
            } // end of Future
        } // end of Deferred
        // Back on the main thread so any responses from firebase we can use to do work on the UI
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        
    }
}

// REFERENCES:
// FIREBASE: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
// FIREBASE: https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
