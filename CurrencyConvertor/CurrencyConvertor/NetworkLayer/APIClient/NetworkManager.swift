//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation
import Combine

final class NetworkManager {

    private let baseURL: URL
    private let apiKey: String

    init(baseURL: String, apiKey: String) {
        guard let baseURL = URL(string: baseURL) else { fatalError("unable to load base url") }
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    private func getUrlRequest<Endpoint: APIEndpoint>(from endpoint: Endpoint) -> URLRequest {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else { fatalError("Unable to prepare access the url") }
        var urlRequest = URLRequest(url: url, timeoutInterval: 120)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "apikey")
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        return urlRequest
    }

    func requestData<Endpoint: APIEndpoint>(endpoint: Endpoint) async -> AnyPublisher<Data, APIError> {
        URLSession.shared.dataTaskPublisher(for: getUrlRequest(from: endpoint))
            .map { $0.data }
            .mapError { _ in APIError.invalidServerResponse }
            .eraseToAnyPublisher()
    }
}
