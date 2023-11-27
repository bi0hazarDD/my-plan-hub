
import SwiftUI

struct RegisterView: View {
    
    @StateObject private var registerVM = RegistrationViewModelController(service: RegistrationServiceController())
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                
                VStack(spacing: 16) {
                    // Binding the view model and access userDetails and access email within our struct.
                    CustomTextFieldView(text: $registerVM.userDetails.email,
                                       placeholder: "Email",
                                       keyboardType: .emailAddress,
                                       sfSymbol: "envelope")
                    
                    CustomPasswordView(password: $registerVM.userDetails.password,
                                      placeholder: "Password",
                                      sfSymbol: "lock")
                    
                    Divider()
                    
                    CustomTextFieldView(text: $registerVM.userDetails.firstName,
                                       placeholder: "First Name",
                                       keyboardType: .namePhonePad,
                                       sfSymbol: nil)
                    
                    CustomTextFieldView(text: $registerVM.userDetails.lastName,
                                       placeholder: "Last Name",
                                       keyboardType: .namePhonePad,
                                       sfSymbol: nil)
                    
                    CustomTextFieldView(text: $registerVM.userDetails.occupaiton,
                                       placeholder: "Occupation, e.g., Student",
                                       keyboardType: .namePhonePad,
                                       sfSymbol: nil)
                }
                
                CustomButtonView(title: "Sign up") {
                    registerVM.register()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("Register")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("navBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .applyClose()
            
            // if $hasError is true, then we use content and closure to
            // check our state enum using case (initialized as case) and casting it,
            // if there is some issue with the casting of our state enum we return something generally went wrong.
            // If the user submits empty fields, use the localizedDescription of the error which is made into a general description by the NotificationCenter Foundation package in SwiftUI
            .alert(isPresented: $registerVM.hasError,
                   content: {
                if case .failed(let error) = registerVM.state {
                    return Alert(
                        title: Text("Sorry, that's not quite right."),
                        message: Text(error.localizedDescription))
                } else {
                    return Alert(
                        title: Text("Fatal Error"),
                        message: Text("Something went wrong!"))
                }
            })
            
        }
    }
}
// REFERENCES:
// COMBINE, FOUNDATION: https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
