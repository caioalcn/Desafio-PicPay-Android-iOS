//
//  String.swift
//  picpayment
//
//  Created by Screencorp Desenvolvimento de Software on 08/03/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation

extension  String {
    
    func currencyFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func currencyToDouble() -> Double {
        
        let noSpaces = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if noSpaces.contains(".") {
            let thousand = noSpaces.replacingOccurrences(of: ".", with: "")
            let changedSeparator = thousand.replacingOccurrences(of: ",", with: ".")
            guard let doubleValue = Double(changedSeparator) else { return 0.0 }
            
            return doubleValue
        } else {
            let changedSeparator = noSpaces.replacingOccurrences(of: ",", with: ".")
            guard let doubleValue = Double(changedSeparator) else { return 0.0 }
            
            return doubleValue
        }
    }
    
    
}
