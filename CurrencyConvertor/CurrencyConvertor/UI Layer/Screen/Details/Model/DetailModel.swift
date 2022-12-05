//
//  DetailModel.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.//

import Foundation

final class DetailModel {
    
    let model: ConverterParseResult
    var topConvertedCurrenciesModel: [ConverterParseResult]
    
    init(_ model: ConverterParseResult) {
        self.model = model
        topConvertedCurrenciesModel = []
    }
}
