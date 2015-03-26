//
//  User.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/3/26.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation

class User {
    let ID: Int
    var username: String
    var firstName: String?
    var lastName: String?
    var name: String? {
        if firstName != nil && lastName != nil {
            return firstName! + " " + lastName!
        } else if firstName != nil {
            return firstName
        } else {
            return lastName
        }
    }
    var initials: String? {
        var initials: String?
        for name in [firstName, lastName] {
            if let definiteName = name {
                var initial = definiteName.substringToIndex(advance(definiteName.startIndex, 1))
                if initial.lengthOfBytesUsingEncoding(NSNEXTSTEPStringEncoding) > 0 {
                    initials = (initials == nil ? initial : initials! + initial)
                }
            }
        }
        return initials
    }
    
    
    init(){
        ID = -1
        username = "匿名"
    }
    
    
    init(ID: Int, username: String, firstName: String?, lastName: String?) {
        self.ID = ID
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func pictureName() -> String {
        return "User\(ID).jpg"
    }
}
