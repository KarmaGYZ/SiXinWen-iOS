//
//  MessageViewController.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 4/1/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import CoreLocation
import UIKit
import AVOSCloud
import AVOSCloudIM

var messageList:[MessageItem] = []

class MessageViewController: UITableViewController {
    
    
    @IBOutlet weak var topbar: UIView!
    
    func messagelist_update(){
        // to be continue...
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "refresh:",
            forControlEvents: UIControlEvents.ValueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      
        
        if messageList.isEmpty {
            return 1
        }
        else {
            return messageList.count
        }
    }
    
    

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshControl?.beginRefreshing()
        self.refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if messageList.isEmpty {
            // if message list is empty, just return a no new message cell
            let cell = tableView.dequeueReusableCellWithIdentifier("NoNewMessage",
                forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        else {
            // if it has, configue the message cell for message item
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageItem",
                forIndexPath: indexPath)as! MessageCell
            cell.messageText.text = messageList[messageList.count - indexPath.row - 1].messageText
            cell.userName.text = messageList[messageList.count - indexPath.row - 1].userName
            cell.userPhoto.image = messageList[messageList.count - indexPath.row - 1].userPhoto
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if messageList.isEmpty {
            return tableView.frame.size.height - 150.0
        }
        else {
            return 70.0
        }
    }
    
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        messagelist_update()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

   
}
