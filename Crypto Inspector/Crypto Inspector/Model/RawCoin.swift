//
//  RawCoin.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/22/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation
import RealmSwift

class RawCoin: Object {
    @objc dynamic var asset_id: String = ""
    @objc dynamic var coinName: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var checked: Bool = false
}
