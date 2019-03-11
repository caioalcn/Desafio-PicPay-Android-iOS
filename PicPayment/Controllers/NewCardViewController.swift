//
//  NewCardViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 06/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit
import KeychainAccess

class NewCardViewController: UIViewController {
    
    @IBOutlet weak var cardNumberText: UITextField!
    @IBOutlet weak var nameHolderText: UITextField!
    @IBOutlet weak var expireDateText: UITextField!
    @IBOutlet weak var cvvText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!

    let keychain = Keychain(service: "ccSecurity")
    var user: Contact?
    var card: CreditCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(named: "GreenPic")
        titleLabel.text = "Save Card"
        
    }
    
    
    override func viewDidLayoutSubviews() {
        setupCustomTextField()
    }
    
    func setupCustomTextField() {
        let lineColor = UIColor(named: "GrayPic")!
        
        cardNumberText.setBottomLine(borderColor: lineColor)
        cardNumberText.setPlaceholder(text: "Card Number", textColor: UIColor(named: "GrayPic")!)
        
        nameHolderText.setBottomLine(borderColor: lineColor)
        nameHolderText.setPlaceholder(text: "Name Holder", textColor:UIColor(named: "GrayPic")!)
        
        expireDateText.setBottomLine(borderColor: lineColor)
        expireDateText.setPlaceholder(text: "Expire Date", textColor: UIColor(named: "GrayPic")!)
        
        cvvText.setBottomLine(borderColor: lineColor)
        cvvText.setPlaceholder(text: "CVV", textColor:UIColor(named: "GrayPic")!)
        cvvText.delegate = self
    }
    
    
    @IBAction func saveNewCard(_ sender: UIButton) {
        if verifyTextFieldValues() {
            performSegue(withIdentifier: "amountSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "amountSegue" {
            let amountController = segue.destination as! AmountViewController

            saveCardKeychain()
            amountController.userPay = user
            amountController.ccSelected = card
        }
    }
    
    
    func verifyTextFieldValues() -> Bool {
        
        guard let cardNumber = cardNumberText.text?.replacingOccurrences(of: " ", with: ""), let name = nameHolderText.text, let expire = expireDateText.text, let cvv = cvvText.text else { return false }
        
        if (cardNumber.isEmpty || name.isEmpty || expire.isEmpty || cvv.isEmpty) {
            
            showAlert("Error", message: "Please fill all fields.")
            return false
            
        } else if !(CreditCardValidator.validate(string: cardNumber)) {
            showAlert("Error", message: "Please enter a valid card.")
            return false

        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        
        if let date2 = formatter.date(from: expire){
            let components = Calendar.current.dateComponents([.month], from: date, to: date2)
            
            if components.month! < 0 {
                showAlert("Error", message: "Please enter a valid date.")
                return false
            }
            
        } else {
            showAlert("Error", message: "Please enter a valid date.")
            return false
        }
        
        if (cvv.count <= 2) {
            showAlert("Error", message: "Please enter a valid cvv.")
            return false
        }
        
        if let data = keychain[data: "cards"] {
            if let ccArray = try? JSONDecoder().decode([CreditCard].self, from: data) {
                let type = CreditCardValidator.type(from: cardNumber)
                
                card = CreditCard(number: cardNumber.replacingOccurrences(of: "-", with: ""), type: type, name: name, expire: expire, cvv: cvv)
                if !(ccArray.contains(where: {$0.number == card?.number})) {
                    return true
                } else {
                    showAlert("Error", message: "Card already register!")

                    return false
                }
            }
        }
        
        return true
    }
    
    func saveCardKeychain() {
        
        guard let cardNumber = cardNumberText.text?.replacingOccurrences(of: " ", with: ""), let name = nameHolderText.text?.uppercased(), let expire = expireDateText.text, let cvv = cvvText.text else { return }
        
        var dataToSave: Data?
        var type = ""
        
        
        if let data = keychain[data: "cards"] {
            if var ccArray = try? JSONDecoder().decode([CreditCard].self, from: data) {
                
                type = CreditCardValidator.type(from: cardNumber)
                card = CreditCard(number: cardNumber.replacingOccurrences(of: "-", with: ""), type: type, name: name, expire: expire, cvv: cvv)
                ccArray.append(card!)

                dataToSave = try? JSONEncoder().encode(ccArray)
            }
        } else {

            type = CreditCardValidator.type(from: cardNumber) 
            card = CreditCard(number: cardNumber.replacingOccurrences(of: "-", with: ""), type: type, name: name, expire: expire, cvv: cvv)
            let arrayCC = [card]
            
            dataToSave = try? JSONEncoder().encode(arrayCC)
        }
        
        keychain[data: "cards"] = dataToSave

    }
    
}

extension NewCardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 4
    }
    
}

