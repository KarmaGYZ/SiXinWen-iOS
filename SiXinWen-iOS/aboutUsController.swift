//
//  aboutUsController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/5/11.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

class aboutUsController: UIViewController {

    @IBOutlet var iconView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create logo with round corners
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
        iconView.layer.borderColor = UIColor.whiteColor().CGColor
        iconView.layer.borderWidth = 2.3

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
   

}
