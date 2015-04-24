//
//  CommentViewController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/14.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import CoreLocation
import UIKit
import AVOSCloudIM
import AVOSCloud

public let me = User(ID: 1, username: "walker", portraitName: nil)


//let conversation = AVIMConversation()



public let defaultColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
public let leftColor = UIColor(red: 77/255, green: 188/255, blue: 249/255, alpha: 1)
public let highLeftColor = UIColor(red: 51/255.0, green: 102/255.0, blue: 205/255.0, alpha: 1)
public let rightColor = UIColor(red: 253/255, green: 13/255, blue: 68/255, alpha: 1)
public let highRightColor = UIColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1)
public let bgColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)





//class InputTextView: UITextView {
//    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
//        if (delegate as! CommentViewController).tableView.indexPathForSelectedRow() != nil {
//            return action == "copyTextAction:"
//        } else {
//            return super.canPerformAction(action, withSender: sender)
//        }
//    }
//}
//




class CommentViewController: UIViewController , AVIMClientDelegate, UIWebViewDelegate ,UITextViewDelegate {


    var currentNewsItem:NewsItem!
    
    var popularcomment = popularComment()
//    var newscontent = newsContent()
    var instantcomment = instantComment()
    
    var imClient = AVIMClient()
    
    var instantRefresh = UIRefreshControl()
    var popularRefresh = UIRefreshControl()
    
//    var tableView = UITableView()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleview: UIView!
 //   var titleview:titleView!

    
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var newstitle: UILabel!
    var rotating = false
    var showcontent = false

    var webView: UIWebView!
    var scrollView: UIScrollView!
    
    
    var  shiftSegmentControl = UISegmentedControl(frame: CGRectMake(80.0, 8.0, 200.0, 30.0))
    var toolBar:UIToolbar!
    var commentTextView:UITextView!
    var rightButton = UIButton()
    var leftButton = UIButton()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
//                toolBar = UIToolbar(frame: CGRectZero)
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight))
                toolBar.backgroundColor = bgColor
                
                
                leftButton = UIButton.buttonWithType(.Custom) as! UIButton
                leftButton.backgroundColor = leftColor
                leftButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                leftButton.enabled = false
                leftButton.setTitle("动嘴", forState: .Normal)
                leftButton.setTitleColor(leftColor, forState: .Disabled)
                leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                leftButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                leftButton.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(leftButton)
                
                
                rightButton = UIButton.buttonWithType(.Custom) as! UIButton
                rightButton.backgroundColor = rightColor
                rightButton.enabled = false
                rightButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                rightButton.setTitle("开撕", forState: .Normal)
                rightButton.setTitleColor(rightColor, forState: .Disabled)
                rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                rightButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                rightButton.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(rightButton)
                
                
                
                commentTextView = UITextView(frame: CGRectZero)
                commentTextView.backgroundColor = UIColor.greenColor()
                commentTextView.delegate = self
                commentTextView.font = UIFont.systemFontOfSize(FontSize)
                commentTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                commentTextView.layer.borderWidth = 0.5
                commentTextView.layer.cornerRadius = 5
//                commentTextView.scrollsToTop = false
//                commentTextView.textContainerInset = UIEdgeInsetsMake(5.5, 3, 1.5, 3)
                toolBar.addSubview(commentTextView)
            
                
                
                
                // Auto Layout allows `sendButton` to change width, e.g., for localization.
                leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                commentTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
                rightButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Left, relatedBy:.Equal , toItem: toolBar, attribute: .Left, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Right, relatedBy:.Equal , toItem: toolBar, attribute: .Left, multiplier: 1, constant: 50))
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Top, relatedBy:.Equal , toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: -25))
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Bottom, relatedBy: .Equal, toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: 0))
                
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Left, relatedBy: .Equal, toItem: leftButton, attribute: .Right, multiplier: 1, constant: 2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 3.5))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Right, relatedBy: .Equal, toItem: rightButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -3.5))
                
                
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: -50))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Top, relatedBy:.Equal , toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: -25))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Bottom, relatedBy: .Equal, toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: 0))
            }
            return toolBar
        }
    }

    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        currentNewsItem.instantComment.conversation.quitWithCallback(){
            (success:Bool,error: NSError!) -> Void in
            if(!success){
                println("退出群组失败!")
                println("错误:\(error)")
            }
            else{
                //println("xiao")
            }
        }
      //  me.newsList[me.currentNews].instantComment.draft = commentTextView.text
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        shiftSegmentControl.insertSegmentWithTitle("即时评论", atIndex: 1, animated: true)
        shiftSegmentControl.insertSegmentWithTitle("热门评论", atIndex: 0, animated: true)
        shiftSegmentControl.selectedSegmentIndex = 1
        shiftSegmentControl.multipleTouchEnabled = false
        shiftSegmentControl.userInteractionEnabled = true
        shiftSegmentControl.addTarget(self, action: "shiftSegment:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = shiftSegmentControl
        
        
        //login the leancloud
       // var imClient = AVIMClient()
                
        //AVIMBooleanResultBlock
        
//        tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        
        
       // self.comment_refresh()
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        self.tableView.contentInset = edgeInsets
        instantcomment.currentNewsItem = currentNewsItem
        popularcomment.currentNewsItem = currentNewsItem
        self.tableView.dataSource = instantcomment
        self.tableView.keyboardDismissMode = .Interactive
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .None
        tableView.registerClass(BubbleCell.self, forCellReuseIdentifier: NSStringFromClass(BubbleCell))
        
        let tap = UITapGestureRecognizer(target: self, action: "didTap:")
        titleview.addGestureRecognizer(tap)
        
        
        scrollView = UIScrollView(frame: CGRectMake(0, 45 ,UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height - 45))
        scrollView.backgroundColor = bgColor
        webView = UIWebView(frame: scrollView.frame )
        scrollView.hidden = true
        
        webView.scalesPageToFit = false

        webView.loadHTMLString(currentNewsItem.htmlContent, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath))

        
        
        titleview.addSubview(scrollView)
        scrollView.addSubview(webView)
        
        
        webView.delegate = self
        
        newstitle.text = currentNewsItem.title
        
        
        tableView.addPullToRefresh({ [weak self] in
            sleep(1)
          
            self!.comment_refresh()
            })


        let notificationCenter = NSNotificationCenter.defaultCenter()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuControllerWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil)
    
      //  self.comment_refresh()
        
        }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
       
        self.comment_refresh()
       // self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        
        if !currentNewsItem.instantComment.draft.isEmpty {
            commentTextView.text = currentNewsItem.instantComment.draft
            currentNewsItem.instantComment.draft = ""
            textViewDidChange(commentTextView)
            commentTextView.becomeFirstResponder()
        }
    }
    
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
            if toolBar.frame.height > textViewMaxHeight.landscape {
                toolBar.frame.size.height = textViewMaxHeight.landscape + 8 * 2
            }
        } else { // portrait
            updateTextViewHeight()
        }
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imClient.delegate = self
        imClient.openWithClientId(me.username, callback: {
            (success:Bool,error: NSError!) -> Void in
            if(!success){
                println("登陆失败!")
                println("错误:\(error)")
            }
            else{
                //println("xiao")
            }
        })
        var converQuery = imClient.conversationQuery()
        converQuery.whereKey("title", equalTo: currentNewsItem.title)
        converQuery.findConversationsWithCallback(){
            (result:[AnyObject]!, error:NSError!) -> Void in
            if(error != nil){
                println("查询对话失败")
                println("错误:\(error)")
            }
            else{
                println("\(result)")
                if(result.count>1){
                    println("对话数超过1")
                }
                else if(result.count == 0){
                    println("未找到对话")
                }
                else{
                    self.currentNewsItem.instantComment.conversation = result[0] as! AVIMConversation
                    self.currentNewsItem.instantComment.conversation.joinWithCallback(){
                        (success:Bool,error: NSError!) -> Void in
                        if(error != nil){
                            println("加入群组失败!")
                        }
                    }
                }
            }
        }

        self.tabBarController?.tabBar.hidden = true
    }
    

    func shiftSegment(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            toolBar.hidden = true
            tableView.dataSource = popularcomment
            tableView.reloadData()
            break
            
        case 1:
            toolBar.hidden = false
            tableView.dataSource = instantcomment
            tableView.reloadData()
            break
            
        default: break
            
        }
        
    }

    
    
    func updateTextViewHeight() {
        let oldHeight = commentTextView.frame.size.height
                println("old \(oldHeight)")
//            println("toolbar height \(toolBar.frame.height)")
        if oldHeight <= 80 {
//        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
//        var newHeight = min(commentTextView.sizeThatFits(CGSize(width: commentTextView.frame.width, height: CGFloat.max)).height, maxHeight)
         var newHeight = commentTextView.contentSize.height
//        #if arch(x86_64) || arch(arm64)
//            newHeight = ceil(newHeight)
//            #else
//            newHeight = CGFloat(ceilf(newHeight.native))
//        #endif
                 println("new \(newHeight)")
        var heightChange = newHeight - oldHeight
        println(heightChange)
        if heightChange > 10 {
            var oldBarFrame = toolBar.frame
            println(oldBarFrame)
            println("enhum \(heightChange)")
//            toolBar.frame = CGRectMake(0, commentTextView.frame.origin.y - heightChange, oldBarFrame.width, commentTextView.frame.height + 7 + heightChange )
            
    
            commentTextView.frame.size.height =  newHeight
            
        }
        }
   
        
        
        
        
        
    }
    
    
    
    func textViewDidChange(textView: UITextView) {
        updateTextViewHeight()
        leftButton.enabled = textView.hasText()
        rightButton.enabled = textView.hasText()
    }

    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = self.tableView.convertRect(frameNew, fromView: nil).height
        let insetOld = self.tableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        let overflow = self.tableView.contentSize.height - (self.tableView.frame.height-insetOld.top-insetOld.bottom)
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations: (() -> Void) = {
            if !(self.tableView.tracking || self.tableView.decelerating) {
                // Move content with keyboard
                if overflow > 0 {                   // scrollable before
                    self.tableView.contentOffset.y += insetChange
                    if self.tableView.contentOffset.y < -insetOld.top {
                        self.tableView.contentOffset.y = -insetOld.top
                    }
                } else if insetChange > -overflow { // scrollable after
                    self.tableView.contentOffset.y += insetChange + overflow
                }
            }
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        
        // Inset `tableView` with keyboard
        let contentOffsetY = tableView.contentOffset.y
        tableView.contentInset.bottom = insetNewBottom
        tableView.scrollIndicatorInsets.bottom = insetNewBottom
        // Prevents jump after keyboard dismissal
        if self.tableView.tracking || self.tableView.decelerating {
            tableView.contentOffset.y = contentOffsetY
        }
    }
    
    
    func comment_refresh(){
        
        if shiftSegmentControl.selectedSegmentIndex == 1 {
            var date = NSDate()
           // INT64_MAX
            var oldestMsgTimestamp:Int64 = Int64(date.timeIntervalSince1970*1000)
           // println(oldestMsgTimestamp)
//             println("hello1")
            if(self.currentNewsItem.instantComment.loadedMessages.count == 0){
//                println("hello2")
                self.currentNewsItem.instantComment.conversation.queryMessagesBeforeId(nil, timestamp: oldestMsgTimestamp , limit: 5 ){
                    (objects:[AnyObject]!,error: NSError!) -> Void in
                    if (error != nil) {
                        println("刷新错误:\(error)")
                       // AVHistoryMessageQuery
                    }
                    else {
                       //println(objects)
                        println("hello")
                        var index = 0
                        for newMessage in objects{
                         self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMMessage), atIndex: index)
                            index++
                        }
                        self.tableView.reloadData()
                    }
                   // println("hello6")
                }
            }
            else{
//                println("hello3")
                println("\(self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp)")
                self.currentNewsItem.instantComment.conversation.queryMessagesBeforeId(self.currentNewsItem.instantComment.loadedMessages[0].messageId, timestamp: self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp , limit: 10 ){
                    (objects:[AnyObject]!,error: NSError!) -> Void in
                    if (error != nil) {
                        println("刷新错误:\(error)")
                    }
                    else {
                        println(objects)
                        //       println("hello")
                        var index = 0
                        for newMessage in objects{
                            self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMMessage), atIndex:index)
                            index++
                        }
                        self.tableView.reloadData()
                    }
                }
            }
       //    println("hello4")
        }
        else {
       //      println("hello2")
//            
//            conversation.queryMessagesBeforeId(currentNewsItem.popularComment.loadedMessages[0].messageId, timestamp: 0, limit: 20) {
//                (objects:[AnyObject]!,error: NSError!) -> Void in
//                if (error != nil) {
//                    let alert = UIAlertView(title: "操作失败", message: error.description, delegate: nil, cancelButtonTitle: "OK")
//                    alert.show()
//                }
//                else {
//                    self.tableView.reloadData()
//                }
//            }
//
//            
//            
        }
//        println("hello5")

    }
    
    
    
    func historyMessage2AVIMMessage(historyMessage:AVHistoryMessage)->AVIMMessage{
        var result = AVIMMessage()
        result.conversationId = historyMessage.conversationId
        result.clientId = historyMessage.fromPeerId
        
      //  println(historyMessage)
       // println("123")
        
        if historyMessage.payload != nil{
        result.content = historyMessage.payload
        }
        else {
        result.content = "34534534/r"
        }
     //   println("5")
        result.sendTimestamp = historyMessage.timestamp
        
        return result
    }
    
    
    
    func comment_send(newComment: AVIMMessage ){
        
       currentNewsItem.instantComment.loadedMessages.append(newComment)
        currentNewsItem.instantComment.conversation.sendMessage(newComment) {
            (success:Bool,error: NSError!) -> Void in
            if(!success){
                println("发送失败!")
                println("错误:\(error)")
            }
        }
        Redrawcomment()
    }
    
    
    func Redrawcomment() {
        let lastsec = tableView.numberOfSections() - 1
        let lastrow = tableView.numberOfRowsInSection(lastsec)
        tableView.beginUpdates()
        
        tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: lastrow, inSection: lastsec)
            ], withRowAnimation: .Automatic)
        tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
        
    }
    
    
    
    func sendAction(sender: UIButton) {
        // Autocomplete text before sending #hack
        commentTextView.resignFirstResponder()
        commentTextView.becomeFirstResponder()
        var content : String
        if sender.titleLabel?.text == "动嘴"{
          content = commentTextView.text.stringByAppendingPathComponent("l")
        }
        else {
         content = commentTextView.text.stringByAppendingPathComponent("r")
        }
//        println(content)
        
        let singleComment = AVIMMessage(content: content)
       
        
        commentTextView.text = nil
        updateTextViewHeight()
        leftButton.enabled = false
        rightButton.enabled = false
        
        
        comment_send(singleComment)
    }
    
    
    
    func menuControllerWillHide(notification: NSNotification){
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
        (notification.object as! UIMenuController).menuItems = nil
        
    }
    
    
    
    
    func didTap(sender: UITapGestureRecognizer) {
        
        let frame = CGRectMake(0, 0, arrow.image!.size.height, arrow.image!.size.width);
        
        if showcontent == false {
            showcontent = true
            toolBar.hidden = true
//            tableView.removePullToRefresh()
            
//            tableView.dataSource = newscontent
//            tableView.reloadData()
            arrow.image = UIImage(named: "arrowUp")
            shiftSegmentControl.hidden = true
            scrollView.hidden = false
            tableView.hidden = true
//            webView.hidden = false
            
//            let oldFrame = titleview.frame
//            titleview.frame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.width, oldFrame.height + 100)
//            let tableFrame = tableView.frame
//            tableView.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y + 100, tableFrame.width, tableFrame.height)
//            println("old\(oldFrame.height), new\(titleview.frame.height)")
//            titleview.backgroundColor = UIColor.redColor()
            
        } else {
            toolBar.hidden = false
            showcontent = false
            arrow.image = UIImage(named: "arrowDown")
            tableView.hidden = false
//            tableView.addPullToRefresh({ [weak self] in
//                sleep(1)
//                self!.comment_refresh()
//                })
            shiftSegmentControl.hidden = false
            scrollView.hidden = true
//            let oldFrame = titleview.frame
//            titleview.frame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.width,oldFrame.height - webView.frame.height)
//            
            
//            webView.hidden = true
//            if shiftSegmentControl.selectedSegmentIndex == 1 {
//                tableView.dataSource = instantcomment
//            }
//            else {
//                tableView.dataSource = popularcomment
//            }
//            //       tableView.dataSource
//            tableView.reloadData()
            
        }
        
        
    }
    
    
    
    func tableViewScrollToBottomAnimated(animated: Bool) {
        let lastSection = tableView.numberOfSections() - 1
        let numberOfRows = tableView.numberOfRowsInSection(lastSection)
        //println(lastSection)
        //        println(numberOfRows)
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: lastSection), atScrollPosition: .Bottom, animated: animated)
        
    }
    

    func webViewDidFinishLoad(webView: UIWebView) {
        var newFrame = webView.frame
        var actualSize = webView.sizeThatFits(CGSizeZero)
//                    cellheight = actualSize.height
        newFrame.size = actualSize
        webView.frame = newFrame
        scrollView.contentSize = CGSize(width: actualSize.width, height: actualSize.height + 200)
       // println("as\(actualSize) ch:\(cellheight)")
        
        
        
        
    }

    func conversation(conversation: AVIMConversation!, didReceiveCommonMessage message: AVIMMessage!) {
        currentNewsItem.instantComment.loadedMessages.append(message)
        Redrawcomment()
    }
    
    
}
