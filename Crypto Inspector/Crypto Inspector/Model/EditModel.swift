//
//  EditModel.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/26/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation
import RealmSwift

struct EditModel {
    let realm = try! Realm()
    
    func updateCurrencyCode(coinPrice: CurrentPrice, currencyCode: CountryCurrencyCode) {
        let coin = realm.objects(RawCoin.self).first(where: {$0.coinName == coinPrice.coinName})
        try! realm.write {
            coin?.currencyCode = currencyCode.currencyCode
        }
    }
}
