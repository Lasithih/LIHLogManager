//
//  LIHLogDateTimeManager.swift
//  Smart Office
//
//  Created by Lasith Hettiarachchi on 10/23/15.
//  Copyright © 2015 fidenz. All rights reserved.
//

import Foundation

class LIHLogDateTimeManager {
    
    static func dateToString(date: NSDate, format: String) -> String {
        
        let formatter: NSDateFormatter = NSDateFormatter()
        let locale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = format
        let dateString: String = formatter.stringFromDate(date)
        
        return dateString
        
    }
    
    static func stringToDate(dateString: String, format: String) -> NSDate? {
        
        let formatter: NSDateFormatter = NSDateFormatter()
        let locale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = format
        if let date: NSDate = formatter.dateFromString(dateString) {
            return date
        }
        
        return nil
    }
}