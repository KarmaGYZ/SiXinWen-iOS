//
//  NewsViewController.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 3/22/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//


import UIKit

class NewsViewController: UITableViewController {
    
    var newsList:[NewsItem]
    let NEWS_PER_PAGE = 5
    
    required init(coder aDecoder:NSCoder){
        newsList = [NewsItem]()
        super.init(coder: aDecoder)
        news_list_update()
        
        
    }
    
    func news_list_update(){
        if(newsList.isEmpty){
            for(var i = 0;i < 5;i++){
                newsList.append(getNewsAtIndex(i))
            }
        }
    }
    
    func getNewsAtIndex(indext:Int)->NewsItem{
        var news = NewsItem()
        news.text = "2015年2月28日,从央视辞职的柴静,推出了她自费拍摄的雾霾深度调查《穹顶之下》"
        news.title = "柴静_穹顶之下"
        news.support = 0.3
        return news
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
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
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     //   let cell = tableView.dequeueReusableCellWithIdentifier("NewsItem") as NewsCell
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsItem", forIndexPath: indexPath) as NewsCell
        let news = newsList[indexPath.row]
        configTitleAndTextForCell(cell,withNewsItem:news)
        configCommentNumForCell(cell,withNewsItem:news)
        configImageForCell(cell, withNewsItem: news)
        configSupportForCell(cell, withNewsItem: news)
        return cell
    }
    
    func configTitleAndTextForCell(cell:NewsCell,withNewsItem news:NewsItem){
        cell.newsTitle.text = news.title
        cell.newsText.text = news.text
    }
    func configCommentNumForCell(cell:NewsCell,withNewsItem news:NewsItem){
        cell.commentNum.text = "评论\(news.commentNum)"
    }
    func configSupportForCell(cell:NewsCell,withNewsItem news:NewsItem){
        cell.support.progress = news.support
    }
    func configImageForCell(cell:NewsCell,withNewsItem news:NewsItem){
        //let image = cell.viewWithTag(1004) as UIImageView
    }
    
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
       self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
