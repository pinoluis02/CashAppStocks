//
//  StockListViewController.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import UIKit
import SwiftUI
import Combine

class StockListViewController: UIViewController {
    
    private let viewModel: StockListViewModel
    private var stateOverlayHost: UIView?
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    
    // MARK: - Init
    init(viewModel: StockListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModel()
        Task {
            await self.viewModel.loadStocks(caller: "viewDidLoad")
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.tableView)
        self.setupTableView()
        self.setupSearchBar()
    }
    
    private func setupSearchBar() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search stocks"
        self.searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        self.tableView.register(StockListCell.self, forCellReuseIdentifier: StockListCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.alwaysBounceVertical = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        self.viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                self.handle(state: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    private func handle(state: LoadableState<[StockViewModel]>) {
        switch state {
        case .loading:
            print("📡 UI: loading state")
            self.setSearchBarEnabled(true)
            self.showOverlay(LoadingView())
        case .loaded(let stocks): // Access associated value
            print("✅ UI: loaded state - count \(stocks.count)")
            self.setSearchBarEnabled(true)
            self.stateOverlayHost?.removeFromSuperview()
            tableView.reloadData()
        case .empty:
            print("🈳 UI: empty state")
            tableView.reloadData()
            self.setSearchBarEnabled(true)
            self.showOverlay(EmptyStateView())
        case .error(let error):
            print("❌ UI: error state: \(error.localizedDescription)")
            self.setSearchBarEnabled(false)
            if let caNetworkError = error as? CANetworkError {
                print("❌ UI: error CANetworkError")
                self.showOverlay(ErrorView(message: caNetworkError.errorDescription ?? error.localizedDescription))
            } else {
                self.showOverlay(ErrorView(message: error.localizedDescription))
            }
        }
    }
    
    private func showOverlay<V: View>(_ swiftUIView: V) {
        self.stateOverlayHost?.removeFromSuperview()
        
        let host = UIHostingController(rootView: swiftUIView)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        
        self.view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.stateOverlayHost = host.view
    }
    
    private func setSearchBarEnabled(_ isEnabled: Bool) {
        self.searchController.searchBar.isUserInteractionEnabled = isEnabled
        self.searchController.searchBar.alpha = isEnabled ? 1.0 : 0.5
        
        if !isEnabled {
            self.searchController.searchBar.text = ""
            self.searchController.isActive = false
        }
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension StockListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < self.viewModel.stocks.count else {
            return UITableViewCell()
        }
        
        let item = self.viewModel.stocks[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockListCell.identifier, for: indexPath) as? StockListCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stockViewModel = viewModel.stocks[indexPath.row]
        let detailVC = StockDetailViewController(stockViewModel: stockViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}


// MARK: - UISearchResultsUpdating
extension StockListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchQuery = searchController.searchBar.text ?? ""
    }
}
