//
//  ConverterParseResult.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation

class ConverterParseResult: Codable {

    let date: String?
    let info: Info?
    let query: Query?
    let result: Double?
    let success: Bool
    let error: Error?

    struct Info: Codable {
        let rate: Double
        let timestamp: Int
    }

    struct Query: Codable {
        let amount: Int
        let from, to: String
    }

    struct Error: Codable {
        let code: Int
        let type, info: String
    }
}

extension ConverterParseResult: CustomStringConvertible {

    var description: String {
        ["Converted", "\(query?.amount ?? 0)", query?.from, "to", query?.to, "\nNew Currency is", query?.to, "\(result ?? 0.0)", "\nConversion rate is", "\(info?.rate ?? 0.0)"]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}
