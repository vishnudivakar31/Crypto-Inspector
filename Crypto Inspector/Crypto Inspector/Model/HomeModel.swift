//
//  HomeModel.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/23/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

protocol HomeModelProtocol {
    func currentPriceListFetched(currentPriceList: [CurrentPrice])
}

class HomeModel {
    
    private let baseUrl = "https://rest.coinapi.io/v1"
    private var currentPriceList = [CurrentPrice]()
    var delegate: HomeModelProtocol?
    
    func getCurrentPrice() {
        let coinList = getSavedCoins()
        if coinList.count > 0 {
            getCurrentPriceForCoinList(coinList)
        }
    }
    
    private func getSavedCoins() -> [RawCoin] {
        var coinList = [RawCoin]()
        let realm = try! Realm()
        let coins = realm.objects(RawCoin.self)
        for coin in coins {
            coinList.append(coin)
        }
        return coinList
    }
    
    private func getCurrentPriceForCoinList(_ coinList: [RawCoin]) {
        currentPriceList = [CurrentPrice]()
        let group = DispatchGroup()
        for coin in coinList {
            group.enter()
            performRequest(coin: coin) { (currentPrice) in
                self.currentPriceList.append(currentPrice)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.delegate?.currentPriceListFetched(currentPriceList: self.currentPriceList)
            self.currentPriceList = [CurrentPrice]()
        }
    }
    
    private func performRequest(coin: RawCoin, completion: @escaping (CurrentPrice) -> Void) {
        let url = "\(baseUrl)/exchangerate/\(coin.asset_id)/USD?apikey=\(Util.apiKey)"
        AF.request(url).responseJSON { response in
            do {
                let data = try JSON(data: response.data!)
                let currentPrice = CurrentPrice()
                currentPrice.currentPrice = data[Constansts.HomePage.currentRatelabel].double ?? Double.random(in: 0...10000)
                currentPrice.coinName = coin.coinName
                currentPrice.imageUrl = coin.imageUrl
                currentPrice.currencyCode = coin.currencyCode
                completion(currentPrice)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}