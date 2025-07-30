//
//  LoadableState.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import Foundation

// MARK: - Generic Loadable State

enum LoadableState<T> {
    case loading
    case loaded(T)
    case empty
    case error(Error)
}


extension LoadableState {
    var value: T? {
        if case .loaded(let v) = self { return v }
        return nil
    }

    var error: Error? {
        if case .error(let e) = self { return e }
        return nil
    }
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
    
    var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }
    
    var isError: Bool {
        if case .error = self { return true }
        return false
    }
}
