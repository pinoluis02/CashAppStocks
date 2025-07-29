//
//  StockServiceFactory.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import Foundation

enum StockServiceFactory {
    
    //Central config — change this to switch endpoint across the app
    static var defaultConfig: StockEndpoint = .portofolio

    static func make() -> StockServiceProtocol {
        return StockService(endpoint: defaultConfig)
    }
}
