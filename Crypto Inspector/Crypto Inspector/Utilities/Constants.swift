//
//  Constants.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/22/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation

struct Constansts {
    static let secretsFile = "Secrets"
    static let apikey = "apikey"
    static let assetId = "asset_id"
    static let url = "url"
    static let firstTimeUser = "firstTimeUser"
    struct ConfigurationPage {
        static let cellIdentifier = "CryptoCellIdentifier"
        static let cryptoIdentifier = "type_is_crypto"
        static let coinName = "name"
        static let failedToSave = "Unable to save coin preference. Please check the selected coins."
    }
    struct HomePage {
        static let homeSegue = "goToHome"
        static let cellIdentifier = "HomeCellIdentifier"
        static let currentRatelabel = "rate"
        static let editSegue = "goToEdit"
    }
    
}
