//
//  StockListViewModel.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import Foundation
import Combine

class StockListViewModel {
    private let stockService: StockServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var allStocks: [StockViewModel] = []

    @Published private(set) var state: LoadableState<[StockViewModel]> = .loading
    @Published var searchQuery: String = ""
    
    var stocks: [StockViewModel] {
        self.state.value ?? []
    }

    
    init(stockService: StockServiceProtocol = StockService()) {
        self.stockService = stockService
        self.setupBindings()
    }

    @MainActor
    func loadStocks() async {
        self.state = .loading
        
        do {
            let stocks = try await self.stockService.fetchPortofolio()
            self.allStocks = stocks.map { StockViewModel(stock: $0) }
            let filtered = self.filterStocks(self.allStocks)
            self.state = filtered.isEmpty ? .empty : .loaded(filtered)
        } catch {
            self.state = .error(error)
        }
    }

    private func setupBindings() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                if self.state.isError || self.state.isLoading { return }
                let filtered = self.filterStocks(self.allStocks)
                self.state = filtered.isEmpty ? .empty : .loaded(filtered)
            }
            .store(in: &cancellables)
    }
    
    private func filterStocks(_ input: [StockViewModel]) -> [StockViewModel] {
        let query = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return query.isEmpty ? input : input.filter {
            $0.stock.ticker.lowercased().contains(query) ||
            $0.stock.name.lowercased().contains(query)
        }
    }
}
