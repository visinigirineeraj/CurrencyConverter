//
//  LoaderProtocol.swift
//  CurrencyConverter
//
//  Created by Krishna Kishore on 24/11/22.
//

import UIKit

private var loaderCount = 0

protocol LoaderProtocol: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView { get set }
}

extension LoaderProtocol {
    
    func showLoader() {
        Task { @MainActor in
            loaderCount += 1
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoader() {
        Task { @MainActor in
            loaderCount -= 1
            activityIndicator.stopAnimating()
            if loaderCount < 0 {
                loaderCount = 0
            }
        }
    }
}
