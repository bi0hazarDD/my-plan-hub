
import Foundation
import Combine
import FirebaseAuth

final class ForgotPasswordServiceController {
    // Returns a publisher that we promise as either a .failure or .success depending whether we recieve an error. we check this by safely unwrapping error, and submit the publisher. otherwise, nothing went wrong and simply return success(void).
    func initializePasswordReset(to email: String) -> AnyPublisher<Void,Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .sendPasswordReset(withEmail: email) { error in
                        if let err = error {
                            // return the actual error if password reset failed
                            promise(.failure(err))
                        } else {
                            // return void
                            promise(.success(()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
// References:
// Firebase forgot password: https://firebase.google.com/docs/auth/ios/manage-users
// Firebase, Combine: https://www.youtube.com/watch?v=5gIuYHn9nOc&ab_channel=tundsdev
