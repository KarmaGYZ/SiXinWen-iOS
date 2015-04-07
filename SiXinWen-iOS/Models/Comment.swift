//
//  Comment.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/3/26.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation



//var dateFormatter = NSDateFormatter()

class Comments {
    let user: User
//    var lastCommentText: String
//    var lastCommentSentDate: NSDate
//    var lastCommentSentDateString: String {
//        return formatDate(lastCommentSentDcate)
//    }
    var loadedComments = [aComment]()
    var unreadCommentCount: Int = 0 // subtacted from total when read
    var hasUnloadedComments = false
    var draft = ""
    
    init(){
        
        user = User()
    
    }
    
    
    init(user: User, lastCommentText: String) {
        self.user = user
//        self.lastCommentText = lastCommentText
//        self.lastCommentSentDate = lastCommentSentDate
    }
    
//    func formatDate(date: NSDate) -> String {
//        let calendar = NSCalendar.currentCalendar()
//        
//        let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
//        let isToday = calendar.isDateInToday(date)
//        let isLast7Days = (calendar.compareDate(NSDate(timeIntervalSinceNow: -7*24*60*60), toDate: date, toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedAscending)
//        
//        if last18hours || isToday {
//            dateFormatter.dateStyle = .NoStyle
//            dateFormatter.timeStyle = .ShortStyle
//        } else if isLast7Days {
//            dateFormatter.dateFormat = "ccc"
//        } else {
//            dateFormatter.dateStyle = .ShortStyle
//            dateFormatter.timeStyle = .NoStyle
//        }
//        return dateFormatter.stringFromDate(date)
//    }
}
