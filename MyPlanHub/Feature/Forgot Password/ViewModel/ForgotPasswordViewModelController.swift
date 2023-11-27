
import Foundation
import Combine

protocol ForgotPasswordViewModel {
    func sendPasswordReset()
    var service: ForgotPasswordServiceController {get}
    var email: String {get}
    init (service: ForgotPasswordServiceController)
}

final class ForgotPasswordViewModelController: ObservableObject, ForgotPasswordViewModel {
    
    var service: ForgotPasswordServiceController
    // injecting the service controller into our view model
    init(service: ForgotPasswordServiceController) {
        self.service = service
    }
    // email string var with Published property wrapper as this var will be directly tied to the forgot password view. As such, this is the email that the initializeForgotPassword() method will use as a parameter.
    @Published var email: String = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    func sendPasswordReset() {
        service
            .initializePasswordReset(to: email)
            .sink { res in
                switch res {
                case .failure(let err):
                    print("Failed: \(err)")
                default: break
                }
            }receiveValue: {
                print("Sent password reset request")
            }
            .store(in: &subscriptions)
    }
    
}
