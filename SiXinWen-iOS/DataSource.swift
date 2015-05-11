//
//  DataSource.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/4/7.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import Foundation
import UIKit

class DataSource: NSObject, UITableViewDataSource{
   
    var cellData: [AnyObject]?
    
    var cellIdentifier:String?
    
//    var configureCell: ((AnyObject,AnyObject)->())?
    
    
    init(cellData: [AnyObject], cellIdentifier:String
//        , configureCell:(AnyObject,AnyObject)->()
        )
    {
        super.init()
        self.cellData = cellData
        self.cellIdentifier = cellIdentifier
//        self.configureCell = configureCell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! CommentCell
        
        cell.configureWithComment(cellData![indexPath.row] as! aComment)
        
        return cell
    }
    
    
}
