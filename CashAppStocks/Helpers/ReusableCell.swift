//
//  ReusableCell.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/28/25.
//

import UIKit


protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String { String(describing: Self.self) }
}

