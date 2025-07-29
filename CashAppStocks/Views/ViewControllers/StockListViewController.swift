//
//  StockListViewController.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import UIKit
import SwiftUI

class StockListViewController: UIViewController {
    
    private let viewModel: StockListViewModel
    private var stateOverlayHost: UIView?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    
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
        self.viewModel.loadStocks()
    }
    
    func setupUI() {
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
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
    
    func bindViewModel() {
        self.viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                
                switch state {
                case .loading:
                    print("loading State")
                    self.navigationItem.searchController = self.searchController
                    self.showOverlay(LoadingView())
                case .loaded:
                    print("loaded State - count:\(self.viewModel.stocks.count)")
                    self.navigationItem.searchController = self.searchController
                    self.stateOverlayHost?.removeFromSuperview()
                    self.tableView.reloadData()
                case .empty:
                    print("empty State")
                    self.tableView.reloadData()
                    self.navigationItem.searchController = nil
                    self.showOverlay(EmptyStateView())
                case .error(let error):
                    print("error State")
                    self.navigationItem.searchController = nil
                    self.showOverlay(ErrorView(message: error.localizedDescription))
                }
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
    
    @objc private func didPullToRefresh() {
        self.viewModel.loadStocks()
    }
}

extension StockListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < viewModel.stocks.count else {
            print("⚠️ indexPath.row (\(indexPath.row)) out of bounds for stocks count: \(self.viewModel.stocks.count)")
            return UITableViewCell()
        }
        
        let item = self.viewModel.stocks[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockListCell.identifier, for: indexPath) as? StockListCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        
        return cell
    }
}

extension StockListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        self.viewModel.updateSearchQuery(query)
    }
}
