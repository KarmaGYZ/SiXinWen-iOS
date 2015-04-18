//
//  instantComment.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/14.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloudIM

class instantComment: UITableViewController {

    var currentNewsItem:NewsItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentNewsItem.instantComment.loadedMessages.count
        
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
        let singlecomment = currentNewsItem.instantComment.loadedMessages[indexPath.row]
        cell.configureWithMessage(singlecomment)
        return cell
        //        }
        
    }
}
