

import SwiftUI

struct CardItemView: View {
    
    @EnvironmentObject private var vm : BoardViewModel
    
    // Passing in the boardList, acting as a Binding in this case
    @ObservedObject var boardList: BoardList
    // This state object 'card' will be managed and owned by this card view directly
    @StateObject var card: Card
    
    var body: some View {
        HStack {
            Text(self.card.cardContent)
                .lineLimit(4)
            Spacer()
            Menu {
                Button {
                    editItemContent()
                } label: {
                    Text("Edit item content")
                }
                
                Button("Delete item", role: .destructive) {
                    boardList.removeExistingCardItem(card)
                    
                }
                // end of Menu
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .imageScale(.small)
                    .foregroundColor(.secondary)
                    
            }

        } // end of HStack
        
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(.white)
        .cornerRadius(6)
        .shadow(radius: 1, y:1)
        
    }
    // Making use of the toast text field to return a string of content that gets saved to the card content property
    private func editItemContent() {
        showTextFieldToast(title: "Editing Card", placeholder: card.cardContent) { text in
            guard let text = text, !text.isEmpty else {return}
            card.cardContent = text
        }
    }
}

// UI, UX, Design Infrastructure: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
