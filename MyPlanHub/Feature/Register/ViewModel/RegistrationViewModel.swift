
import Foundation
import Combine

// Allows us to handle the event for the state of whether this was a success or fail. initialized as na because it is neither successful or failed at the start.
enum RegistrationStateEnum {
    case successful
    case failed(error: Error)
    case na
}

// in our protocol we have the function to handle register in,
// we have a property to inject and using our service
// we have another property for handling the state changes in our view model
// we have another user Details property to bind the details to our view model
// we have an init to inject our service into our view model

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService{get}
    var state: RegistrationStateEnum{get}
    var userDetails: UserRegistrationInfo{get}
    var hasError: Bool {get}
    
    init(service: RegistrationService)
}

final class RegistrationViewModelController : RegistrationViewModel, ObservableObject {
    // values we will be observing on our view
    @Published var hasError: Bool = false
    @Published var state: RegistrationStateEnum = .na
    
    let service: RegistrationService
    
    init(service: RegistrationService) {
        self.service = service
        setupErrorSubscriptions()
    }
    // This published property makes sure that the information typed in the registration fields is tied directly back to the registration view model here.
    @Published var userDetails: UserRegistrationInfo = UserRegistrationInfo(email: "",
                                                               password: "",
                                                               firstName: "",
                                                               lastName: "",
                                                               occupaiton: "")
    // subscriptions to check any errors and update UI
    private var subscripbtions = Set<AnyCancellable>()
    // Use of combine again for a succesful or unsuccessful registration action i.e., successful = all fields correctly filled in, failed = missing fields, incorrect email format, not long enough password length.
    func register() {
        // listening in to our publisher value
        service
            .register(with: userDetails)
            .sink { [weak self] res in
                switch res {
                case .failure(let err) :
                    self?.state = .failed(error: err)
                default: break
                }
                // if we recieve a value, it means everything was fine and so we can set our
                // state to successful
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscripbtions)
    }
}

private extension RegistrationViewModelController {
    
    // Observing if the value for $state changes, we are going to map it to $hasError
    // depending on whether it was successful/ na or if the state is currently set to failed, meaning
    // that some error has occured, such as the registration details not being filled in, email vice versa.
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .successful,
                        .na:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}

// REFERENCES:
// FIREBASE: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
// FIREBASE, COMBINE: https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
