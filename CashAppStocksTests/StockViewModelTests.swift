//
//  StockViewModelTests.swift
//  CashAppStocksTests
//
//  Created by Luis Perez on 7/30/25.
//

import XCTest
@testable import CashAppStocks

final class StockViewModelTests: XCTestCase {

    func testDisplayFields() {
        let stock = Stock(
            ticker: "AAPL",
            name: "Apple Inc.",
            currency: "USD",
            currentPriceCents: 12345,
            quantity: 10,
            currentPriceTimestamp: 1607897600
        )
        
        let viewModel = StockViewModel(stock: stock)
        
        XCTAssertEqual(viewModel.displayName, "Apple Inc.")
        XCTAssertEqual(viewModel.displaySymbol, "AAPL")
        XCTAssertEqual(viewModel.displayPrice, "$123.45")
        XCTAssertEqual(viewModel.displayQuantity, "Qty: 10")
        XCTAssertEqual(viewModel.quantity, 10)
        XCTAssertEqual(viewModel.currency, "USD")
        XCTAssertEqual(viewModel.formattedDate, "Dec 13, 2020 at 4:13 PM")
    }

    func testDisplayQuantityUnavailable() {
        let stock = Stock(
            ticker: "GOOG",
            name: "Alphabet",
            currency: "USD",
            currentPriceCents: 9999,
            quantity: nil,
            currentPriceTimestamp: 1600000000
        )
        
        let viewModel = StockViewModel(stock: stock)
        
        XCTAssertEqual(viewModel.displayQuantity, "Qty: unavailable")
        XCTAssertEqual(viewModel.quantity, 0)
    }
}
