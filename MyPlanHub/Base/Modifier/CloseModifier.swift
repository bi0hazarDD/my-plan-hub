
import SwiftUI

struct CloseModifier: ViewModifier {
    
    @Environment(\.presentationMode) var presentationMode
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
            }
    }
}

extension View {
    func applyClose() -> some View {
        self.modifier(CloseModifier())
    }
}

// REFERENCES:
// CUSTOM PARTS: https://www.youtube.com/watch?v=6b2WAePdiqA&ab_channel=LoganKoshenka
//https://www.youtube.com/watch?v=5gIuYHn9nOc&list=LL&index=27&ab_channel=tundsdev
