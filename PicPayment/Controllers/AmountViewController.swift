//
//  AmountViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 07/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit
import SDWebImage


protocol AmountViewControllerDelegate: class {
    func setupUI(receipt: Transaction, card: CreditCard)
}


class AmountViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var userPay: Contact?
    var ccSelected: CreditCard?
    var transaction: Transaction?
    
    weak var delegate: AmountViewControllerDelegate?
    
    @IBOutlet weak var childBottomConstraint: NSLayoutConstraint!
    
    private lazy var tapRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handlePan(recognizer:)))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInfo()
        amountText.delegate = self
        amountText.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        amountText.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiptSegue" {
            
            let receiptController = segue.destination as? ReceiptViewController
            delegate = receiptController
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
    
    @objc func handlePan(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        switch recognizer.state {
        case .began: break
            
        case .changed:
            if self.childBottomConstraint.constant == 0 && translation.y <= 0.0 {
                self.childBottomConstraint.constant = 0
            } else {
                self.childBottomConstraint.constant += translation.y
            }
            
            recognizer.setTranslation(.zero, in: self.view)
        case .ended:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                if self.childBottomConstraint.constant <= 200 {
                    self.childBottomConstraint.constant = 0
                } else {
                    self.childBottomConstraint.constant = 470
                }
                self.view.layoutIfNeeded()
            }) { (status) in
                if  self.childBottomConstraint.constant == 470 {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
            
        default: ()
        }
    }
    
    func setupInfo() {
        guard let user = userPay else { return }
        guard let card = ccSelected else { return }
        
        
        if let img = user.img {
            userImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "profile-user.png"))
        }
        
        userNameLabel.text = user.username
        payButton.setTitle(NSLocalizedString("Pay", comment: ""), for: .normal)
        editButton.setTitle(NSLocalizedString("EDIT", comment: ""), for: .normal)
        
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
        
        if let number = card.number, let cvv = card.cvv, let expire = card.expire, let id = user.id, let amount = amountText.text {
           let doubleAmount = amount.currencyToDouble()
                if let cvvCast = Int(cvv) {
                    payContact(cardNumber: number, cvv: cvvCast, value: doubleAmount, expireDate: expire, userId: id)
                }
            }
    }

    
    func payContact(cardNumber: String, cvv: Int, value: Double, expireDate: String, userId: Int) {
        if (ReachabilityManager.shared.isConnectedToNetwork()){
            HUDHelper.showLoading()
            APIPayments.pay(cardNumber: "1111111111111111", cvv: cvv, value: value, expireDate: expireDate, destinationUserId: userId) { (result, status) in
                switch status {
                case .success(_):
                    guard let rec = result else { return }
                    UIView.animate(withDuration: 0.5) {
                        self.childBottomConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    self.delegate?.setupUI(receipt: rec, card: self.ccSelected!)
                case .failure(_):
                    self.showAlert(NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please check your internet connection.", comment: ""))
                }
                HUDHelper.hideLoading()
            }
        } else {
            self.showAlert(NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please check your internet connection.", comment: ""))
        }
    }
}

extension AmountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        
        return count <= 8
    }
}

