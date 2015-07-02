//
//  Comments.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/3/26.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation
import UIKit
import AVOSCloudIM

//var dateFormatter = NSDateFormatter()

class InstantMessages{
    
    var loadedMessages = [AVIMTextMessage]() //message array
    var conversation:AVIMConversation?
    var unreadCount: Int = 0 // subtacted from total when read
    
}
