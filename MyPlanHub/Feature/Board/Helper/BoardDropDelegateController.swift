import Foundation
import SwiftUI

struct BoardDropDelegateController: DropDelegate {
    // Binding of the lists array from the board object. when we change this, the view will get updated
    @Binding var lists: [BoardList]?
    // Current boardlist that the user will be dragging.
    @Binding var currentBoardList: BoardList?
    
    
    let board: Board
    let boardList: BoardList
    
    private func itemProviderForCard(info: DropInfo) -> [NSItemProvider] {
        // This drop delegate can accept multiple types of identifiers.
        // Essentially, this can also be used for a BoardList.type_identifier when it is necesssary to reorder board lists in the main Board view.
        info.itemProviders(for: [Card.type_identifier])
        
    }
    private func itemProviderForBoardList(info: DropInfo) -> [NSItemProvider] {
        info.itemProviders(for: [BoardList.type_identifier])
    }
    // Drop delegate protocol method implementation
    func dropUpdated(info: DropInfo) -> DropProposal? {
        if !itemProviderForCard(info: info).isEmpty {
            // the user is currently dragging a card
            return DropProposal(operation: .copy)
        } else if !itemProviderForBoardList(info: info).isEmpty {
            // No green plus button will be shown when moving a board list because we are not trying to create nested board lists, simply rearrange them on the view. so the DropOperation .move is used instead of .copy
            return DropProposal(operation: .move)
        } else {
            // user not dragging a card
            return nil
        }
    }
    
    // Implementing the dropEntered method from the DropDelegate Protocol for the board lists.
    // This method will be triggered when the dragged item enters the dropped area, i.e., when the user drags a board list and it enters a section in the board view BEFORE the view is dropped, dropEntered will be invoked with the necessary info.
    // Drop delegate protocol
    func dropEntered(info: DropInfo) {
        // make sure that the user is dragging a board list using a guard statement
        // also check to make sure that currentBoardList exists and that the destination is not the source board List
        guard
            !itemProviderForBoardList(info: info).isEmpty,
            let current = currentBoardList,
            boardList != current,
            let initialIndex = lists?.firstIndex(of: current),
            let finalIndex = lists?.firstIndex(of: boardList)
        else {
            return
        }
        // after checking all the information from our guard close we can use it to complete the move of the boardList
        lists?.move(fromOffsets: IndexSet(integer: initialIndex), toOffset: finalIndex > initialIndex ? finalIndex + 1 : finalIndex)
            
    }
    
    // Implementing the performDrop method from the DropDelegate Protocol
    // When performing a drop action on a board list header view, perform the function below. Card will be added to the destination board list.
    func performDrop(info: DropInfo) -> Bool {
        let cardItemProviders = itemProviderForCard(info: info)
        for cardItemProvider in cardItemProviders {
            cardItemProvider.loadObject(ofClass: Card.self) { NSItem, _ in
                guard let card = NSItem as? Card,
                      // To ensure the user is not dropping to the same board list view.
                      card.boardListID != boardList.id
                else {return}
                DispatchQueue.main.async {
                    // Insert to the first index.
                    board.transferCard(card: card, to: boardList, at: 0)
                }
            }
        }
        self.currentBoardList = nil
        return true
    }
}

// References:
// Drag and Drop tutorial: https://www.kodeco.com/21679742-drag-and-drop-tutorial-for-swiftui
// DropInfo documentation: https://developer.apple.com/documentation/swiftui/dropinfo
// Drag and drop in SwiftUI: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
// How to support drag and drop in SwiftUI: https://www.hackingwithswift.com/quick-start/swiftui/how-to-support-drag-and-drop-in-swiftui
