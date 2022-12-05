//
//  HomeViewModel.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation
import Combine

final class HomeViewModel {
    
    var convertedCurrency: PassthroughSubject<Result<Double, Error>, Never> = PassthroughSubject()
    let currencyCodes = ["USD", "INR", "AUD", "SGD", "MYR", "HKD", "JPY", "AED", "ZWL"]
    var convertedCurrencies: [ConverterParseResult] = []
    
    let conveterExecuter: CurrencyConverterExecuter
    
    init(apiClient: NetworkManager) {
        conveterExecuter = CurrencyConverterExecuter(apiClient: apiClient)
    }
    
    func getGroupedCurrencies() -> [String: [ConverterParseResult]]{
        Dictionary(grouping: convertedCurrencies.sorted { ($0.info?.timestamp ?? 0) < ($1.info?.timestamp ?? 0)}, by: { $0.date ?? ""})
    }
    
    func convert(inputCurrency: String, convertCurrency: String, inputAmount: String) {
        conveterExecuter.execute(input: ConverterInput(convertTo: convertCurrency, convertFrom: inputCurrency, amount: inputAmount)) { [weak self] parsedResult in
            if let result = parsedResult.result {
                self?.convertedCurrencies.append(parsedResult)
                self?.convertedCurrency.send(.success(result))
            } else if let info = parsedResult.error?.info {
                self?.convertedCurrency.send(.failure(APIError.runtimeError(info)))
            } else {
                self?.convertedCurrency.send(.failure(APIError.unknown))
            }
        } failure: { [weak self] error in
            self?.convertedCurrency.send(.failure(error))
        }
    }
}
