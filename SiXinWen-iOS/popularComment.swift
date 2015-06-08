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
       // var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! BubbleCell!
       // if cell == nil {
         var   cell = BubbleCell(style: .Default, reuseIdentifier: cellIdentifier)
            
            // Add gesture recognizers #CopyMessage
            //                     let action: Selector = "showMenuAction:"
            //                     let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
            //                     doubleTapGestureRecognizer.numberOfTapsRequired = 2
            //                     cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
            //                     cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
        //}
        cell.backgroundColor = bgColor
        let singlecomment = currentNewsItem.popularComment.loadedMessages[indexPath.row]
        cell.configureWithPopularMessage(singlecomment)
        var userId = singlecomment.user
        // println("userId is \(userId)")
        var query = AVUser.query()
        query.whereKey("username", equalTo: userId)
        query.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) -> Void in
            if error == nil && result.count > 0{
                var user = result[0] as! AVUser
                //user.objectForKey("avartar")
                var avartarFile = user.objectForKey("Avartar") as? AVFile
                if avartarFile != nil{
                    //  println("设置对话头像")
                    //   println("asdfasdfasdf")
                    avartarFile?.getThumbnail(true, width: 60, height: 60){
                        (img:UIImage!, error:NSError!) -> Void in
                        //println(cell)
                        if error == nil{
                            // var tmp = self.tableView.cellForRowAtIndexPath(indexPath)
                            // println(tmp)
                            //cell = self.tableView.cellForRowAtIndexPath(indexPath) as! BubbleCell
                            cell.usrPhoto.image = img
                            //     self.tableView.reloadData()
                        }
                    }
                }
                
            }
            
        }
      //  cell.imageView?.image = singlecomment.avatar
        return cell
        //        }
        
    }

}
