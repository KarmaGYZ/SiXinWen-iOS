//
//  NewsItem.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 3/26/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import Foundation

class NewsItem:NSObject, NSCoding {
    var title = ""
    var text = ""
    var commentNum = 0
    var checked = false
    func toggleChecked(){
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as String
        checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
}