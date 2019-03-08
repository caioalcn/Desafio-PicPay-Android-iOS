//
//  CardCell.swift
//  picpayment
//
//  Created by Caio Alcântara on 03/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCardCell(card: CreditCard) {
        
        cardNumberLabel.text = card.number
        
    }
}
