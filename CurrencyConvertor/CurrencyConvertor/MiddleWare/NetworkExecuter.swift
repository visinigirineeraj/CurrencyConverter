//
//  NetworkExecuter.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation

class NetworkExecuter<Endpoint: APIEndpoint, ParseResult: Decodable> {
    
    typealias SuccessBlock = Callback<ParseResult>
    typealias FailureBlock = ErrorCallback
    
        // MARK: Properties
    private let operationQueue: OperationQueue
    private let apiClient: NetworkManager
    
        // MARK: LifeCycle
    init(apiClient: NetworkManager) {
        self.operationQueue = OperationQueue()
        self.operationQueue.qualityOfService = .utility
        self.apiClient = apiClient
    }
    
    deinit {
        cancel()
    }
    
        // MARK: Public methods
    func cancel() {
        operationQueue.cancelAllOperations()
    }
    
    func execute(input: Endpoint.InputType, success: SuccessBlock?, failure: FailureBlock?) {
        let endpoint = Endpoint(input: input)
        let networkOperation = NetworkOperation(apiClient: apiClient, endpoint: endpoint)
        let parseBlockOperation = ParseOperation<ParseResult>()
        
        let networkBlockOperation = BlockOperation { [unowned networkOperation, unowned parseBlockOperation] in
            if let error = networkOperation.error {
                parseBlockOperation.cancel()
                failure?(error)
            } else {
                parseBlockOperation.inputData = networkOperation.response
            }
        }
        
        parseBlockOperation.completionBlock = { [unowned parseBlockOperation] in
            guard !parseBlockOperation.isCancelled else { return }
            
            if let parseResult = parseBlockOperation.parseResult {
                success?(parseResult)
            } else if let error = parseBlockOperation.error {
                failure?(error)
            } else {
                failure?(ParseError.emptyData)
            }
        }
        
        networkBlockOperation.addDependency(networkOperation)
        parseBlockOperation.addDependency(networkBlockOperation)
        
        operationQueue.addOperations([networkOperation, networkBlockOperation, parseBlockOperation], waitUntilFinished: false)
    }
}
