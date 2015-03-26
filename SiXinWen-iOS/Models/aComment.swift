//
//  aComment.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/3/26.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation


class aComment {
    let incoming: Bool
    let text: String
//    let sentDate: NSDate
    
    init(incoming: Bool, text: String) {
        self.incoming = incoming
        self.text = text
//        self.sentDate = sentDate
    }
}
