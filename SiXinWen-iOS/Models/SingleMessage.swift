//
//  aComment.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/3/26.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation


class singleMessage{
    
    let owner: Int
    
    let oppo: Bool
    let text: String
//    let sentDate: NSDate
    
    init(oppo: Bool, text: String, usrID: Int) {
        self.owner = usrID
        self.oppo = oppo
        self.text = text
//        self.sentDate = sentDate
    }
}
