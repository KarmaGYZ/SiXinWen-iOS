//
//  newsContent.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/4/7.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit


class newsContent: UITableViewController , UITableViewDataSource  {

    
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
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        
        let cellIdentifier = NSStringFromClass(newsContentCell)
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! newsContentCell!
        if cell == nil {
            cell = newsContentCell(style: .Default, reuseIdentifier: cellIdentifier)
            
        }
    
        return cell
    }
    
    
        

    
}
