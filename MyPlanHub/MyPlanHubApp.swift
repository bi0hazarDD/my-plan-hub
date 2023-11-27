
import SwiftUI
import Firebase

@main
struct MyPlanHubApp: App {
    
    @StateObject private var session = SessionServiceViewModelController()
    
    @StateObject private var boardViewModel = BoardViewModel()
    
    @StateObject private var journalViewModel = JournalViewModel()
    // Setup Firebase connection when the app is launched
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch session.state {
                case .loggedIn:
                    ContentView()
                        .environmentObject(session)
                        .environmentObject(boardViewModel)
                        .environmentObject(journalViewModel)
                case .loggedOut:
                    LoginView()
                }
            }
        }
    }
}

// Reference:
// App Icon Creator: https://www.youtube.com/watch?v=ezy0UpfUNrs&ab_channel=tundsdev
