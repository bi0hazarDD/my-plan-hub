
import SwiftUI

struct CustomPasswordView: View {
    
    @Binding var password: String
    let placeholder: String
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 40
    
    var body: some View {
        SecureField(placeholder, text: $password)
            .frame(maxWidth: .infinity, minHeight: 44)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
            .background(
                ZStack(alignment: .leading) {
                    if let systemImage = sfSymbol {
                        Image(systemName: systemImage)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 5)
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                    
                    RoundedRectangle(cornerRadius: 10,
                                     style: .continuous)
                        .stroke(Color.black.opacity(0.30))
                }
            )
    }
}

struct CustomPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPasswordView(password: .constant(""),
                          placeholder: "Password",
                          sfSymbol: "lock")
        .preview(with: "Input password with sf symbol")
        
        CustomPasswordView(password: .constant(""),
                          placeholder: "Password",
                          sfSymbol: nil)
        .preview(with: "Input password without sf symbol")
    }
}

// REFERENCES:
// CUSTOM PARTS: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
//https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
