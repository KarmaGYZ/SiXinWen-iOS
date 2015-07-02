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

// News List view controller
class NewsViewController: UITableViewController , CLLocationManagerDelegate ,AVIMClientDelegate{
    let locationManager = CLLocationManager()
    //let NEWS_PER_PAGE = 5 // default news
    var newsList:[NewsItem] // news list data
    
    required init(coder aDecoder:NSCoder){
        newsList = [NewsItem]()
        super.init(coder: aDecoder)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! CommentViewController
        controller.currentNewsItem = newsList[tableView.indexPathForSelectedRow()!.row]
        // prepare for segue to the comment view controller
        // pass the newsItem data struct to this controller
    }

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let currentLocation: AnyObject? = locations.last
        // get the location
        // to be continue....
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        // location function
        // to be continue....
    }
    

    func news_list_update(){ //asynchronism get the news list
        
        // a query to get the news
        var query = AVQuery(className: "News")
        query.whereKey("Now", equalTo: true)
        query.cachePolicy = AVCachePolicy.NetworkElseCache
        query.maxCacheAge = 356*24*3600
        query.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) -> Void in
            if(result == nil){
                 KVNProgress.showErrorWithStatus("请检查网络")
            }
            else{
                self.newsList.removeAll(keepCapacity: false)
                // remove all the newsItem in newslist
                for item in result {
                    // set every newsitem in result
                    var news = NewsItem()
                    news.text = item.objectForKey("Content") as! String
                    news.htmlContent = item.objectForKey("htmlContent") as! String
                    news.title = item.objectForKey("Title") as! String
                    news.commentNum = item.objectForKey("CommentNum") as! Int
                    news.support = (item.objectForKey("SupportNum") as! Float)/((item.objectForKey("RefuteNum") as! Float)
                        + (item.objectForKey("SupportNum") as! Float))
                    news.leftAttitude = item.objectForKey("AffirmativeView") as! String
                    news.rightAttitude = item.objectForKey("OpposeView") as! String
                    var newsimgFile = item.objectForKey("Picture") as! AVFile
                    newsimgFile.getDataInBackgroundWithBlock(){
                        // asynchronism get the news picture
                        // optimize the network connection
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
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // news_list_update()
        
       self.refreshControl?.addTarget(self, action: "refresh:",
        forControlEvents: UIControlEvents.ValueChanged)
        
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
    
    // configue the newItem cell
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsItem",
            forIndexPath: indexPath) as! NewsCell
        let news = newsList[indexPath.row]
        configTitleAndTextForCell(cell,withNewsItem:news)
        configCommentNumForCell(cell,withNewsItem:news)
        configImageForCell(cell, withNewsItem: news)
        configSupportForCell(cell, withNewsItem: news)
        return cell
    }
    
    // configue the title and text for cell
    func configTitleAndTextForCell(cell:NewsCell,withNewsItem news:NewsItem){
        cell.newsTitle.text = news.title
        cell.newsText.text = news.text
    }
    
    // configue the comment num for cell
    func configCommentNumForCell(cell:NewsCell,withNewsItem news:NewsItem){
        if(news.commentNum < 1000){
            cell.commentNum.text = "评论:\(news.commentNum)"
        }
        else{
            cell.commentNum.text = "评论:\(news.commentNum/1000)k"
        }
    }
    
    // configue the support ratio for cell
    func configSupportForCell(cell:NewsCell,withNewsItem news:NewsItem){
        cell.support.progress = news.support
        cell.support.progressTintColor = leftColor
        cell.support.trackTintColor =  rightColor
    }
    
    // configue the image for cell
    func configImageForCell(cell:NewsCell,withNewsItem news:NewsItem){
        if let image = news.image {
            cell.newsImage.image = image
        }
    }
    
    
    func refresh(sender:AnyObject)
    {
        // update the news list
        self.news_list_update()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
            style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.tabBarController?.tabBar.hidden = false
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // when view appear
        // begin refresh
        self.refreshControl?.beginRefreshing()
        self.refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
   
}
