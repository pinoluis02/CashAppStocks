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
