import SwiftUI
// Main navigation view displayed throughout the application, however it is hidden in the board view.
struct TabNavigationView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book.fill")
                }
            InfoView()
                .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                }
        }
    }
}

