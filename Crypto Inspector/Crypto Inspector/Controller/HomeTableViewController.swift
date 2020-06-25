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
    private var selectedCoin: CurrentPrice?
    @IBOutlet weak var labelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: Constansts.HomePage.cellIdentifier)
        homeModel.delegate = self
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (_) in
            self.homeModel.getCurrentPrice()
        })
        homeModel.getCurrentPrice()
    }
    
    @objc private func refreshTable() {
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
        cell.coinPrice.text = "\(Util.getCurrencySymbol(with: currentPrice.currencyCode)) \(currentPrice.currentPriceLabel)"
        if let cryptoImage = loadImageFromUrl(currentPrice.imageUrl) {
            cell.coinImageView.image = cryptoImage
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            print(self.currentPrices[indexPath.row].coinName)
            //TODO: Delete the item
        }
        deleteAction.image = UIImage(systemName: "trash.circle.fill")
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            self.selectedCoin = self.currentPrices[indexPath.row]
            self.performSegue(withIdentifier: Constansts.HomePage.editSegue, sender: self)
        }
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
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
    
    // MARK:- Override prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == Constansts.HomePage.editSegue {
                if let destination = segue.destination as? EditViewController {
                    if let safeCoin = self.selectedCoin {
                        destination.coin = safeCoin
                    }
                }
            }
        }
    }
    
}

// MARK:- HomeModel Protocol Implementation
extension HomeTableViewController: HomeModelProtocol {
    func currentPriceListFetched(currentPriceList: [CurrentPrice]) {
        currentPrices = currentPriceList
        currentPrices.sort {$0.currentPrice > $1.currentPrice}
        self.setLiveLabel()
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}
