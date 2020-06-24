//
//  HomeTableViewController.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/23/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    private let homeModel = HomeModel()
    private var currentPrices = [CurrentPrice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: Constansts.HomePage.cellIdentifier)
        homeModel.delegate = self
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (_) in
            self.homeModel.getCurrentPrice()
        })
        homeModel.getCurrentPrice()
        setLiveLabel()
    }
    
    func setLiveLabel() {
        if let navigationBar = self.navigationController?.navigationBar {
            let label = UILabel()
            label.text = "Live"
            label.textColor = #colorLiteral(red: 0.1307886541, green: 0.6106421947, blue: 0.3994703293, alpha: 1)
            navigationBar.addSubview(label)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentPrices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPrice = currentPrices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constansts.HomePage.cellIdentifier, for: indexPath) as! HomeTableViewCell
        cell.coinLabel.text = currentPrice.coinName
        cell.coinPrice.text = "USD \(currentPrice.currentPriceLabel)"
        if let cryptoImage = loadImageFromUrl(currentPrice.imageUrl) {
            cell.coinImageView.image = cryptoImage
        }
        return cell
    }
    
    func loadImageFromUrl(_ url: String) -> UIImage? {
        if let safeurl = URL(string: url), let data = try? Data(contentsOf: safeurl) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}

// MARK:- HomeModel Protocol Implementation
extension HomeTableViewController: HomeModelProtocol {
    func currentPriceListFetched(currentPriceList: [CurrentPrice]) {
        currentPrices = currentPriceList
        currentPrices.sort {$0.currentPrice > $1.currentPrice}
        tableView.reloadData()
    }
}
