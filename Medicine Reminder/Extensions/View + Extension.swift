//
//  View + Extension.swift
//  Medicine Reminder
//
//  Created by BJIT on 8/7/23.
//

import Foundation
import SwiftUI

extension View {
    func alertTF(title: String, value: Int16, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (Int16) -> (), secondaryAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField { field  in
            field.keyboardType = .numberPad
            field.text = "\(value)"
        }
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                if let number = Int16(text){
                    primaryAction(number)
                }
            } else {
                primaryAction(1)
            }
        }))
        
        rootController().present(alert, animated: true, completion: nil)
    }
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
