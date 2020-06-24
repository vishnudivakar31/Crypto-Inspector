//
//  CurrentPrice.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/24/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation

class CurrentPrice {
    var currentPrice: Double = 0.0
    var coinName: String = ""
    var imageUrl: String = ""
    var currentPriceLabel: String {
        return String(format: "%.2f", currentPrice)
    }
}
