//
//  LIHLog.swift
//  Headcount
//
//  Created by Lasith Hettiarachchi on 10/9/15.
//  Copyright (c) 2015 Lasith Hettiarachchi. All rights reserved.
//

import Foundation
public class LIHLog {
    public var id: Int = 0
    public var type: String = ""
    public var message: String = ""{
        didSet {
            self.message = self.message.stringByReplacingOccurrencesOfString("'", withString: "''", options: NSStringCompareOptions.LiteralSearch, range: self.message.startIndex..<self.message.endIndex)
        }
    }
    public var date: String = ""
    public var time: String = ""
    public var dateTime: NSDate?
    
    //additional
    public var title: String = ""
    
}