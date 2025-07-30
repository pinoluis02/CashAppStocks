//
//  StockListCell.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import UIKit

class StockListCell: UITableViewCell, ReusableCell {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.applyCardStyle()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGreen
        label.textAlignment = .right
        return label
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        self.setupContainerView()
        self.setupStackView()
    }
    
    private func setupContainerView() {
        contentView.addSubview(self.containerView)
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            self.containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            self.containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupStackView() {
        let textStack = UIStackView(arrangedSubviews: [self.symbolLabel, self.nameLabel])
        textStack.axis = .vertical
        textStack.spacing = 6
        
        let hStack = UIStackView(arrangedSubviews: [textStack, self.priceLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = 12
        
        self.containerView.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16),
            hStack.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16),
            hStack.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Configure
    func configure(with viewModel: StockViewModel) {
        self.symbolLabel.text = viewModel.displaySymbol
        self.nameLabel.text = viewModel.displayName
        self.priceLabel.text = viewModel.displayPrice
    }
}
