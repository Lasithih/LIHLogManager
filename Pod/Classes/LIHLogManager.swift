//
//  LIHLogManager.swift
//  Headcount
//
//  Created by Lasith Hettiarachchi on 10/9/15.
//  Copyright (c) 2015 Lasith Hettiarachchi. All rights reserved.
//

import Foundation

enum LIHLogType {
    case Error
}

public class LIHLogManager {
    
    public static func addToLog(message: String, title: String) -> Bool {
        
        let log: LIHLog = LIHLog()
        
        log.type = "Error"
        log.message = message
        log.dateTime = NSDate()
        log.date = LIHLogDateTimeManager.dateToString(log.dateTime!, format: "dd-MM-yyyy")
        log.time = LIHLogDateTimeManager.dateToString(log.dateTime!, format: "HH:mm:ss")
        log.title = title
        let logDb = LIHLogDb.getInstance()
        return logDb.insertRecord(log)
    }
    
    public static func getRecords(numberOfRecords: Int?) -> [LIHLog] {
    
        let logDb = LIHLogDb.getInstance()
        return logDb.fetchRecords(numberOfRecords)
    }
    
    public static func clearLog() -> Bool {
        
        let logDb = LIHLogDb.getInstance()
        return logDb.clearAll()
    }
    
    public static func deleteRecord(withId id: Int) -> Bool {
        
        let logDb = LIHLogDb.getInstance()
        return logDb.deleteRecord(withId: id)
    }
}