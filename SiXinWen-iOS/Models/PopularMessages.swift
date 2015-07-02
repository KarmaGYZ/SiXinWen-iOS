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

class singleComment{
    var attitude: Bool!
    var text: String!
    var avatar =  UIImage(named: "usrwalker")
    var user:String!
    var commentId:String!
}



class PopularMessages{
    var loadedMessages = [singleComment]()
    var unreadCount: Int = 0 // subtacted from total when read
}
