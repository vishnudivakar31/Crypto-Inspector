//
//  EditViewController.swift
//  Crypto Inspector
//
//  Created by Vishnu Divakar on 6/25/20.
//  Copyright © 2020 Vishnu Divakar. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinLabelView: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    var coin: CurrentPrice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeCoin = coin {
            coinLabelView.text = safeCoin.coinName
            currentPriceLabel.text = "Price: \(Util.getCurrencySymbol(with: safeCoin.currencyCode)) \(safeCoin.currentPriceLabel)"
            if let url = URL(string: safeCoin.imageUrl), let safeData = try? Data(contentsOf: url) {
                if let image = UIImage(data: safeData) {
                    DispatchQueue.main.async {
                        self.coinImageView.image = image
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
    }
}
