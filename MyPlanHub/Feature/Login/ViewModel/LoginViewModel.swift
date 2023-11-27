
import Foundation
import Combine

// The states defined below govern the use of the app after the login stage. User will only advance to further functionality throughout the app if the login state is successful. If there is an error, the error is displayed on the login page, before authentication is confirmed.
enum LoginStateEnum {
    case successful
    case failed(error: Error)
    case na
}

// protocol describes what functions and vars need to be implemented for the class that will use it. Improves codebase robustness and easier to identify and implement future functionality.
protocol LoginViewModel {
    func login()
    var service: LoginService {get}
    var state: LoginStateEnum {get}
    var credentials: UserLoginDetails {get}
    var errorReceived: Bool {get}
    
    init(service: LoginService)
}

final class LoginViewModelController: ObservableObject, LoginViewModel {
    // Initializing view model published variables that will be directly tied with the LoginView.
    @Published var errorReceived: Bool = false
    @Published var state: LoginStateEnum = .na // neither successful or failed initially, so na fits
    @Published var credentials: UserLoginDetails = UserLoginDetails(email: "", password: "")
    
    var service: LoginService
    
    private var subscriptions = Set<AnyCancellable>()
    
    // Calling the setupErrorSubscriptions method in the initialiser so that we are always listening to the changes to our state and therefore our hasError value.
    // injecting our service to our view model so we are able to utilize the methods such as signing in.
    init(service: LoginService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    // general login function makes use of the service authentication service within Firebase framework.
    // use of combine to get the value of performing the login function with our publisher via 'sink'. Switch to check value of result using combine, case that a .failure is returned, set our custon enum state to failed, passing the error. Otherwise, set this state to true as this means all checks passed with no errors within the service, can allow user to login now. store this in the subscriptions var.
    func login() {
        service
            .login(with: credentials)
            .sink{ res in
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
            } receiveValue: {  [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
    
}

private extension LoginViewModelController {
    
    // Observing if the value for $state changes, we are going to map it to $errorReceived
    // depending on whether it was successful/ na or if the state is currently set to failed, meaning that some error has occured, such as the login password not being correct, email vice versa.
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case . successful,
                        .na:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$errorReceived)
    }
}

// REFERENCES:
// FIREBASE AUTH: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
//https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
