//
//  EmptyStateView.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import SwiftUI

struct EmptyStateView: View {
    var message = "No Stocks available"
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(.gray)
            Text(message)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
