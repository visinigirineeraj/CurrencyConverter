//
//  Environment.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation

struct Environment: Codable {

    // MARK: Properties
    var baseUrl: String
    var apiKey: String

    // MARK: - Public
    static func loadNetworkConfig() throws -> Environment {
        let plist = try Plist<Environment>(fileName: Constants.fileName)
        return plist.data
    }
}

// MARK: Constants

private extension Environment {

    struct Constants {
        static let fileName = "Environment"
    }
}
