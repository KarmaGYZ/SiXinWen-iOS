//
//  PopularMessage.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/6/7.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation


import UIKit
import AVOSCloudIM

//var dateFormatter = NSDateFormatter()


class singleComment{
    var attitude: Bool!
    var text: String!
    var avatar =  UIImage(named: "usrwalker")
    var user:String!
    var commentId:String!
}



class PopularMessages{
    
    //    var lastCommentText: String
    //    var lastCommentSentDate: NSDate
    //    var lastCommentSentDateString: String {
    //        return formatDate(lastCommentSentDcate)
    //    }
    var loadedMessages = [singleComment]()
//    var conversation:AVIMConversation?
    var unreadCount: Int = 0 // subtacted from total when read
    var hasUnloadedMessage = false
    var draft = ""
    
}
