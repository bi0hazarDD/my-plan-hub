import Foundation
import SwiftUI

class InfoViewModel: ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    @Published var occupation: String
    
    private var session = SessionServiceViewModelController()
    // inject the session service to use its functions within this class
    init(sessionService: SessionServiceViewModelController) {
        self.session = sessionService
        
        // Initialize the view model properties with the current user details
        let userDetails = sessionService.userDetails
        firstName = userDetails?.firstName ?? ""
        lastName = userDetails?.lastName ?? ""
        occupation = userDetails?.occupation ?? ""
    }
    // using session
    func updateInfo() {
        // Update the user details in the Firebase Realtime Database
        session.updateUserInfo(firstName: firstName, lastName: lastName, occupation: occupation)
    }
}

