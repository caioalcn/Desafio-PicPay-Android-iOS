//
//  Contact.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 01/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation

struct Contact {
    
    let id: Int?
    let name: String?
    let img: String?
    let username: String?
    
    init(json: JSON) {
        id = json["id"] as? Int
        name = json["name"] as? String
        img  = json["img"] as? String
        username = json["username"] as? String
    }
    
}
