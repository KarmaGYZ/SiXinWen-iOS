//
//  NewsItem.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 3/31/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import Foundation
import UIKit
class NewsItem { // news struct
    var text = ""
    var title = ""
    var support:Float = 0.3
    var image:UIImage?
    var commentNum = 50
    var instantComment = InstantMessages()
    var popularComment = PopularMessages()
    var htmlContent = "<html><body><p>hello</p></body></html>"
    var leftAttitude = "蓝方观点"
    var rightAttitude = "红方观点"
}