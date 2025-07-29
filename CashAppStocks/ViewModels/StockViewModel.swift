//
//  StockViewModel.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import Foundation

class StockViewModel {
   
    let stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    var displayName: String {
        return self.stock.name
    }
    
    var displaySymbol: String {
        return self.stock.ticker
    }
    
    var displayPrice: String {
        let price = Double(stock.currentPriceCents) / 100
        return FormatterHelper.formatPrice(price)
    }
    
    var displayQuantity: String {
        guard let quantity = stock.quantity else {
            return "Qty: N/A"
        }
        return "Qty: \(quantity)"
    }
    
    var formattedDate: String {
        return FormatterHelper.formatDate(from: TimeInterval(stock.currentPriceTimestamp))
    }
}
