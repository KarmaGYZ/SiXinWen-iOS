//
//  popularComment.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/7.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloudIM


public let toolBarMinHeight: CGFloat = 44
public let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)





class popularComment: UITableViewController , UITableViewDataSource {
    
    var currentNewsItem:NewsItem!
       
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentNewsItem.popularComment.loadedMessages.count
        
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = NSStringFromClass(BubbleCell)
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! BubbleCell!
        if cell == nil {
            cell = BubbleCell(style: .Default, reuseIdentifier: cellIdentifier)
            
            // Add gesture recognizers #CopyMessage
            //                     let action: Selector = "showMenuAction:"
            //                     let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
            //                     doubleTapGestureRecognizer.numberOfTapsRequired = 2
            //                     cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
            //                     cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
        }
        cell.backgroundColor = bgColor
        let singlecomment = currentNewsItem.popularComment.loadedMessages[indexPath.row]
        cell.configureWithPopularMessage(singlecomment)
        return cell
        //        }
        
    }

}
