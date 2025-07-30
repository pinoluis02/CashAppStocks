//
//  StockService.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import Foundation

enum StockEndpoint {
    case portofolio
    case portofolioEmpty
    case portofolioMalformed
    
    private static let baseURL = URL(string: "https://storage.googleapis.com/cash-homework/cash-stocks-api")!
    
    var url: URL {
        
        switch self {
        case .portofolio:
            return Self.baseURL.appendingPathComponent("portfolio.json")
        case .portofolioEmpty:
            return Self.baseURL.appendingPathComponent("portfolio_empty.json")
        case .portofolioMalformed:
            return Self.baseURL.appendingPathComponent("portfolio_malformed.json")
        }
    }
}


protocol StockServiceProtocol {
    func fetchPortofolio() async throws -> [Stock]
}


class StockService: StockServiceProtocol {
    
    private let endpoint: StockEndpoint
    
    
    init(endpoint: StockEndpoint = .portofolio) {
        self.endpoint = endpoint
    }

    func fetchPortofolio() async throws -> [Stock] {
        var request = URLRequest(url: self.endpoint.url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 5.0
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CANetworkError.invalidResponse(statusCode: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CANetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        do {
            let portofolio = try JSONDecoder().decode(Portofolio.self, from: data)
            return portofolio.stocks
        } catch {
            throw CANetworkError.decodingFailed(error)
        }
    }
}
