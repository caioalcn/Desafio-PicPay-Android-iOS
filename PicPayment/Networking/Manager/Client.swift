//
//  Client.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 01/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation
import Alamofire

class Client {
    @discardableResult
    static func performRequest(route: RouterEndpoint, completion:@escaping (Result<Any>) -> Void) -> DataRequest {
        return Alamofire.request(route)
            .responseJSON { response in
                completion(response.result)
        }
    }
    
    static func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({$0.cancel()})
        }
    }
}
