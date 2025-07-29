//
//  StockListViewController.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import UIKit

class StockListViewController: UIViewController {
    
    private let viewModel: StockListViewModel
    
    private let segmentedControl = UISegmentedControl(items: ["Portfolio", "Favorites"])
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()

    
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
        self.configureSegmentedControl()
        self.configureTableView()
        self.bindViewModel()
        self.viewModel.loadStocks()
    }
    
    func setupUI() {
        self.title = "Stocks"
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.tableView)
    }
    
    func configureSegmentedControl() {
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            self.segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func configureTableView() {
        self.tableView.register(StockListCell.self, forCellReuseIdentifier: StockListCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 8),
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
                    break
                case .loaded:
                    print("loaded State")
                    self.tableView.reloadData()
                case .empty:
                    print("empty State")
                    self.tableView.reloadData()
                    break
                case .error(let error):
                    print("error State")
                    break
                }
            }
        }
    }
    
    @objc private func didChangeSegment() {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            break
//            viewModel.showPortfolio()
        case 1:
            break
//            viewModel.showFavorites()
        default: break
        }
        tableView.reloadData()
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
        let item = self.viewModel.stocks[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockListCell.identifier, for: indexPath) as? StockListCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        
        return cell
    }
}
