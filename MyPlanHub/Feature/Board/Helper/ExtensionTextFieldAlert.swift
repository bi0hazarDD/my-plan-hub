
import Foundation
import SwiftUI
import UIKit

extension View {
    
    func showTextFieldToast(title: String, message: String? = nil, placeholder: String? = nil, confirmAction: @escaping (String?) -> ()) {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                        .keyWindow?
                        .rootViewController else { return }
                
                let UIKitAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                UIKitAlertController.addTextField { textField in
                    textField.text = placeholder
                }
                UIKitAlertController.addAction(.init(title: "Cancel", style: .cancel) { _ in })
                UIKitAlertController.addAction(.init(title: "Confirm", style: .default, handler: { _ in
                    guard let textField = UIKitAlertController.textFields?.first else { return }
                    confirmAction(textField.text)
                }))
                rootViewController.present(UIKitAlertController, animated: true, completion: nil)
    }
}

//References
//UIApplication: https://stackoverflow.com/questions/68387187/how-to-use-uiwindowscene-windows-on-ios-15
// UIApplicaiton, UIAlertController,UIKit: https://www.youtube.com/watch?v=Of_20rSjk7Y&list=LL&index=19&ab_channel=XcodingwithAlfian
