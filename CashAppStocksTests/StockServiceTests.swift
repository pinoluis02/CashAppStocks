//
//  StockServiceTests.swift
//  CashAppStocksTests
//
//  Created by Luis Perez on 7/30/25.
//

import XCTest
@testable import CashAppStocks

final class StockServiceTests: XCTestCase {
    
    // Using StockEndpoint.portofolio
    func testFetchPortfolioSuccess() async throws {
        let service = StockService(endpoint: .portofolio)
        let stocks = try await service.fetchPortofolio()
        XCTAssertFalse(stocks.isEmpty, "Expected non-empty stocks list")
    }
    
    // Using StockEndpoint.portofolioEmpty which returns an Empty JSON
    func testFetchPortfolioEmpty() async throws {
        let service = StockService(endpoint: .portofolioEmpty)
        let stocks = try await service.fetchPortofolio()
        XCTAssertTrue(stocks.isEmpty, "Expected empty stocks list")
    }
    
    // Using StockEndpoint.portofolioMalformed which returns a malformed JSON
    func testFetchPortfolioMalformedThrows() async {
        let service = StockService(endpoint: .portofolioMalformed)
        do {
            _ = try await service.fetchPortofolio()
            XCTFail("Expected decoding error to be thrown")
        } catch let error as CANetworkError {
            switch error {
            case .decodingFailed:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected decodingFailed, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchSuccess() async throws {
        let sampleStock = Stock(ticker: "AAPL", name: "Apple", currency: "USD", currentPriceCents: 15000, quantity: 2, currentPriceTimestamp: 1681845832)
        let mockService = MockStockService(result: .success([sampleStock]))
        
        let result = try await mockService.fetchPortofolio()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.ticker, "AAPL")
    }
    
    func testFetchFailure() async {
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        let mockService = MockStockService(result: .failure(mockError))
        
        do {
            _ = try await mockService.fetchPortofolio()
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual((error as NSError).domain, "TestError")
        }
    }
}

class MockStockService: StockServiceProtocol {
    var result: Result<[Stock], Error>

    init(result: Result<[Stock], Error>) {
        self.result = result
    }

    func fetchPortofolio() async throws -> [Stock] {
        return try result.get()
    }
}
