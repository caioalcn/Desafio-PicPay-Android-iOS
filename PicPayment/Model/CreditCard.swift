//
//  CreditCard.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 08/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation

struct CreditCard: Codable {
    let number: String?
    let type: String?
    let name: String?
    let expire: String?
    let cvv: String?
    
    init(number: String, type: String, name: String, expire: String, cvv: String) {
        self.number = number
        self.type = type
        self.name = name
        self.expire = expire
        self.cvv = cvv
    }
    
}
