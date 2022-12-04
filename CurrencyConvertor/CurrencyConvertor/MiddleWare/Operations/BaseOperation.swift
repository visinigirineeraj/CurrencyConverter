//
//  BaseOperation.swift
//  BaseOperation
//
//  Created by byndr on 04/12/22.
//

import Foundation

class BaseOperation: Operation {
    
    // MARK: - Public Properties -
    
    var state: State = .isReady {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    // MARK: - Override properties -
    
    override var isReady: Bool { super.isReady && state == .isReady }
    
    override var isFinished: Bool { state == .isFinished }
    
    override var isExecuting: Bool { state == .isExecuting }
    
    override var isAsynchronous: Bool { true }
}

// MARK: - Override Methods -

extension BaseOperation {
    
    override func start() {
        guard !isCancelled else { return }
        
        main()
        state = .isExecuting
    }
    
    override func cancel() {
        super.cancel()
        
        state = .isFinished
    }
}

// MARK: - State -

extension BaseOperation {
    enum State: String {
        case isReady, isExecuting, isFinished
        var keyPath: String { rawValue }
    }
}
