//
//  CountryCurrencyCode.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/25/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation

class CountryCurrencyCode {
    var currencyCode: String
    var checked: Bool
    
    init(currencyCode: String, checked: Bool) {
        self.currencyCode = currencyCode
        self.checked = checked
    }
}
