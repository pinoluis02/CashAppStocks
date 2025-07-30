//
//  UIView+Styling.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/30/25.
//

import UIKit

extension UIView {
    
    func applyRoundedCorners(radius: CGFloat = 12) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
    }
    
    func applyCardShadow(
        color: UIColor = .systemGray,
        opacity: Float = 0.1,
        offset: CGSize = CGSize(width: 0, height: 4),
        radius: CGFloat = 8
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    /// Applies both rounded corners and card shadow
    func applyCardStyle(backgroundColor: UIColor = .systemGray6) {
        self.backgroundColor = backgroundColor
        self.applyRoundedCorners()
        self.applyCardShadow()
    }
    
}
