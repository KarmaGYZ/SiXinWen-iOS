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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var menu = QBPopupMenu()
//        var replyButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "replyTo:")
//        var threadButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "showThread:")
//        var likeButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "like:")
//        var dislikeButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "dislike:")
//        
//        menu.items = NSArray(objects: replyButton, threadButton, likeButton, dislikeButton) as [AnyObject]
//        
//        menu.showInView(self.view, atPoint: tableView.cellForRowAtIndexPath(indexPath)!.center)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = NSStringFromClass(BubbleCell)
      //  var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! BubbleCell!
      //  if cell == nil {
          var  cell = BubbleCell(style: .Default, reuseIdentifier: cellIdentifier)
            
            // Add gesture recognizers #CopyMessage
            //                     let action: Selector = "showMenuAction:"
            //                     let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
            //                     doubleTapGestureRecognizer.numberOfTapsRequired = 2
            //                     cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
            //                     cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
       // }
        cell.backgroundColor = bgColor
        let singlecomment = currentNewsItem.instantComment.loadedMessages[indexPath.row]
        cell.configureWithInstantMessage(singlecomment)
        var userId = singlecomment.clientId
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
        return cell
        //        }
        
    }
}
