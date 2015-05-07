//
//  NewsViewController.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 3/22/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import CoreLocation
import UIKit
import AVOSCloud
import AVOSCloudIM



public var imClient = AVIMClient()

class NewsViewController: UITableViewController , CLLocationManagerDelegate ,AVIMClientDelegate{
    let locationManager = CLLocationManager()
    let NEWS_PER_PAGE = 5
    var newsList:[NewsItem]
    
    required init(coder aDecoder:NSCoder){
        newsList = [NewsItem]()
        super.init(coder: aDecoder)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! CommentViewController
        controller.currentNewsItem = newsList[tableView.indexPathForSelectedRow()!.row]
        
    }

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let currentLocation: AnyObject? = locations.last
        println("位置\(currentLocation)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
    }
    
    

    func news_list_update(){
        
        newsList.removeAll(keepCapacity: false)
        var query = AVQuery(className: "News")
        query.whereKey("Now", equalTo: true)
        query.cachePolicy = AVCachePolicy.NetworkElseCache
        query.maxCacheAge = 356*24*3600
        query.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) -> Void in
            if(result == nil){
                //println("\(error)")
                self.showAlert("无法连接至互联网",message: "请开启网络")
            }
            else{
             //   println("result:\(result)")
                //printf()
                for item in result {
                    var news = NewsItem()
                    news.text = item.objectForKey("Content") as! String
                    news.htmlContent = item.objectForKey("htmlContent") as! String
                    news.title = item.objectForKey("Title") as! String
                    news.commentNum = item.objectForKey("CommentNum") as! Int
                    news.support = item.objectForKey("SupportRatio") as! Float
                    news.leftAttitude = item.objectForKey("AffirmativeView") as! String
                    news.rightAttitude = item.objectForKey("OpposeView") as! String
                    //news.image = UIImageJPEGRepresentation(<#image: UIImage!#>, <#compressionQuality: CGFloat#>)
                    var newsimgFile = item.objectForKey("Picture") as! AVFile
                    newsimgFile.getDataInBackgroundWithBlock(){
                        (imgData:NSData!, error:NSError!) -> Void in
                        if(error == nil){
                            news.image = UIImage(data: imgData)
                            self.tableView.reloadData()
                        }
                    }
                    self.newsList.append(news)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlert(title:String , message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default , handler: {
            action in
        })
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        news_list_update()
        
       self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.tableFooterView = UIView(frame:CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsItem", forIndexPath: indexPath) as! NewsCell
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
        if(news.commentNum < 1000){
            cell.commentNum.text = "评论:\(news.commentNum)"
        }
        else{
            cell.commentNum.text = "评论:\(news.commentNum/1000)k"
        }
    }
    func configSupportForCell(cell:NewsCell,withNewsItem news:NewsItem){
        cell.support.progress = news.support
        cell.support.progressTintColor = leftColor
        cell.support.trackTintColor =  rightColor
    }
    func configImageForCell(cell:NewsCell,withNewsItem news:NewsItem){
        if let image = news.image {
            cell.newsImage.image = image
        }
    }
    
    
    func refresh(sender:AnyObject)
    {
        self.news_list_update()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
//        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imClient.delegate = self
        imClient.openWithClientId(me.username, callback: {
            (success:Bool,error: NSError!) -> Void in
            if(error != nil){
                println("登陆失败!")
                println("错误:\(error)")
            }
        })
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

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
