//
//  Plist.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.
//

import Foundation

enum FileError: Error {
    case notFound
    case dataInconsistency
}

enum StorageType: String {
    case plist
}

struct Plist<Value: Decodable> {

    let data: Value

    init(fileName: String, bundle: Bundle = Bundle.main) throws {

        guard let path = bundle.path(forResource: fileName, ofType: StorageType.plist.rawValue) else { throw FileError.notFound }

        let rawData = try Data(contentsOf: URL(fileURLWithPath: path))

        let decoder = PropertyListDecoder()

        data = try decoder.decode(Value.self, from: rawData)
    }
}
