import Foundation
import Combine
import FirebaseAuth

protocol LoginService {
    func login(with credentials: UserLoginDetails) -> AnyPublisher<Void,Error>
}

final class LoginServiceController: LoginService {
    
    func login(with credentials: UserLoginDetails) -> AnyPublisher<Void,Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .signIn(withEmail: credentials.email, password: credentials.password) {
                        res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            // send void i.e., dont do anything
                            promise(.success(()))
                        }
                    } // end of signIn firebase auth
            } // end of combine future
        } // end of combine deferred
        .receive(on: RunLoop.main) // update UI
        .eraseToAnyPublisher()
    }
}

// REFERENCES:
// FIREBASE AUTH: https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
// FIREBASE AUTH: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
