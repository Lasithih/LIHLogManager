//
//  LIHLogDb.swift
//  Headcount
//
//  Created by Lasith Hettiarachchi on 10/9/15.
//  Copyright (c) 2015 Lasith Hettiarachchi. All rights reserved.
//

import Foundation
import FMDB

class LIHLogDb {
    let ISODateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    var databasePath = NSString()
    var database: FMDatabase?
    
    static let LIHDbInstance: LIHLogDb = LIHLogDb()
    
    static func getInstance() -> LIHLogDb {
        return self.LIHDbInstance
    }
    
    private init(){
        self.database = self.createDatabase()
        if let db = self.database {
            self.createTable(db)
        }
    }
    
    func instatiate(databasePath: String?) {
        let filemgr = NSFileManager.defaultManager()
        
        if let path = databasePath {
            self.databasePath = path
            self.database = FMDatabase(path: path)
            if filemgr.fileExistsAtPath(self.databasePath as String) {
                
                if let db = self.database {
                    self.createTable(db)
                } else {
                    NSLog("[LIHLogDb]Failed to find the database")
                }
                
            } else {
                self.database = self.createDatabase()
                if let db = self.database {
                    self.createTable(db)
                } else {
                }
            }
            
        } else {
            
            self.database = self.createDatabase()
            if let db = self.database {
                self.createTable(db)
            }
        }
    }
    
    private func createDatabase() -> FMDatabase? {
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] 
        
        databasePath = (docsDir as NSString).stringByAppendingPathComponent("LIHLogDatabase.db")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let DB = FMDatabase(path: databasePath as String)
        
            if DB == nil {
                NSLog("Error while craeting the database: \(DB.lastErrorMessage())")
            } else {
                NSLog("LIHLog database created successfully")
            }
            
            return DB
        }
        
        return nil
    }
    
    private func createTable(DB: FMDatabase) {
        
        if DB.open() {
            
            let statement = self.getStatement()
            if !DB.executeStatements(statement) {
                NSLog("TABLE NOT CREATED Error: \(DB.lastErrorMessage())")
            } else {
                NSLog("Log table Created")
            }
            
            DB.close()
            
        }  else {
            NSLog("Error: \(DB.lastErrorMessage())")
        }
    }
    
    private func getStatement() -> String {
        
        
        let table_log = "CREATE TABLE IF NOT EXISTS \(LIHLogDb.Identifier.TABLE_LOG) (\(LIHLogDb.Identifier.LOG_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(LIHLogDb.Identifier.LOG_TYPE) TEXT, \(LIHLogDb.Identifier.LOG_DESCRIPTION) TEXT, \(LIHLogDb.Identifier.LOG_DATE) TEXT, \(LIHLogDb.Identifier.LOG_TIME) TEXT, \(LIHLogDb.Identifier.LOG_DATETIME) TEXT, \(LIHLogDb.Identifier.LOG_APINAME) TEXT)"
        
        return "\(table_log);"
    }
    
    
    
    //Functions
    func insertRecord(log: LIHLog) -> Bool{
        
        
        let DB = FMDatabase(path: self.databasePath as String)

        if DB.open() {
            
            var datetime = ""
            if let dt = log.dateTime {
                datetime = LIHLogDateTimeManager.dateToString(dt, format: ISODateFormat)
            }
            
            
            let queryString = "INSERT INTO \(LIHLogDb.Identifier.TABLE_LOG) (\(LIHLogDb.Identifier.LOG_TYPE),\(LIHLogDb.Identifier.LOG_DESCRIPTION),\(LIHLogDb.Identifier.LOG_DATE),\(LIHLogDb.Identifier.LOG_TIME),\(LIHLogDb.Identifier.LOG_DATETIME),\(LIHLogDb.Identifier.LOG_APINAME)) VALUES ('\(log.type)','\(log.message)','\(log.date)','\(log.time)','\(datetime)','\(log.title)');"
            
            let result = DB.executeStatements(queryString)
            
            if result {
                
                return true
            } else {
                NSLog("[LIHLog] Failed to insert record")
                return false
            }
            
        } else {
            
            NSLog("[LIHLog] Failed to open database while inserting log")
            return false
        }
        
    }
    
    func fetchRecords(numberOfRecords: Int?) -> [LIHLog]{
        
        var logs: [LIHLog] = []
        let DB = FMDatabase(path: self.databasePath as String)
        
        if DB.open() {
            
            var querySQL = "SELECT * FROM \(LIHLogDb.Identifier.TABLE_LOG) ORDER BY \(LIHLogDb.Identifier.LOG_ID) DESC"
            
            if let count = numberOfRecords {
                querySQL = "SELECT * FROM \(LIHLogDb.Identifier.TABLE_LOG) ORDER BY \(LIHLogDb.Identifier.LOG_ID) DESC LIMIT \(count)"
            }
            
            let results:FMResultSet? = DB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results != nil {
                while (results!.next()){
                    let log: LIHLog = LIHLog()
                    log.id = Int(results!.intForColumn(LIHLogDb.Identifier.LOG_ID))
                    log.message = results!.stringForColumn(LIHLogDb.Identifier.LOG_DESCRIPTION)
                    log.date = results!.stringForColumn(LIHLogDb.Identifier.LOG_DATE)
                    log.time = results!.stringForColumn(LIHLogDb.Identifier.LOG_TIME)
                    log.type = results!.stringForColumn(LIHLogDb.Identifier.LOG_TYPE)
                    log.title = results!.stringForColumn(LIHLogDb.Identifier.LOG_APINAME)
                    let datetime = results!.stringForColumn(LIHLogDb.Identifier.LOG_DATETIME)
                    log.dateTime = LIHLogDateTimeManager.stringToDate(datetime, format: ISODateFormat)
                    
                    logs.append(log)
                }

            }
            
            DB.close()
        }
        
        return logs
    }
    
    func clearAll() -> Bool {
        
        let DB = FMDatabase(path: self.databasePath as String)
        
        if DB.open() {
            
            let success = DB.executeStatements("DELETE FROM \(LIHLogDb.Identifier.TABLE_LOG)")
            DB.close()
            return success
            
        } else {
            NSLog("[LIHLog] Failed to open database while inserting log")
            return false
        }
    }
    
    
    
    class Identifier {
    
        static let TABLE_LOG: String = "tableLog"
        static let LOG_ID: String = "logId"
        static let LOG_TYPE: String = "logType"
        static let LOG_DESCRIPTION: String = "logDescription"
        static let LOG_DATE: String = "logDate"
        static let LOG_TIME: String = "logTime"
        static let LOG_DATETIME: String = "logDateTime"
        
        //additional
        static let LOG_APINAME: String = "logApiName"
        
    }
}