//
//  ParseOperation.swift
//  ParseOperation
//
//  Created by byndr on 04/12/22.
//

import Foundation
import Combine

class NetworkOperation<Endpoint: APIEndpoint>: BaseOperation {
    
        // MARK: Properties
    
    private let apiClient: NetworkManager
    private let endpoint: Endpoint
    private var subscriber: AnyCancellable?
    var response: Data?
    var error: Error?
    
    // MARK: LifeCycle
    
    init(apiClient: NetworkManager, endpoint: Endpoint) {
        self.apiClient = apiClient
        self.endpoint = endpoint
    }
    
    override func main() {
        Task() {
            subscriber = await apiClient.requestData(endpoint: endpoint).sink { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.error = error
                }
                self?.state = .isFinished
            } receiveValue: { [weak self] data in
                self?.response = data
                self?.state = .isFinished
            }
        }
    }
}
