//
//  ViewController.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/22/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cryptoTypes = [RawCoin]()
    let configModel = ConfigurationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configModel.delegate = self
        configModel.getAllCoins()
    }
}

// MARK:- UITableView Delegates and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constansts.ConfigurationPage.cellIdentifier, for: indexPath)
        cell.textLabel?.text = cryptoTypes[indexPath.row].coinName
        cell.accessoryType = cryptoTypes[indexPath.row].checked ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cryptoTypes[indexPath.row].checked = !cryptoTypes[indexPath.row].checked
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- Configuration Model Protocol
extension ViewController: ConfigurationModelProtocol {
    func coinsLoaded(coinList: [RawCoin]) {
        cryptoTypes = coinList
        tableView.reloadData()
    }
}

