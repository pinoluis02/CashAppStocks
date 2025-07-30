//
//  StockDetailViewController.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/30/25.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    private let stockViewModel: StockViewModel
    
    // MARK: - UI Components
    private lazy var tickerLabel: UILabel = {
        let label = UILabel()
        label.text = stockViewModel.displaySymbol
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "stock_arrow")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = stockViewModel.displayName
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "\(stockViewModel.displayPrice) \(stockViewModel.currency)"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.text = stockViewModel.displayQuantity
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.text = stockViewModel.formattedDate
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            tickerLabel,
            imageView,
            nameLabel,
            priceLabel,
            quantityLabel,
            timestampLabel
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - Init
    init(stockViewModel: StockViewModel) {
        self.stockViewModel = stockViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.stockViewModel.displaySymbol
        view.backgroundColor = .systemBackground
        self.setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.applyCardShadow(to: self.cardView)
        view.addSubview(cardView)
        self.cardView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            self.cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            self.cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            self.cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.cardView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),
            
            self.imageView.heightAnchor.constraint(equalToConstant: 80),
            
            self.stack.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 40),
            self.stack.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -40),
            self.stack.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 16),
            self.stack.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -16),
        ])
    }
    
    private func applyCardShadow(to: UIView) {
        
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.systemGray.cgColor
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        cardView.layer.masksToBounds = false
    }
}
