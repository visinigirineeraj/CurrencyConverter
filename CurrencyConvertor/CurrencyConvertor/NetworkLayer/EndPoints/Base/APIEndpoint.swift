//
//  APIEndpoint.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation

protocol APIEndpoint {

    associatedtype InputType

    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: JSONObject? { get }
    var headers: HTTPHeaders? { get }
    var input: InputType { get set }

    init(input: InputType)
}

extension APIEndpoint {

    var method: HTTPMethod {
        return .post
    }

    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
}
