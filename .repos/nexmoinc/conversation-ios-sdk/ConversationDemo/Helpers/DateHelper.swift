//
//  DateHelper.swift
//  NexmoChat
//
//  Created by James Green on 26/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//
//TODO: make an extension of NSDate ? fuzzy date 

import Foundation

public class DateHelper {
    
    fileprivate static let formatterHHmm: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    fileprivate static let formatterdMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
    
    fileprivate static let formatteryyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    /// Date to formatted string
    ///
    /// - Parameter date: Date
    /// - Returns: formatted string
    static public func prettyPrint(_ date: Date?) -> String {
        guard date != nil else { return "" }
        
        /* First see if the date is today, if so just return the time. */
        let midnightThisMorning = Calendar.current.startOfDay(for: Date())

        if date!.timeIntervalSince(midnightThisMorning) > 0 {
            
            return formatterHHmm.string(from: date!)
        }
        
        /* See if the date is this week, and if so just return the day of the week. */
        var dateComp = DateComponents()
        dateComp.day = -7
        let oneWeekAgo = Calendar.current.date(byAdding: dateComp, to: Date())
        
        if date!.timeIntervalSince(oneWeekAgo!) > 0 {
            let days: Int = date!.numberOfDaysUntilDateTime(toDateTime: Date())
            return String(format: "%dd", max(1, days))
        }
        
        /* See if the date is this year, and if so return the day and month. */
        var dateComp2 = DateComponents()
        dateComp2.year = -1
        let oneYearAgo = Calendar.current.date(byAdding: dateComp2, to: Date())

        if date!.timeIntervalSince(oneYearAgo!) > 0 {

            return formatterdMMM.string(from: date!)
        }

        return formatteryyyy.string(from: date!)
    }
}
