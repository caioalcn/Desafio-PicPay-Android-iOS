//
//  ContactsTableViewCell.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 01/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import UIKit
import SDWebImage

class ContactsCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func setupCell(contact: Contact) {
        
        guard let imgUrl = contact.img else { return }
        guard let user = contact.username else { return }
        guard let name = contact.name else { return }
        
        userImageView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "profile-user.png"))
        userLabel.text = user
        nameLabel.text = name
        
        
    }
    
    

}
