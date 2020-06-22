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

protocol ConfigurationModelProtocol {
    func coinsLoaded(coinList: [RawCoin])
}

class ConfigurationModel {
    var delegate: ConfigurationModelProtocol?
    private let baseUrl = "https://rest.coinapi.io/v1"
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: Constansts.secretsFile, ofType: "plist") else {
            fatalError("Unable to fetch secret plist.")
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            guard let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
                as? [String: String] else {fatalError("Unable to serialize secret property list")}
            for (key, value) in plist {
                if key == Constansts.apikey {
                    return value
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        fatalError("Unable to compute apiKey")
    }
    
    // MARK: - Network Calls
    
    func getAllCoins() {
        let url = "\(baseUrl)/assets?apikey=\(apiKey)"
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
        let url = "\(baseUrl)/assets/icons/50?apikey=\(apiKey)"
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
                let rawCoin = RawCoin(asset_id: asset_id, coinName: coinName, imageUrl: imageUrl)
                rawCoinList.append(rawCoin)
            }
        }
        rawCoinList.sort {$0.coinName < $1.coinName}
        self.delegate?.coinsLoaded(coinList: rawCoinList)
    }
}
