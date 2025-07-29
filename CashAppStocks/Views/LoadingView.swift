//
//  LoadingView.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import SwiftUI

struct LoadingView: View {
    var message = "Loading..."
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(1.5)
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(32)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.01))
    }
}

