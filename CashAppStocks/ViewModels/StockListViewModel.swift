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
    
    var stocks: [StockViewModel] {
        self.state.value ?? []
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
                    self.state = stockViewModels.isEmpty ? .empty : .loaded(stockViewModels)
                case .failure(let error):
                    self.state = .error(error)
                }
            }
        }
    }
}
