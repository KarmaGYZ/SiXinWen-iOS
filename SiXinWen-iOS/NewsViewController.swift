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

class NewsViewController: UITableViewController , CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
//    var newsList:[NewsItem]
    let NEWS_PER_PAGE = 5
    var newsList:[NewsItem]
    
    required init(coder aDecoder:NSCoder){
        newsList = [NewsItem]()
        super.init(coder: aDecoder)
        //news_list_update()
        

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        if segue.identifier == "AddItem" {
        //            let navigationController = segue.destinationViewController as UINavigationController
        //            let controller = navigationController.topViewController as ItemDetailViewController
        //            controller.delegate = self
        //        } else if segue.identifier == "EditItem" {
        //            let navigationController = segue.destinationViewController as UINavigationController
        //            let controller = navigationController.topViewController as ItemDetailViewController
        //            controller.delegate = self
        //
        //            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell){
        //                controller.itemToEdit = items[indexPath.row]
        //            }
        //        }
        let controller = segue.destinationViewController as! CommentViewController
        controller.currentNewsItem = newsList[tableView.indexPathForSelectedRow()!.row]
        
    }

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let currentLocation: AnyObject? = locations.last
        println("位置\(currentLocation)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
       // println("错误\(error)")
    }
    
    

    func news_list_update(){
        
//        if(newsList.isEmpty){
//            for(var i = 0;i < 5;i++){
//                newsList.append(getNewsAtIndex(i))
//            }
//        }
        newsList.removeAll(keepCapacity: false)
        var query = AVQuery(className: "News")
        query.whereKey("Now", equalTo: true)
        query.cachePolicy = AVCachePolicy.NetworkOnly
        query.maxCacheAge = 356*24*3600
       // let array = query.findObjects()
      //  println("数组Sshi")
        query.findObjectsInBackgroundWithBlock(){
            (result:[AnyObject]!, error:NSError!) -> Void in
            if(result == nil){
                //println("\(error)")
                self.showAlert("\(error)")
            }
            else{
             //   println("result:\(result)")
                //printf()
                for item in result {
                    var news = NewsItem()
                    news.text = item.objectForKey("Content") as! String
                    news.title = item.objectForKey("Title") as! String
                    news.commentNum = item.objectForKey("CommentNum") as! Int
                    news.support = item.objectForKey("SupportRatio") as! Float
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
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "无法连接到互联网", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default , handler: {
            action in
            //self.startNewRound()
            //self.updateLabels()
        })
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func getNewsAtIndex(indext:Int)->NewsItem{
        var news = NewsItem()
        news.text = "近日,从央视辞职的柴静,推出了她自费拍摄的雾霾深度调查《穹顶之下》"
        news.title = "柴静_穹顶之下"
        news.support = 0.3
        return news
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        news_list_update()
        //AVQuery.clearAllCachedResults()
        //test code
//        var testobject = AVObject(className: "IOSUserInfo")
//        testobject.setObject("ios_test", forKey: "iostestkey")
//        testobject.setObject("IOSUser", forKey: "UserName")
//        testobject.setObject(0, forKey: "UserId")
//        testobject.save()
//        var query = AVQuery(className: "News")
//        
//        var news = query.getObjectWithId("552d0880e4b0f543686dbdff")
//        var htmlCont = news.objectForKey("htmlContent") as! String
//        println("\(htmlCont)")
//        //news.refresh()
//        var bcktest = AVObject(className: "IOSUserInfo")
//        bcktest.setObject("background save", forKey: "bck")
//        //AVBooleanResultBlock
//        bcktest.saveInBackgroundWithBlock(){(succeeded:Bool,error:NSError!)->Void in
//            if(error == nil){
//                println("Save in back succeed")
//            }
//            else{
//                println("\(error)")
//            }
//        }
    
        
        
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
        return newsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     //   let cell = tableView.dequeueReusableCellWithIdentifier("NewsItem") as NewsCell
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
        //let image = cell.viewWithTag(1004) as UIImageView
    }
    
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
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
