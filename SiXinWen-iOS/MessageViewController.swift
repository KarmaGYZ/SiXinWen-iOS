//
//  MessageViewController.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 4/1/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController {
    
    
    @IBOutlet weak var topbar: UIView!
    
    var messageList:[MessageItem]
    
    required init(coder aDecoder:NSCoder){
        messageList = [MessageItem]()
        super.init(coder: aDecoder)
       // messagelist_update()
      //  self.tableView.tableHeaderView = topbar
        
    }
    
    func messagelist_update(){
        for(var i=0;i<5;i++){
            var message = MessageItem()
            message.userName = "肖倾城\(i)号"
            message.messageText = "我是sb"
            messageList.append(message)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.tableHeaderView = topbar
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
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
        //tableView.reloadData()
        super.viewWillDisappear(animated)
       // self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
       // tableView.reloadData()
        super.viewWillAppear(animated)
      //  self.tabBarController?.tabBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if messageList.isEmpty {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoNewMessage", forIndexPath: indexPath) as UITableViewCell
            //tableView.rowHeight = tableView.frame.size.height
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessageItem", forIndexPath: indexPath) as MessageCell
            cell.messageText.text = messageList[messageList.count - indexPath.row - 1].messageText
            cell.userName.text = messageList[messageList.count - indexPath.row - 1].userName
            //tableView.rowHeight = 100.0
            return cell
        }
        // Configure the cell...

       // return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if messageList.isEmpty {
            return tableView.frame.size.height - 150.0
        }
        else {
            return 100.0
        }
    }
    
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        messagelist_update()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
