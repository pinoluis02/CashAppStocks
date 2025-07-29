//
//  FormatterHelper.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/29/25.
//

import Foundation

final class FormatterHelper {
    
    // MARK: - Price
    static func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "$"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
    
    // MARK: - Dates
    static func formatDate(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
