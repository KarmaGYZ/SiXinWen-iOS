//
//  popularComment.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/7.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit



public let toolBarMinHeight: CGFloat = 44
public let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)





class popularComment: UITableViewController , UITableViewDataSource {

    
       
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
//        return comments.loadedComments.count
        
    }
    
    
       
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let commentcell = UITableViewCell(frame: CGRectMake(0, 0, 100, 100))
    
        return commentcell
    
    }
    

}
