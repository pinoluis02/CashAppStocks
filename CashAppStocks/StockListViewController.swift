//
//  StockListViewController.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import UIKit

class StockListViewController: UIViewController {
    
    private let viewModel: StockListViewModel
    
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
        self.configureTableView()
        self.bindViewModel()
        self.viewModel.loadStocks()
    }
    
    func setupUI() {
        self.title = "Stocks"
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.tableView)
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StockCell")
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bindViewModel() {
        self.viewModel.onStateChanged = { state in
            switch state {
            case .loading:
                break
            case .loaded:
                self.tableView.reloadData()
            case .empty:
                break
            case .error(let error):
                break
            }
        }
    }
    
}

extension StockListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.viewModel.stocks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = item.stock.ticker
        config.secondaryText = item.stock.name
        cell.contentConfiguration = config
        
        return cell
    }
}
