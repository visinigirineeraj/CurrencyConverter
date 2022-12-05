//
//  UITextField+Extension.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import UIKit
import Combine

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidEndEditingNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }

    func addToolBar() {
        let toolBar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }

    @objc private func tapDone() {
        endEditing(true)
    }
}
