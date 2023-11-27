import SwiftUI

struct CustomButtonView: View {
    // For button actions
    typealias ActionHandler = () -> Void
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius : CGFloat = 10
    
    internal init(title: String,
                  background: Color = .blue,
                  foreground: Color = .white,
                  border: Color = .clear,
                  handler: @escaping CustomButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 50)
        })
        .background(background)
        .foregroundColor(foreground)
        .cornerRadius(cornerRadius)
        .font(.system(size: 20, weight: .bold))
        .overlay(RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(border,lineWidth: 2)
        )
    }
}

struct CustomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        // {} is us adding our handler
        
        Group {
            CustomButtonView(title: "Primary Button") {}
                .preview(with: "Primary Button View")
            CustomButtonView(title: "Second Primary Button") {}
                .preview(with: "2nd Primary Button View")
        }
    }
}

// REFERENCES:
// CUSTOM PARTS: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
//https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
