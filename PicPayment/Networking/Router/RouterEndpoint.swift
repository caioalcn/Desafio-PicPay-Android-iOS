//
//  RouterEndpoint.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 01/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation
import Alamofire

enum RouterEndpoint: APIConfiguration {
    
    case users
    case transaction(cardNumber: String, cvv: Int, value: Double, expiryDate: String, destinationUserIdString: Int)
    
    var method: HTTPMethod {
        switch self {
        case .transaction(_,_,_,_,_):
                return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .transaction(_,_,_,_,_):
            return "/transaction"
        }
        
    }
    
    var header: HTTPHeaders {
        switch self {
        default:
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .users:
            
            return [:]
            
        case .transaction(let cardNumber, let cvv, let value, let expiryDate, let destinationUserId):
            let params = ["card_number": cardNumber, "cvv": cvv, "value": value, "expiry_date": expiryDate, "destination_user_id": destinationUserId] as [String: Any]
            
            return params
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Enviroment.production.rawValue.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.allHTTPHeaderFields = header
        
        // Parameters
        let param = parameters
        let encod = encoding
        
        return try encod.encode(urlRequest, with: param)
    }
}
