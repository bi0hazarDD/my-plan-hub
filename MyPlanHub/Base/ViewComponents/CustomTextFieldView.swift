
import SwiftUI

struct CustomTextFieldView: View {
    
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        
        
        TextField(placeholder, text: $text)
        
            .frame(maxWidth: .infinity, minHeight: 41)
            .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
            .keyboardType(keyboardType)
            .background(
                ZStack(alignment: .leading) {
                    
                    if let systemImage = sfSymbol {
                        
                        Image(systemName: systemImage)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.leading, 5)
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black.opacity(0.30))
                    
                }
            )
        
    }
}

struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomTextFieldView(text: .constant(""),
                               placeholder: "Email",
                               keyboardType: .emailAddress,
                               sfSymbol: "envelope")
            .preview(with: "Text input with sfSymbol")
            
            CustomTextFieldView(text: .constant(""),
                               placeholder: "First Name",
                               keyboardType: .default,
                               sfSymbol: nil)
            
            .preview(with: "Text input without sfSymbol")
        }
    }
}

// REFERENCES:
// CUSTOM PARTS: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
//https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
