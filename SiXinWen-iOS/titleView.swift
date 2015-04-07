//
//  titleView.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/3.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

public let MENU_BOUNCE_OFFSET: CGFloat         = 0
public let MENU_HEIGHT: CGFloat                = 550
public let VELOCITY_TRESHOLD: CGFloat          = 300

public let CRITERION = UIScreen.mainScreen().bounds.size.height / 2


class titleView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.alpha = 0.9
        let title = UILabel(frame: CGRectMake(0, 0,self.frame.width, self.frame.height))
        title.text = "穹顶之下"
        title.textAlignment = NSTextAlignment.Center
        self.addSubview(title)
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
