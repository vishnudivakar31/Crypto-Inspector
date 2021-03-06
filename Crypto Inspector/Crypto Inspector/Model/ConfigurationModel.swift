//
//  ConfigurationModel.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/22/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

protocol ConfigurationModelProtocol {
    func coinsLoaded(coinList: [RawCoin])
    func coinsSaved(staus: Bool, errorMessage: String?)
    func savedCoins(selectedCoins: [RawCoin])
}

class ConfigurationModel {
    var delegate: ConfigurationModelProtocol?
    private let baseUrl = "https://rest.coinapi.io/v1"
    
    var isExistingUser: Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: Constansts.firstTimeUser)
    }
    
    // MARK: - Network Calls
    
    func getAllCoins() {
        let url = "\(baseUrl)/assets?apikey=\(Util.apiKey)"
        AF.request(url).responseJSON { response in
            do {
                let jsonData = try JSON(data: response.data!)
                self.filterAssets(with: jsonData)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func getAssetIcons(assets: [String: String]) {
        let url = "\(baseUrl)/assets/icons/50?apikey=\(Util.apiKey)"
        AF.request(url).responseJSON { response in
            do {
                let jsonData = try JSON(data: response.data!)
                self.mergeAssetWithIcons(assets: assets, icons: jsonData)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Filter and Merge Methods

    private func filterAssets(with jsonData: JSON) {
        var assetIDList = [String: String]()
        for (_, subJson): (String, JSON) in jsonData {
            if subJson[Constansts.ConfigurationPage.cryptoIdentifier].int == 1 {
                if let assetId = subJson[Constansts.assetId].string, let coinName = subJson[Constansts.ConfigurationPage.coinName].string {
                    assetIDList[assetId] = coinName
                }
            }
        }
        if assetIDList.count > 0 {
            getAssetIcons(assets: assetIDList)
        }
    }
    
    private func mergeAssetWithIcons(assets: [String: String], icons: JSON) {
        var rawCoinList = [RawCoin]()
        for (_, subJson): (String, JSON) in icons {
            if let asset_id = subJson[Constansts.assetId].string, let imageUrl = subJson[Constansts.url].string, let coinName = assets[asset_id] {
                let rawCoin = RawCoin()
                rawCoin.asset_id = asset_id
                rawCoin.coinName = coinName
                rawCoin.imageUrl = imageUrl
                rawCoin.currencyCode = Util.getDefaultCurrencyCode()
                rawCoinList.append(rawCoin)
            }
        }
        rawCoinList.sort {$0.coinName < $1.coinName}
        self.delegate?.coinsLoaded(coinList: rawCoinList)
        getSavedPreferences()
    }
    
    private func getSavedPreferences() {
        let realm = try! Realm()
        let savedPreference = realm.objects(RawCoin.self)
        var coinList = [RawCoin]()
        for pref in savedPreference {
            coinList.append(pref)
        }
        self.delegate?.savedCoins(selectedCoins: coinList)
    }
    
    private func setExistingUser(_ status: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(status, forKey: Constansts.firstTimeUser)
    }
    
    //MARK:- Save preference
    func savePreference(coinList: [RawCoin]) {
        if coinList.count > 0 {
            let realm = try! Realm()
            try! realm.write {
                for coin in coinList {
                    realm.add(coin)
                }
            }
            delegate?.coinsSaved(staus: true, errorMessage: nil)
            setExistingUser(true)
        } else {
            delegate?.coinsSaved(staus: false, errorMessage: Constansts.ConfigurationPage.failedToSave)
        }
    }
}
