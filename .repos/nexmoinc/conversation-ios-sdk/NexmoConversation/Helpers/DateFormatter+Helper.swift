//
//  DateFormatter+Helper.swift
//  NexmoConversation
//
//  Created by shams ahmed on 11/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

// MARK: - Helper class for formatting dates from backend response
internal extension DateFormatter {
    
    // MARK:
    // MARK: Formatter
    
    /// Formatter for special ISO8601 with AM/PM
    ///
    /// - returns: date formatter
    
    internal static let ISO8601: DateFormatter? = {
        guard let timezone = TimeZone(abbreviation: "GMT") else { return nil }
        
        // translate to Gregorian calendar if other calendar is selected in system settings
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = timezone
        
        // WORKAROUND to ignore device configuration regarding AM/PM http://openradar.appspot.com/radar?id=1110403
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = gregorian
        
        return formatter
    }()
}
