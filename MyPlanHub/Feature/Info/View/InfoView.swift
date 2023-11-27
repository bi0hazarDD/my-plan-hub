import SwiftUI

struct InfoView: View {
    // initialise session VM for email display and logout function
    @EnvironmentObject var session: SessionServiceViewModelController
    // initialise journal VM for user details display and editable functions
    @EnvironmentObject var journal: JournalViewModel
    @StateObject private var infoVM: InfoViewModel
    // initialize view model properties and inject the session service view model
    init() {
            _infoVM = StateObject(wrappedValue: InfoViewModel(sessionService: SessionServiceViewModelController()))
        }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Account Information")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 32)
                
                VStack(alignment: .leading, spacing: 16) {
                    CustomInfoRow(label: "Email", value: session.userDetails?.email ?? "N/A")
                    CustomEditableInfoRow(label: "First name", value: $infoVM.firstName)
                    CustomEditableInfoRow(label: "Last name", value: $infoVM.lastName)
                    CustomEditableInfoRow(label: "Occupation", value: $infoVM.occupation)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                // update with whatever new changes are entered for user details
                CustomButtonView(title: "Update details") {
                    infoVM.updateInfo()
                }
                .padding(24)
                
                Spacer()
                // have to only reset the local journal notes here, information for notes still saved to each user on the database.
                CustomButtonView(title: "Logout", background: Color.pink) {
                    journal.notes = []
                    logout()
                }
                .padding(24)
            }
            .navigationTitle("Settings")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("navBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .padding(.horizontal, 16)
            .onAppear {
                // populate view model properties with current details of user logged in.
                infoVM.firstName = session.userDetails?.firstName ?? "N/A"
                infoVM.lastName = session.userDetails?.lastName ?? "N/A"
                infoVM.occupation = session.userDetails?.occupation ?? "N/A"
            }
        }
    }
    // logs the user out of the application, redirecting them back to the home screen. User authentication object is nil, therefore the enumstate will be set to 'logged out' in the session view model controller.
    private func logout() {
        session.logout()
    }
    // Reference listed below, guided me on how to refactor out views in a neat fashion in structs, taking in parameters. Editable row allows the user to enter details and the value is binded to a published var in the view model
    struct CustomEditableInfoRow: View {
        var label: String
        @Binding var value: String
        
        var body: some View {
            HStack {
                Text(label)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                TextField("Edit \(label.lowercased())", text: $value)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    // refactored view to simply display some user detail, without any editable features. Used for the email, as not editable for the applications intents and purposes.
    struct CustomInfoRow: View {
        var label: String
        var value: String
        
        var body: some View {
            HStack {
                Text(label)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text(value)
                    .font(.title3)
            }
        }
        
    }
}

//REFERENCE:
// REFACTORING VIEWS: https://www.youtube.com/watch?v=FwGMU_Grnf8&ab_channel=SeanAllen-Build.Ship.Profit.
