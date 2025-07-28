//
//  Stock.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import Foundation

struct Portofolio: Codable {
    let stocks: [Stock]
}

struct Stock: Codable {
    
    let ticker: String
    let name: String
    let currency: String
    let currentPriceCents: Int
    let quantity: Int?
    let currentPriceTimestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case ticker = "ticker"
        case name = "name"
        case currency = "currency"
        case currentPriceCents = "current_price_cents"
        case quantity = "quantity"
        case currentPriceTimestamp = "current_price_timestamp"
    }
}
