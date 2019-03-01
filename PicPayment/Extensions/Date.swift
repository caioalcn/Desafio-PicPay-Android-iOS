//
//  Date.swift
//  picpayment
//
//  Created by Caio Alcântara on 28/02/19.
//  Copyright © 2019 Red Ice. All rights reserved.
//

import Foundation

extension Date {
    func dateFromString(_ string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    func stringFromDate(_ format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Date {
    static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }
    
    func currentTimeZoneDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dtf.string(from: self)
    }
    
    
}
