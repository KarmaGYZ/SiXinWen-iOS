//
//  titleView.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/3.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
//
//public let MENU_BOUNCE_OFFSET: CGFloat         = 0
//public let MENU_HEIGHT: CGFloat                = 550
//public let VELOCITY_TRESHOLD: CGFloat          = 300
//
//public let CRITERION = UIScreen.mainScreen().bounds.size.height / 2


class titleView: UIView {
    
    var title:UILabel
    var support:UIProgressView
    
    override init(frame: CGRect){
        
        support = UIProgressView()
        title = UILabel()
        super.init(frame: frame)
        self.backgroundColor = bgColor
        self.alpha = 0.9
        title.text = "穹顶之下"
        title.textAlignment = NSTextAlignment.Center
//        self.addSubview(title)
        support.progress = 0.5
        support.progressTintColor = leftColor
        support.trackTintColor = rightColor
//        self.addSubview(support)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
