//
//  AmountViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 07/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit
import SDWebImage

class AmountViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    var userPay: Contact?
    var ccSelected: CreditCard?
    var transaction: Transaction?
    
    @IBOutlet weak var childBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupInfo()
        amountText.delegate = self
        amountText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        amountText.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiptSegue" {
            
            let receiptController = segue.destination as? ReceiptViewController
            //receiptController?.valuePaidLabel.text = "njkl"
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CardsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    func setupInfo() {
        guard let user = userPay else { return }
        guard let card = ccSelected else { return }
        
        
        if let img = user.img {
            userImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "profile-user.png"))
        }
        
        userNameLabel.text = user.username
        
        
        if card.type == "Amex" {
            if let threeDigits = card.number?.suffix(3), let type = card.type{
                cardLabel.text = type + " " + threeDigits
            }
        } else {
            if let fourDigits = card.number?.suffix(4), let type = card.type{
                cardLabel.text = type + " " + fourDigits
            }
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyFormatting() {
            if amountString.isEmpty {
                textField.text = "0,00"
                amountText.textColor = UIColor(named: "GrayPic")
                signLabel.textColor = UIColor(named: "GrayPic")
                payButton.backgroundColor = UIColor(named: "GrayPic")
                payButton.isEnabled = false
                
            } else {
                textField.text = amountString
                amountText.textColor = UIColor(named: "GreenPic")
                signLabel.textColor = UIColor(named: "GreenPic")
                payButton.backgroundColor = UIColor(named: "GreenPic")
                payButton.isEnabled = true
                
            }
        }
    }
    
    @IBAction func editCard(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CardsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func payAmount(_ sender: UIButton) {
        
        guard let user = userPay else { return }
        guard let card = ccSelected else { return }
        
        if let number = card.number, let cvv = card.cvv, let expire = card.expire, let id = user.id, let amount = amountText.text?.replacingOccurrences(of: ",", with: ".") {
            if let cvvCast = Int(cvv), let amountCast = Double(amount) {
                payContact(cardNumber: number, cvv: cvvCast, value: amountCast, expireDate: expire, userId: id)
            }
        }
        
    }
    
    func payContact(cardNumber: String, cvv: Int, value: Double, expireDate: String, userId: Int) {
        if (ReachabilityManager.shared.isConnectedToNetwork()){
            HUDHelper.showLoading()
            APIPayments.pay(cardNumber: "1111111111111111", cvv: cvv, value: value, expireDate: expireDate, destinationUserId: userId) { (result, status) in
                switch status {
                case .success(_):
                    self.transaction = result
                    UIView.animate(withDuration: 0.5) {
                        self.childBottomConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                case .failure(let error):
                    self.showAlert("Error", message: "\(error)")
                }
                HUDHelper.hideLoading()
            }
        } else {
            self.showAlert("Error", message: "Please check your internet connection.")
        }
    }
}

extension AmountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        
        return count <= 7
    }
    
    
}
