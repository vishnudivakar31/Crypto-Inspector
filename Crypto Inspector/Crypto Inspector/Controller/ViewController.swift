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
    let cryptoTypes = ["Bitcoin", "Ether", "Ethereium"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cryptoTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constansts.ConfigurationPage.cellIdentifier, for: indexPath)
        cell.textLabel?.text = cryptoTypes[indexPath.row]
        return cell
    }
    
    
}

