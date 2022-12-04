//
//  AlertMessageProtocol.swift
//  CurrencyConverter
//
//  Created by Krishna Kishore on 24/11/22.
//

import UIKit

protocol AlertMessagesProtocol: UIViewController { }

extension AlertMessagesProtocol {

    func showAlertwithTitle(title: String = "", message: String, actions: [UIAlertAction]? = nil) {
        Task { @MainActor in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            if let actions = actions {
                actions.forEach { (action) in
                    alertController.addAction(action)
                }
            } else {
                alertController.addAction(cancelAction)
            }
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func showError(_ error: Error?) {
        showAlertwithTitle(title: "Error", message: error?.localizedDescription ?? "Unable to reach our servers. Please try again.")
    }
}

