//
//  CANetowrkErrors.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/29/25.
//

import Foundation

enum CANetworkError: Error, LocalizedError {
    case invalidURL
    case decodingFailed(Error)
    case invalidResponse(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Invalid HTTP response: \(statusCode)"
        }
    }
}
