//
//  FormatterHelperTests.swift
//  CashAppStocksTests
//
//  Created by Luis Perez on 7/30/25.
//

import XCTest
@testable import CashAppStocks

final class FormatterHelperTests: XCTestCase {
    
    func testFormatPrice() {
        XCTAssertEqual(FormatterHelper.formatPrice(123.456), "$123.46")
        XCTAssertEqual(FormatterHelper.formatPrice(0), "$0.00")
    }
    
    func testFormatDate() {
        let timestamp: TimeInterval = 1607897600
        let formatted = FormatterHelper.formatDate(from: timestamp)
        XCTAssertEqual(formatted, "Dec 13, 2020 at 4:13 PM")
    }
}
