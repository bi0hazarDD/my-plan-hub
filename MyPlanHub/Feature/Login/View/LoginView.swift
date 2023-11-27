
import SwiftUI

struct LoginView: View {
    // Initializing bool vars for sheets
    @State private var showRegistrationSheet = false
    @State private var showForgotPasswordSheet = false
    // initializing the service controller and constructor
    @StateObject private var vm = LoginViewModelController(service: LoginServiceController())
    
    var body: some View {
        // Background color green, with a rounded rectangle shape implemented using various modifiers for a professional look.
        ZStack {
            Color.green
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.white, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 10000, height: 500)
                .rotationEffect(.degrees(45))
    
            
            VStack(spacing: 20) {
                
                Text("Welcome")
                    .foregroundColor(.gray)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .offset(x: -90, y: -50)
                // Use of custom view components
                VStack(spacing:20) {
                    
                    CustomTextFieldView(
                        text: $vm.credentials.email,
                        placeholder: "Email",
                        keyboardType: .emailAddress,
                        sfSymbol: "envelope")
                    
                    CustomPasswordView(
                        password: $vm.credentials.password,
                        placeholder: "Password",
                        sfSymbol: "lock")
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            showForgotPasswordSheet.toggle()
                        }, label: {
                            Text("Forgot Password?")
                        })
                        .font(.system(size: 16, weight: .bold))
                        .sheet(isPresented: $showForgotPasswordSheet, content: {
                            ForgotPasswordView()
                        })
                    }
                    
                    CustomButtonView(title: "Login") {
                        vm.login()
                    }
                    
                    CustomButtonView(
                        title: "Register",
                        background: .white,
                        foreground: .blue,
                        border: .blue) {
                            
                            showRegistrationSheet.toggle()
                    }
                        .sheet(isPresented: $showRegistrationSheet, content: {
                            RegisterView()
                        })
                } // End of VStack
                .padding(.horizontal, 15)
                .navigationTitle("MyPlanHub")
                // if $hasError is true, then we use content and closure to
                // check our state enum using case (initialized as case) and casting it,
                // if there is some issue with the casting of our state we return something generally went wrong.
                // If the user enters incorrect login details we used the localizedDescription of the error which comes from the Firebase Authentication service framework.
                .alert(isPresented: $vm.errorReceived,
                       content: {
                    if case .failed(let error) = vm.state {
                        return Alert(
                            title: Text("Sorry, something's not quite right."),
                            message: Text(error.localizedDescription))
                    } else {
                        return Alert(
                            title: Text("Fatal Error"),
                            message: Text("Something went wrong!"))
                    }
                })
                
                
            }
            .frame(width: 350)
            .offset(y:-50)
        } // end of ZStack
        .ignoresSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView() {
            LoginView()
        }
    }
}
