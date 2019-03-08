//
//  CardsViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 03/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit
import KeychainAccess

class CardsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var noCardDataView: UIView!
    @IBOutlet weak var saveCardButton: UIButton!
    
    let keychain = Keychain(service: "ccSecurity")
    var creditCards = [CreditCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cards"

        if let data = keychain[data: "cards"] {
            if let ccArray = try? JSONDecoder().decode([CreditCard].self, from: data) {
                creditCards = ccArray
                setupNoDataView(isHidden: true)
            }
        }

        tableView.backgroundView = noCardDataView

    }

    func setupNoDataView(isHidden: Bool) {
        noCardDataView.isHidden = isHidden
    }
    
    @IBAction func saveCard(_ sender: UIButton) {
    }
    
}

extension CardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        
        cell.setupCardCell(card: creditCards[indexPath.row])
        
        return cell
        
    }
    
}
