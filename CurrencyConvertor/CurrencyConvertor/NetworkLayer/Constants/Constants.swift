//
//  Constants.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation

typealias JSONObject = [String: Any]
typealias HTTPHeaders = [String: String]
typealias APIDataSuccessCompletion = ((Data) -> Void)
typealias APIFailureCompletion = ((Error) -> Void)
typealias ErrorCallback = Callback<Error>
typealias Callback<Model: Any> = ((Model) -> Void)

typealias CurrencyConverterExecuter = NetworkExecuter<ConverterEndPoint, ConverterParseResult>

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum APIError: Error, LocalizedError {
    
    case invalidServerResponse
    case unknown
    case runtimeError(String)

    var errorDescription: String? {
        switch self {
            case .unknown:
                return "Unknown error"
            case .invalidServerResponse:
                return "Invalid Server Response"
            case .runtimeError(let message):
                return message
        }
    }
}

enum ParseError: Error {
    case emptyData
    case incorrectData
}
