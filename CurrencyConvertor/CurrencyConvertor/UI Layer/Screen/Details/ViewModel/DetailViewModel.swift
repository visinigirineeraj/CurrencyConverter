//
//  DetailViewModel.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.//

import Foundation
import Combine

final class DetailViewModel {
    
    let onFetchTopCurrencies: PassthroughSubject<Void, Never> = PassthroughSubject()
    var convertedCurrencies: [String: [DetailModel]]
    let topConvertedCurrencies: [String: [DetailModel]] = [:]
    let dataSourceKeys: [String]
    let converterExecuter: CurrencyConverterExecuter
    
    private let topCountryCurrencies: [String] = ["RUB", "SAR"]
    private weak var detailModel: DetailModel?
    private let dispatchGroup = DispatchGroup()
    
    init(currencies: [String: [ConverterParseResult]], converterExecuter: CurrencyConverterExecuter) {
        self.dataSourceKeys = currencies.keys.sorted { $0 < $1 }
        self.converterExecuter = converterExecuter
        convertedCurrencies = [:]
        for element in dataSourceKeys {
            convertedCurrencies[element] = currencies[element]?.map { .init($0) } ?? []
        }
    }
    
    func getChartDataSource() -> [(String, Int)] {
        dataSourceKeys.map { ($0, convertedCurrencies[$0]?.count ?? 0)}
    }
    
    func fetchTopCountryCurrencies(for element: DetailModel) {
       
        guard let inputAmount = element.model.query?.amount, let inputCurrency = element.model.query?.to else { return }
        
        for toCountryCurrency in topCountryCurrencies {
            fetchNewCurrencyRates(for: element, toCountryCurrency: toCountryCurrency, inputCurrency: inputCurrency, inputAmount: "\(inputAmount)")
        }
        
        dispatchGroup.notify(queue: .main) { [weak onFetchTopCurrencies] in
            onFetchTopCurrencies?.send()
        }
    }
    
    private func fetchNewCurrencyRates(for element: DetailModel, toCountryCurrency: String, inputCurrency: String, inputAmount: String) {
        dispatchGroup.enter()
        converterExecuter.execute(input: ConverterInput(convertTo: toCountryCurrency, convertFrom: inputCurrency, amount: inputAmount)) { [weak dispatchGroup] parsedResult in
            guard parsedResult.success else { return }
            element.topConvertedCurrenciesModel.append(parsedResult)
            dispatchGroup?.leave()
        } failure: { [weak dispatchGroup] error in
            print(error.localizedDescription)
            dispatchGroup?.leave()
        }
    }
}
