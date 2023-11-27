import Foundation
// All the data that will be written to Firebase RealTime Database, except the password. This is handled with Firebase Authentication.
struct UserRegistrationInfo {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var occupaiton: String
}
