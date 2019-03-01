//
//  Transaction.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 01/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation

struct Transaction {
    
    let id: Int?
    let timestamp: Int?
    let value: Double?
    let destinationUser: Contact?
    let success: Bool?
    let status: String?
    
    init(json: JSON) {
    
        id = json["id"] as? Int
        timestamp = json["timestamp"] as? Int
        value = json["value"] as? Double
        if let user = json["destination_user"] as? JSON {
            destinationUser = Contact(json: user)
        } else {
            destinationUser = nil
        }
        success = json["success"] as? Bool
        status = json["status"] as? String

    }
}

