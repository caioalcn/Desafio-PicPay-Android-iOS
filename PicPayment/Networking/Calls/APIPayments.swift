//
//  APIPayments.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 01/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation
import Alamofire

class APIPayments {
    static func pay(cardNumber: String, cvv: Int, value: Double, expiryDate: String, destinationUserId: Int, completion:@escaping (Transaction?, Result<Any>) -> Void) {
        Client.performRequest(route: RouterEndpoint.transaction(cardNumber: cardNumber, cvv: cvv, value: value, expiryDate: expiryDate, destinationUserIdString: destinationUserId)) { (result) in

            guard let json = result.value as? JSON else { completion(nil, result)
                return
            }

            guard let t = json["transaction"] as? JSON else { return }
            
            let transaction = Transaction(json: t)

            completion(transaction, result)
        }
    }
}


