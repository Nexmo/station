//
//  Date+Helper.swift
//  NexmoConversation
//
//  Created by shams ahmed on 11/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

internal extension Date {
    
    internal func numberOfDaysUntilDateTime(toDateTime: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = NSCalendar.current
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let difference = calendar.dateComponents([.day], from: self, to: toDateTime)
        let result = difference.day!
        
        return result
    }
}
