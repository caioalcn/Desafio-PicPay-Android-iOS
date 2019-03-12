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
    @IBOutlet weak var noCardDataLabel: UILabel!
    @IBOutlet weak var noCardDescriptionLabel: UILabel!
    @IBOutlet weak var saveCardButton: UIButton!
    
    let keychain = Keychain(service: "ccSecurity")
    var user: Contact?
    var creditCards = [CreditCard]() {
        didSet {
            if creditCards.count <= 0 {
                setupNoDataView(isHidden: false)
                tableView.isScrollEnabled = false
            } else {
                setupNoDataView(isHidden: true)
                tableView.isScrollEnabled = true
            }
        }
    }
    var selectedCard: CreditCard?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Cards", comment: "")
        saveCardButton.setTitle(NSLocalizedString("Register a New Card", comment: ""), for: .normal)
        noCardDataLabel.text = NSLocalizedString("Save a Credit Card", comment: "")
        noCardDescriptionLabel.text = NSLocalizedString("To be able to pay other people you will need to have a personal creditcard", comment: "")
        tableView.backgroundView = noCardDataView
        tableView.isScrollEnabled = false

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
            
            let alertController = UIAlertController(title: NSLocalizedString("Delete", comment: ""), message: NSLocalizedString("Are you sure you want to delete this card?", comment: ""), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) {
                UIAlertAction in
                
                self.creditCards.remove(at: indexPath.row)
                let data = try? JSONEncoder().encode(self.creditCards)
                self.keychain[data: "cards"] = data
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        }
    }
}
