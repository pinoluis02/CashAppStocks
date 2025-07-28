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
    
    func fetchPortofolio(completion:@escaping (Result<[Stock], Error>) -> Void)
}


class StockService: StockServiceProtocol {
    
    private let endpoint: StockEndpoint
    
    
    init(endpoint: StockEndpoint = .portofolio) {
        self.endpoint = endpoint
    }
    
    func fetchPortofolio(completion: @escaping (Result<[Stock], Error>) -> Void) {
        
        URLSession.shared.dataTask(with: self.endpoint.url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "StockService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            do {
                let portofolio = try JSONDecoder().decode(Portofolio.self, from: data)
                completion(.success(portofolio.stocks))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
