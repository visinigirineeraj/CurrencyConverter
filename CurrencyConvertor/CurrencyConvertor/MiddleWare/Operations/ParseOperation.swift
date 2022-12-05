//
//  ParseOperation.swift
//  ParseOperation
//
//  Created by byndr on 04/12/22.
//

import Foundation

class ParseOperation<ParseResult: Decodable>: BaseOperation {

    // MARK: Properties
    var inputData: Data?
    var parseResult: ParseResult?
    var error: Error?

    // MARK: LifeCycle
    override func main() {

        guard let inputData = inputData else {
            error = ParseError.emptyData
            state = .isFinished
            return
        }

        guard !isCancelled else { return }

        do {
            try parseResult = JSONDecoder().decode(ParseResult.self, from: inputData)
        } catch {
            print("Model Type: \(ParseResult.self)\n\(error as NSError)")
            self.error = error
        }
        state = .isFinished
    }
}
