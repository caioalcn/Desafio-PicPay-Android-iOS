//
//  APIContacts.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 01/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation
import Alamofire

class APIContacts {
    static func getContacts(completion:@escaping ([Contact]?, Result<Any>) -> Void) {
        Client.performRequest(route: .users) { (result) in
            
            guard let json = result.value as? [JSON] else { completion(nil, result)
                return }
            
            var contacts = [Contact]()
            
            for j in json {
                contacts.append(Contact(json: j))
            }
             
            completion(contacts, result)
            
        }
    }
   
}
