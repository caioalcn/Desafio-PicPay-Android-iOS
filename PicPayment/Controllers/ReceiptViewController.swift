//
//  ReceiptViewController.swift
//  picpayment
//
//  Created by Caio Alcântara on 11/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valuePaidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ReceiptViewController: AmountViewControllerDelegate {
    func setupUI(receipt: Transaction, card: CreditCard) {
        
        if let img = receipt.destinationUser?.img {
            userImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "profile-user.png"))
        }
        
        userNameLabel.text = receipt.destinationUser?.username
        
        if let timestam = receipt.timestamp, let id = receipt.id, let value = receipt.value {
            let timeTransaction = TimeInterval(timestam)
            let time = Date(timeIntervalSince1970: TimeInterval(timeTransaction))
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy - HH:mm"
            
            let date = formatter.string(from: time)
            
            dateLabel.text = date
            transactionLabel.text = "Transaction " + String(id)
            
            let currency = NumberFormatter()
            currency.numberStyle = .currency
            
            if let formattedTipAmount = currency.string(from: NSNumber(value: value)) {
                valuePaidLabel.text = formattedTipAmount
                valueLabel.text = formattedTipAmount
            }
        }
        
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
}
