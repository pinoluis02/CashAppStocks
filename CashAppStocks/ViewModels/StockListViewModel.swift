//
//  StockListViewModel.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import Foundation

class StockListViewModel {
    
    private let stockService: StockServiceProtocol
    
    private(set) var state: LoadableState<[StockViewModel]> = .loading {
        didSet { onStateChanged?(state) }
    }
    
    var onStateChanged: ((LoadableState<[StockViewModel]>) -> Void)?
    
    private var allStocks: [StockViewModel] = []
    private var searchQuery: String = ""
    
    var stocks: [StockViewModel] {
        //        self.state.value ?? []
        guard !searchQuery.isEmpty else { return allStocks }
        return allStocks.filter {
            $0.stock.ticker.lowercased().contains(searchQuery.lowercased()) ||
            $0.stock.name.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    
    init(stockService: StockServiceProtocol = StockService()) {
        self.stockService = stockService
    }
    
    func loadStocks() {
        self.state = .loading
        
        self.stockService.fetchPortofolio { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let stocks):
                    let stockViewModels = stocks.map { StockViewModel(stock: $0) }
                    self.allStocks = stockViewModels
                    self.state = stockViewModels.isEmpty ? .empty : .loaded(stockViewModels)
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }
    }
    
    func updateSearchQuery(_ query: String) {
        self.searchQuery = query
        self.onStateChanged?(self.state)
    }
}
