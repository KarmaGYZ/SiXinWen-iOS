//
//  User.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/3/26.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation

public class User {
    let ID: Int
    var portrait: String?
    var username: String
//    var currentNews: Int
    var chatMessage = Messages()
//    var newsList = [NewsItem]()
    
    init(ID: Int, username: String, portraitName: String?) {
        self.ID = ID
        self.username = username
        self.portrait = portraitName
//        self.currentNews = 0
    }
    
}
