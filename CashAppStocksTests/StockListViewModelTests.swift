//
//  StockListViewModelTests.swift
//  CashAppStocksTests
//
//  Created by Luis Perez on 7/30/25.
//

import XCTest
import Combine
@testable import CashAppStocks


final class StockListViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    func makeStock(ticker: String, name: String) -> Stock {
        return Stock(
            ticker: ticker,
            name: name,
            currency: "USD",
            currentPriceCents: 100_00,
            quantity: 10,
            currentPriceTimestamp: Int(Date().timeIntervalSince1970)
        )
    }

    func test_loadStocks_successful() async {
        let stock = makeStock(ticker: "AAPL", name: "Apple Inc.")
        let mockService = MockStockService(result: .success([stock]))
        let viewModel = StockListViewModel(stockService: mockService)

        await viewModel.loadStocks()

        XCTAssertTrue(viewModel.state.isLoaded)
        XCTAssertEqual(viewModel.stocks.count, 1)
        XCTAssertEqual(viewModel.stocks.first?.displaySymbol, "AAPL")
    }

    func test_loadStocks_emptyResult() async {
        let mockService = MockStockService(result: .success([]))
        let viewModel = StockListViewModel(stockService: mockService)

        await viewModel.loadStocks()

        XCTAssertTrue(viewModel.state.isEmpty)
    }

    func test_loadStocks_errorResult() async {
        let mockService = MockStockService(result: .failure(CANetworkError.invalidResponse(statusCode: 500)))
        let viewModel = StockListViewModel(stockService: mockService)

        await viewModel.loadStocks()

        XCTAssertTrue(viewModel.state.isError)
    }

    func test_searchQuery_filtersCorrectly() async {
        let apple = makeStock(ticker: "AAPL", name: "Apple Inc.")
        let tesla = makeStock(ticker: "TSLA", name: "Tesla Motors")
        let mockService = MockStockService(result: .success([apple, tesla]))
        let viewModel = StockListViewModel(stockService: mockService)

        await viewModel.loadStocks()

        let expectation = XCTestExpectation(description: "Search should update state")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if let filtered = state.value {
                    XCTAssertEqual(filtered.count, 1)
                    XCTAssertEqual(filtered.first?.displaySymbol, "TSLA")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.searchQuery = "tsla"
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func test_searchQuery_returnsEmptyStateIfNoMatch() async {
        let apple = makeStock(ticker: "AAPL", name: "Apple Inc.")
        let mockService = MockStockService(result: .success([apple]))
        let viewModel = StockListViewModel(stockService: mockService)

        await viewModel.loadStocks()

        let expectation = XCTestExpectation(description: "Should hit empty state")

        viewModel.$state
            .dropFirst()
            .sink { state in
                XCTAssertTrue(state.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.searchQuery = "zzz"
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
