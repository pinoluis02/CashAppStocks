//
//  StockDetailViewController.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/30/25.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    private let stockViewModel: StockViewModel

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

    private func setupUI() {
        let tickerLabel = UILabel()
        tickerLabel.text = self.stockViewModel.displaySymbol
        tickerLabel.font = .preferredFont(forTextStyle: .largeTitle)
        tickerLabel.textColor = .label
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "stock_arrow")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = self.stockViewModel.displayName
        nameLabel.font = .preferredFont(forTextStyle: .title2)
        nameLabel.textColor = .secondaryLabel
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let priceLabel = UILabel()
        priceLabel.text = "\(self.stockViewModel.displayPrice) \(self.stockViewModel.currency)"
        priceLabel.font = .preferredFont(forTextStyle: .title1)
        priceLabel.textColor = .systemGreen
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        let quantityLabel = UILabel()
        quantityLabel.text = self.stockViewModel.displayQuantity
        quantityLabel.font = UIFont.preferredFont(forTextStyle: .body)
        quantityLabel.textColor = .secondaryLabel
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timestampLabel = UILabel()
        timestampLabel.text = self.stockViewModel.formattedDate
        timestampLabel.textColor = .systemGray
        timestampLabel.font = .preferredFont(forTextStyle: .subheadline)
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [tickerLabel, imageView, nameLabel, priceLabel, quantityLabel, timestampLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let cardView = UIView()
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        self.applyCardShadow(cardView: cardView)
        
        view.addSubview(cardView)
        cardView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),
            
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -40),
            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
        ])
    }
    
    private func applyCardShadow(cardView: UIView) {
        
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.systemGray.cgColor
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        cardView.layer.masksToBounds = false
    }
}
