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
    @IBOutlet weak var labelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: Constansts.HomePage.cellIdentifier)
        homeModel.delegate = self
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (_) in
            self.homeModel.getCurrentPrice()
        })
        homeModel.getCurrentPrice()
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
    
    func setLiveLabel() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy, HH:mm:ss"
        labelView.text = "Last Modified: \(dateFormatter.string(from: date))"
        labelView.insetsLayoutMarginsFromSafeArea = true
    }
}

// MARK:- HomeModel Protocol Implementation
extension HomeTableViewController: HomeModelProtocol {
    func currentPriceListFetched(currentPriceList: [CurrentPrice]) {
        currentPrices = currentPriceList
        currentPrices.sort {$0.currentPrice > $1.currentPrice}
        self.setLiveLabel()
        tableView.reloadData()
    }
}
