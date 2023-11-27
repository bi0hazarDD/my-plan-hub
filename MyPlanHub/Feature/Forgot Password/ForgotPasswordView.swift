
import SwiftUI

struct ForgotPasswordView: View {
    // presentationMode var to allow the dismissal of the sheet, as this ForgotPasswordView will be featured in a sheet on the Login page.
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = ForgotPasswordViewModelController(service: ForgotPasswordServiceController())
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                
                CustomTextFieldView(
                    text: $vm.email,
                    placeholder: "Email",
                    keyboardType: .emailAddress,
                    sfSymbol: "envelope")
                // reset password action happens in the button here
                CustomButtonView(title: "Send Password Reset") {
                    vm.sendPasswordReset()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("Reset Password")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("navBackground"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .applyClose()
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
