//
//  EditViewController.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/25/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var countryCurrencyCode: [CountryCurrencyCode]?
    var currentCoin: CurrentPrice?
    var selectedCurrencyCode: CountryCurrencyCode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCurrencyCode = Util.generateCountryCurrencyCode()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        if let coin = currentCoin {
            title = coin.coinName
            for currencyCode in countryCurrencyCode! {
                if currencyCode.currencyCode == coin.currencyCode {
                    selectedCurrencyCode = currencyCode
                }
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
}

// MARK:- UITableView delegate and datasource
extension EditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryCurrencyCode?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constansts.editPage.cellIdentifier, for: indexPath)
        cell.textLabel?.text = countryCurrencyCode![indexPath.row].currencyCode
        if let safeSelectedCurrency = selectedCurrencyCode {
            cell.accessoryType = countryCurrencyCode![indexPath.row].currencyCode == safeSelectedCurrency.currencyCode ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let safeCoin = countryCurrencyCode?[indexPath.row], let safeCurrentCoin = selectedCurrencyCode {
            if safeCoin.currencyCode == safeCurrentCoin.currencyCode {
                selectedCurrencyCode = nil
            } else {
                selectedCurrencyCode = safeCoin
            }
            tableView.reloadData()
        }
    }
}

// MARK:- UISearchBarDelegate
extension EditViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            countryCurrencyCode = Util.generateCountryCurrencyCode()
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            countryCurrencyCode = countryCurrencyCode?.filter {$0.currencyCode.lowercased().starts(with: searchText.lowercased())}
            tableView.reloadData()
        }
        searchBar.endEditing(true)
    }
    
}
