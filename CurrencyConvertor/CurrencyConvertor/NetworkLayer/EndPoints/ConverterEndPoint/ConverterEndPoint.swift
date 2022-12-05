//
//  ConverterEndPoint.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation

struct ConverterInput {
    let convertTo, convertFrom, amount: String
}

struct ConverterEndPoint: APIEndpoint {

    typealias InputType = ConverterInput

    var parameters: JSONObject?
    var headers: HTTPHeaders?
    var input: ConverterInput
    var method: HTTPMethod { .get }

    var path: String { "convert?to=\(input.convertTo)&from=\(input.convertFrom)&amount=\(input.amount)" }

    init(input: ConverterInput) {
        self.input = input
    }
}
