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
    @IBOutlet weak var searchBar: UISearchBar!
    var cryptoTypes = [RawCoin]()
    var selectedTypes = [RawCoin]()
    let configModel = ConfigurationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configModel.delegate = self
        searchBar.delegate = self
        configModel.getAllCoins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let util = Util.getInstance()
        if configModel.isExistingUser && !util.isAppLaunched() {
            performSegue(withIdentifier: Constansts.HomePage.homeSegue, sender: self)
            util.setAppLaunched(true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        configModel.savePreference(coinList: selectedTypes)
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
        if selectedTypes.contains(where: {$0.coinName == cryptoTypes[indexPath.row].coinName}) {
            cryptoTypes[indexPath.row].checked = true
        }
        cell.accessoryType = cryptoTypes[indexPath.row].checked ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cryptoTypes[indexPath.row].checked {
            selectedTypes.removeAll(where: {cryptoTypes[indexPath.row].coinName == $0.coinName})
        } else {
            selectedTypes.append(cryptoTypes[indexPath.row])
        }
        cryptoTypes[indexPath.row].checked = !cryptoTypes[indexPath.row].checked
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let searchText = searchBar.text {
            if searchText.count == 0 {
                searchBar.endEditing(true)
            }
        }
    }
}

//MARK:- Searchbar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            configModel.getAllCoins()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            let newCryptoTypes = cryptoTypes.filter {$0.coinName.lowercased().contains(searchText.lowercased())}
            cryptoTypes = newCryptoTypes
            tableView.reloadData()
        }
        searchBar.endEditing(true)
    }
}

// MARK:- Configuration Model Protocol
extension ViewController: ConfigurationModelProtocol {
    func savedCoins(selectedCoins: [RawCoin]) {
        if selectedTypes.count == 0 {
            selectedTypes = selectedCoins
            tableView.reloadData()
        }
    }
    func coinsSaved(staus: Bool, errorMessage: String?) {
        if staus {
            performSegue(withIdentifier: Constansts.HomePage.homeSegue, sender: self)
        } else {
            let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func coinsLoaded(coinList: [RawCoin]) {
        cryptoTypes = coinList
        tableView.reloadData()
    }
}

