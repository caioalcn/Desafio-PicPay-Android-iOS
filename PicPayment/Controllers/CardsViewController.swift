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
    var user: Contact?
    var creditCards = [CreditCard]() {
        didSet {
            if creditCards.count <= 0 {
                setupNoDataView(isHidden: false)
            } else {
                setupNoDataView(isHidden: true)
            }
        }
    }
    var selectedCard: CreditCard?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cards"
        tableView.backgroundView = noCardDataView

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let data = keychain[data: "cards"] {
            if let ccArray = try? JSONDecoder().decode([CreditCard].self, from: data) {
                creditCards = ccArray
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newCardSegue"{
            
            let newCardController = segue.destination as? NewCardViewController
            newCardController?.user = user
 
        } else if segue.identifier == "amountCardSegue" {
            
            let amountController = segue.destination as? AmountViewController
            amountController?.userPay = user
            amountController?.ccSelected = selectedCard
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCard = creditCards[indexPath.row]
        
        performSegue(withIdentifier: "amountCardSegue", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Yes", style: .default) {
                UIAlertAction in
                
                self.creditCards.remove(at: indexPath.row)
                let data = try? JSONEncoder().encode(self.creditCards)
                self.keychain[data: "cards"] = data
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        }
    }
}
