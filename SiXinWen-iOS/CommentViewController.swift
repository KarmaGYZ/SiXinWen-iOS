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



let instant = 0 , popular = 1

let momentIndex = 0, friendIndex = 1

let leftButtonTag = 4, rightButtonTag = 5

class CommentViewController: UIViewController, AVIMClientDelegate,
UIWebViewDelegate, UITextViewDelegate, UIAlertViewDelegate, QBPopupMenuDelegate{

    var menu = QBPopupMenu()   // the popup menu
    var currentNewsItem:NewsItem!   // the new that you're reading
    var popularcomment = popularComment()   //popular comment datasource
    var instantcomment = instantComment()   //instant comment datasource
    var imClient = AVIMClient()
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleview: UIView!

    @IBOutlet var leftAttitude: UILabel!
    
    
    @IBOutlet var rightAttitude: UILabel!
    
    @IBOutlet var arrow: UIImageView!
    
    
    @IBOutlet var newstitle: UILabel!
    
    
    var showcontent = false  // ture means showing the news content
    var selectedIdx: NSIndexPath?   // the selected row
    var webView: UIWebView!
    var scrollView: UIScrollView!
    var  shiftSegmentControl:UISegmentedControl!
    var toolBar:UITabBar!
    var commentTextView:UITextView!
    var rightButton = UIButton()
    var leftButton = UIButton()
    
    deinit {
        // deinit the notification center
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // init the comment input view
    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
                
                toolBar = UITabBar()
                toolBar.backgroundColor = bgColor
                
                // init the left send button
                leftButton = UIButton.buttonWithType(.Custom) as! UIButton
                leftButton.setBackgroundImage(UIImage(named:"leftButton"), forState: .Normal)
                leftButton.tag = leftButtonTag
                leftButton.enabled = false
                leftButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                leftButton.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(leftButton)
                
                // init the right send button
                rightButton = UIButton.buttonWithType(.Custom) as! UIButton
                rightButton.enabled = false
                rightButton.setBackgroundImage(UIImage(named:"rightButton"), forState: .Normal)
                rightButton.tag = rightButtonTag
                rightButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                rightButton.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(rightButton)
                
                // init the comment text view
                commentTextView = UITextView(frame: CGRectZero)
                commentTextView.delegate = self
                commentTextView.font = UIFont.systemFontOfSize(FontSize)
                commentTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                commentTextView.layer.borderWidth = 0.5
                commentTextView.layer.cornerRadius = 5
                toolBar.addSubview(commentTextView)
            
                
                // set layouts for those things
                leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                commentTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
                rightButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                
                // set layout for left button
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Left,
                    relatedBy:.Equal , toItem: toolBar, attribute: .Left, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Right,
                    relatedBy:.Equal , toItem: toolBar, attribute: .Left, multiplier: 1, constant: 50))
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Top,
                    relatedBy:.Equal , toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: -25))
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Bottom,
                    relatedBy: .Equal, toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: 0))
                
                // set layout for comment text view
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Left,
                    relatedBy: .Equal, toItem: leftButton, attribute: .Right, multiplier: 1, constant: 2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Top,
                    relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 6))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Right,
                    relatedBy: .Equal, toItem: rightButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Bottom,
                    relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -6))
                
                // set layout for right button
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Right,
                    relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Left,
                    relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: -50))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Top,
                    relatedBy:.Equal , toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: -25))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Bottom,
                    relatedBy: .Equal, toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: 0))
                
                
                toolBar.autoresizingMask = .FlexibleHeight | .FlexibleBottomMargin
                
                
            }
            return toolBar
        }
    }

    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // quit the conversation
        if currentNewsItem.instantComment.conversation != nil {
            currentNewsItem.instantComment.conversation!.quitWithCallback(){
                (success:Bool,error: NSError!) -> Void in
                if(!success){
                    // fail to quit the conversation
                    KVNProgress.showErrorWithStatus("请检查网络")
                }
            }
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init the segment conrtol in navigation bar
        shiftSegmentControl = UISegmentedControl(frame: CGRectMake(80.0, 8.0, 200.0, 30.0))
        shiftSegmentControl.insertSegmentWithTitle("即时评论", atIndex: instant, animated: true)
        shiftSegmentControl.insertSegmentWithTitle("热门评论", atIndex: popular, animated: true)
        shiftSegmentControl.selectedSegmentIndex = instant
        shiftSegmentControl.multipleTouchEnabled = false
        shiftSegmentControl.userInteractionEnabled = true
        // add shift action
        shiftSegmentControl.addTarget(self, action: "shiftSegment:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = shiftSegmentControl
        
        // init the share button
        var imgView = UIImageView(frame: CGRectMake(0, 0, 23, 23))
        imgView.image = UIImage(named: "Share-100-1")
        // add share action
        let tapGesture = UITapGestureRecognizer(target: self, action: "share")
        imgView.addGestureRecognizer(tapGesture)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imgView)
        
        // init the table view
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        self.tableView.contentInset = edgeInsets
        instantcomment.currentNewsItem = currentNewsItem
        popularcomment.currentNewsItem = currentNewsItem
        self.tableView.dataSource = instantcomment
        self.tableView.delegate = instantcomment
        self.tableView.keyboardDismissMode = .OnDrag
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .None
        tableView.registerClass(BubbleCell.self, forCellReuseIdentifier: NSStringFromClass(BubbleCell))
        
        // add tap action to the news title view
        let tap = UITapGestureRecognizer(target: self, action: "didTap:")
        titleview.addGestureRecognizer(tap)

        // set other things
        newstitle.text = currentNewsItem.title
        leftAttitude.text = currentNewsItem.leftAttitude
        rightAttitude.text = currentNewsItem.rightAttitude
        
        // add refresh action
        tableView.addPullToRefresh({ [weak self] in
            sleep(1)
            self!.comment_refresh()
            })
 
        // init the scroll view
        scrollView = UIScrollView(frame: CGRectZero)
        scrollView.backgroundColor = bgColor
        view.addSubview(scrollView)
        
        // set layout for scroll view
         scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Right,
            relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Left,
            relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top,
            relatedBy: .Equal, toItem: titleview, attribute: .Bottom, multiplier: 1, constant: 0))
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Bottom,
            relatedBy: .Equal, toItem: titleview, attribute: .Bottom, multiplier: 1, constant: 0))
        
        // init the web view
        webView = UIWebView(frame: UIScreen.mainScreen().bounds)
        webView.delegate = self
        webView.scalesPageToFit = false
        webView.loadHTMLString(currentNewsItem.htmlContent, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath))
        scrollView.addSubview(webView)
        
        // observe keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: nil)
        
        // add tap action to each cell to pop up the menu
        var tapCellGesture = UITapGestureRecognizer(target: self, action: "tapCell:")
        self.tableView.addGestureRecognizer(tapCellGesture)
        
        // init the popup menu
        var replyButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "replyTo")
        // var threadButton = QBPopupMenuItem(image: UIImage(named: "menuThread"), target: self, action: "showThread")  
        // To be continued...
        var likeButton = QBPopupMenuItem(image: UIImage(named: "menuLike"), target: self, action: "likeMessages")
        var dislikeButton = QBPopupMenuItem(image: UIImage(named: "menuDislike"), target: self, action: "dislikeMessages")
        menu.items = NSArray(objects: replyButton, likeButton, dislikeButton) as [AnyObject]
        menu.delegate = self
        
        }
    
 
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // scroll to the bottom
        if currentNewsItem.instantComment.loadedMessages.count != 0 {
            self.tableView.scrollToRowAtIndexPath(
                NSIndexPath(forRow: self.currentNewsItem.instantComment.loadedMessages.count - 1 , inSection: 0),
                atScrollPosition: .Top, animated: false)
        }
   
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        
        // log in
        imClient.delegate = self
        imClient.openWithClientId(me.username, callback: {
            (success:Bool,error: NSError!) -> Void in
            if(!success){
                // fail to log in
                KVNProgress.showErrorWithStatus("请检查网络")
            }
            else{
                // find the conversation
                var converQuery = self.imClient.conversationQuery()
                converQuery.whereKey("title", equalTo: self.currentNewsItem.title)
                converQuery.findConversationsWithCallback(){
                    (result:[AnyObject]!, error:NSError!) -> Void in
                    if(error != nil){
                        // fail to find the conversation
                        KVNProgress.showErrorWithStatus("请检查网络")
                    }
                    else{
                        if(result.count > 1){
                            // error in the server
                            KVNProgress.showErrorWithStatus("服务器内部错误")
                        }
                        else if(result.count == 0){
                            // fail to find the conversation
                            KVNProgress.showErrorWithStatus("服务器内部错误")
                        }
                        else{
                            // try to join the conversation
                            self.currentNewsItem.instantComment.conversation = (result[0] as! AVIMConversation)
                            self.currentNewsItem.instantComment.conversation!.joinWithCallback(){
                                (success:Bool,error: NSError!) -> Void in
                                if(error != nil){
                                    // fail to join the conversation
                                    KVNProgress.showErrorWithStatus("请检查网络")
                                }
                                else {
                                    self.comment_refresh()
                                }
                            }
                        }
                    }
                }

            }
        })

       
    }
    

    func popupMenuWillDisappear(popupMenu: QBPopupMenu!) {
        // when tapping other fields , the selected row should be deselected
        if selectedIdx != nil && self.tableView.cellForRowAtIndexPath(selectedIdx!) != nil {
            (self.tableView.cellForRowAtIndexPath(selectedIdx!)
                as! BubbleCell).bubbleImageView.highlighted = false
            selectedIdx = nil
        }
    }
    
    
    
    // share current news to wechat via shareSDK
    func share(){
        
        var imagePath = NSBundle.mainBundle().pathForResource("AppIcon", ofType: "png")
        
        var publishContent = ShareSDK.content("分享", defaultContent: currentNewsItem.text,
            image: ShareSDK.imageWithPath(imagePath), title: "对于 \(currentNewsItem.title) 我的态度是?",
            url: "http://dev.sixinwen.avosapps.com/share?nid=5573e468e4b03c3d0281e5ae",
            description: currentNewsItem.text, mediaType: SSPublishContentMediaTypeNews)
        
        var container = ShareSDK.container()
        container.setIPadContainerWithView(self.view, arrowDirect: UIPopoverArrowDirection.Up)
        
        ShareSDK.showShareActionSheet(container, shareList: nil, content: publishContent,
            statusBarTips: true, authOptions: nil, shareOptions: nil, result: {
            (type:ShareType, state:SSResponseState , statusInfo:AnyObject!, error:AnyObject!, end:Bool)  in
            if state.value == SSResponseStateFail.value {
                KVNProgress.showErrorWithStatus("分享失败")
            }
        
        })
    }
    
    
    
    func showThread(){
        //to be continued...
    }
    
    
    // reply to the selected comment
    func replyTo(){
        if selectedIdx != nil {
            self.commentTextView.text =
            "@\(currentNewsItem.instantComment.loadedMessages[selectedIdx!.row].clientId) "
            self.commentTextView.becomeFirstResponder()
        }
        
        
    }
    
    // send like to a comment
    func likeMessages() {
        if selectedIdx != nil{
            // send like to an instant comment
            if shiftSegmentControl.selectedSegmentIndex == instant{
                var message = currentNewsItem.instantComment.loadedMessages[selectedIdx!.row] as AVIMTextMessage
                var attribute = message.attributes
                if attribute["commentId"] != nil {
                    var commentId = attribute["commentId"]! as! String
                    var query = AVQuery(className: "Comments")
                    query.getObjectInBackgroundWithId(commentId){
                        (comment:AVObject!, error:NSError!) -> Void in
                        if comment != nil {
                            comment.incrementKey("Like")
                            comment.incrementKey("heat")
                            comment.saveInBackground()
                        }
                    }
                }
                
            }
            else {
                // send like to a popular commment
                var message = currentNewsItem.popularComment.loadedMessages[selectedIdx!.row] as singleComment
                var commentId = message.commentId
                var query = AVQuery(className: "Comments")
                query.getObjectInBackgroundWithId(commentId){
                    (comment:AVObject!, error:NSError!) -> Void in
                    if comment != nil {
                        comment.incrementKey("Like")
                        comment.incrementKey("heat")
                        comment.saveInBackground()
                    }
                }
                
            }
            
        }
        
    }
    
     // send dislike to a comment
    func dislikeMessages() {
        if selectedIdx != nil{
            // send dislike to an instant comment
            if shiftSegmentControl.selectedSegmentIndex == instant{
                var message = currentNewsItem.instantComment.loadedMessages[selectedIdx!.row] as AVIMTextMessage
                var attribute = message.attributes
                if attribute["commentId"] != nil {
                    var commentId = attribute["commentId"]! as! String
                    var query = AVQuery(className: "Comments")
                    query.getObjectInBackgroundWithId(commentId){
                        (comment:AVObject!, error:NSError!) -> Void in
                        if comment != nil {
                            comment.incrementKey("Dislike")
                            comment.incrementKey("heat")
                            comment.saveInBackground()
                        }
                    }
                    
                }
                
            }
            else {
                 // send dislike to a popular commment
                var message = currentNewsItem.popularComment.loadedMessages[selectedIdx!.row] as singleComment
                var commentId = message.commentId
                var query = AVQuery(className: "Comments")
                query.getObjectInBackgroundWithId(commentId){
                    (comment:AVObject!, error:NSError!) -> Void in
                    if comment != nil {
                        comment.incrementKey("Dislike")
                        comment.incrementKey("heat")
                        comment.saveInBackground()
                    }
                }
                
            }
        }
        
    }
    
    
    
    // tap a cell then the menu will pop up
    func tapCell(tap:UIGestureRecognizer){
        // find the index path of the selected cell
        var p:CGPoint = tap.locationInView(self.tableView)
        var point = tap.locationInView(self.view)
        var indexPath = self.tableView.indexPathForRowAtPoint(p)
        
        if indexPath != nil {
            // dehighlight the old selected row
            if selectedIdx != nil && self.tableView.cellForRowAtIndexPath(selectedIdx!) != nil {
                (self.tableView.cellForRowAtIndexPath(selectedIdx!) as! BubbleCell).bubbleImageView.highlighted = false
            }
            // highlight this new selected row
            (self.tableView.cellForRowAtIndexPath(indexPath!) as! BubbleCell).bubbleImageView.highlighted = true
            selectedIdx = indexPath
            
            // pop up the menu
            menu.showInView(self.view, atPoint:CGPointMake(self.tableView.cellForRowAtIndexPath(indexPath!)!.center.x, point.y))
        }
    }
    
    // shift between instant comments and popular comments
    func shiftSegment(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
            // display the popular comments
        case popular:
            menu.dismiss()
            // change the datasource and delegate
            tableView.dataSource = popularcomment
            tableView.delegate = popularcomment
            tableView.reloadData()
            UIView.transitionFromView(tableView, toView: tableView, duration: 0.3,
                options:.TransitionFlipFromLeft | .ShowHideTransitionViews, completion: nil)
            
            break
            
            // display the instant comments
        case instant:
            menu.dismiss()
           // change the datasource and delegate
            tableView.dataSource = instantcomment
            tableView.delegate = instantcomment
            tableView.reloadData()
            UIView.transitionFromView(tableView, toView: tableView, duration: 0.3,
                options:.TransitionFlipFromRight | .ShowHideTransitionViews, completion: nil)
            break
            
        default: break
            
        }
        
    }

    
    func textViewDidChange(textView: UITextView) {
        updateTextViewHeight()
        leftButton.enabled = textView.hasText()
        rightButton.enabled = textView.hasText()
    }
    

    // update the height of comment text view
    func updateTextViewHeight() {
        
        let oldHeight = self.toolBar.frame.size.height
        var newHeight = self.commentTextView.contentSize.height + 14
        
        let heightChange = newHeight - oldHeight
            println(heightChange)
        
        if newHeight < 51 {
            // set the min height to 51
            newHeight = 51
        }
        else if newHeight > 80{
            // set the max height to 80
            newHeight = 80
        }
        if  (heightChange > 0 && oldHeight < 60) || (heightChange < 0 ) {
            
            var constraints: NSArray = self.inputAccessoryView.constraints()
            
            let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                return  (constraint.firstAttribute == .Height)
            }
            
            // remove the old height constraint
            self.inputAccessoryView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
            
            UIView.animateWithDuration(0.2){
                // add the new height constraint
                   self.inputAccessoryView.addConstraint(NSLayoutConstraint(
                    item: self.inputAccessoryView,attribute: .Height, relatedBy: .Equal, toItem: nil,
                    attribute: .NotAnAttribute, multiplier: 1, constant: newHeight))
                
            }
            
            self.reloadInputViews()
        }
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
     
        let userInfo = notification.userInfo as NSDictionary!
        // get the keyboard animation time
        let rate = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        // scroll the table view smoothly
        UIView.animateWithDuration(rate.doubleValue, animations:{
                () -> Void in
                self.tableView.contentInset =
                    UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.toolBar.frame.height , right: 0.0)
                self.tableView.scrollIndicatorInsets =
                    UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.toolBar.frame.height , right: 0.0)
                return
        })
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
         // get the keyboard size
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
         // get the keyboard animation time
        let rate = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        var contentInsets: UIEdgeInsets
        
        if keyboardSize.height == 49 {
                return
        }
        contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 30 , right: 0.0)

        let lastSection = tableView.numberOfSections() - 1
        let numberOfRows = tableView.numberOfRowsInSection(lastSection)
         UIView.animateWithDuration(rate.doubleValue, animations:{
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        // scroll the table view smoothly
        if numberOfRows != 0 {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: numberOfRows - 1, inSection: lastSection),
            atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
        })
    }
    
    
    func comment_refresh(){

       // for the init fresh
        if currentNewsItem.instantComment.conversation == nil {
            println("test")
            var converQuery = imClient.conversationQuery()
            // init the imclient
            converQuery.whereKey("title", equalTo: currentNewsItem.title)
            // query to find the conversation
            converQuery.findConversationsWithCallback(){
                (result:[AnyObject]!, error:NSError!) -> Void in
                if(error != nil){
                    // fail to find the conversation
                    KVNProgress.showErrorWithStatus("请检查网络")
                    return
                }
                else{
                    println("\(result)")
                    if(result.count>1){
                        // error in the server
                        KVNProgress.showErrorWithStatus("服务器内部错误")
                        return
                    }
                    else if(result.count == 0){
                        // fail to find the conversation
                         KVNProgress.showErrorWithStatus("服务器内部错误")
                        return
                    }
                    else{
                        self.currentNewsItem.instantComment.conversation = result[0] as? AVIMConversation
                        self.currentNewsItem.instantComment.conversation!.joinWithCallback(){
                            (success:Bool,error: NSError!) -> Void in
                            if(error != nil){
                                // fail to join the conversation
                                 KVNProgress.showErrorWithStatus("请检查网络")
                            }
                            else {
                                if self.shiftSegmentControl.selectedSegmentIndex == instant {
                                    var date = NSDate()
                                    
                                    var oldestMsgTimestamp:Int64 = Int64(date.timeIntervalSince1970*1000)
                                    
                                    if(self.currentNewsItem.instantComment.loadedMessages.count == 0){
                                        
                                        self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(nil, timestamp: oldestMsgTimestamp , limit: 10 ){
                                            (objects:[AnyObject]!,error: NSError!) -> Void in
                                            if (error != nil) {
                                                // fail to refresh
                                                 KVNProgress.showErrorWithStatus("请检查网络")
                                            }
                                            else {
                                                var index = 0
                                                for newMessage in objects{
                                                    
                                                    self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMTextMessage), atIndex: index)
                                                    index++
                                                }
                                                self.tableView.reloadData()
                                            }
                                            
                                        }
                                        
                                  
                            
                                    }
                                    else{
                                        self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(self.currentNewsItem.instantComment.loadedMessages[0].messageId, timestamp: self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp , limit: 20 ){
                                            (objects:[AnyObject]!,error: NSError!) -> Void in
                                            if (error != nil) {
                                                // fail to refresh
                                                 KVNProgress.showErrorWithStatus("请检查网络")
                                            }
                                            else {
                                                println(objects)
                                                //       println("hello")
                                                var index = 0
                                                for newMessage in objects{
                                                    // set up the message item
                                                    self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMTextMessage), atIndex:index)
                                                    index++
                                                }
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                }
                                else { // popupar
                                    var query = AVQuery(className: "HotComments")
                                    query.whereKey("TargetConv", equalTo: self.currentNewsItem.instantComment.conversation!.conversationId)
                                    // query to hot comment
                                    query.findObjectsInBackgroundWithBlock(){
                                        (array:[AnyObject]!, error:NSError!) -> Void in
                                        if error == nil{
                                            // get the hot comments
                                            self.currentNewsItem.popularComment.loadedMessages.removeAll(keepCapacity: true)
                                            for item in array {
                                                var commentId = (item as! AVObject).objectForKey("Comments") as! String
                                                query = AVQuery(className: "Comments")
                                                query.getObjectInBackgroundWithId(commentId){
                                                    (comment:AVObject!, error:NSError!) -> Void in
                                                    if error == nil{
                                                        var newItem = singleComment()
                                                        newItem.attitude = comment.objectForKey("Attitude") as! Bool
                                                        newItem.text = comment.objectForKey("Content") as! String
                                                        newItem.user = comment.objectForKey("user") as! String
                                                        newItem.commentId = commentId
                                                        //avartar to be continue
                                                        self.currentNewsItem.popularComment.loadedMessages.append(newItem)
                                                        self.tableView.reloadData()
                                                    }
                                                    else {
                                                        KVNProgress.showErrorWithStatus("请检查网络")
                                                    }
                                                }
                                            }
                                        }
                                        else {
                                            KVNProgress.showErrorWithStatus("请检查网络")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
        else {
            // if not the initial refresh
            if shiftSegmentControl.selectedSegmentIndex == instant {
                var date = NSDate()
                var oldestMsgTimestamp:Int64 = Int64(date.timeIntervalSince1970*1000)
                // get the older message
                if(self.currentNewsItem.instantComment.loadedMessages.count == 0){
                    self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(nil, timestamp: oldestMsgTimestamp , limit: 10 ){
                        (objects:[AnyObject]!,error: NSError!) -> Void in
                        if (error != nil) {
                            // fail to refresh
                            KVNProgress.showErrorWithStatus("请检查网络")
                        }
                        else {
                            var index = 0
                            for newMessage in objects {
                             self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMTextMessage), atIndex: index)
                                index++
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                else{
                    self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(self.currentNewsItem.instantComment.loadedMessages[0].messageId, timestamp: self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp , limit: 20 ){
                        (objects:[AnyObject]!,error: NSError!) -> Void in
                        if (error != nil) {
                            // fail to refresh
                             KVNProgress.showErrorWithStatus("请检查网络")
                        }
                        else {
                            var index = 0
                            for newMessage in objects{
                                self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMTextMessage), atIndex:index)
                                index++
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            else { // popular
                var query = AVQuery(className: "HotComments")
                query.whereKey("TargetConv", equalTo: self.currentNewsItem.instantComment.conversation!.conversationId)
                query.findObjectsInBackgroundWithBlock(){
                    (array:[AnyObject]!, error:NSError!) -> Void in
                    if error == nil{
                        self.currentNewsItem.popularComment.loadedMessages.removeAll(keepCapacity: true)
                        for item in array {
                            var commentId = (item as! AVObject).objectForKey("Comments") as! String
                            query = AVQuery(className: "Comments")
                            query.getObjectInBackgroundWithId(commentId){
                                (comment:AVObject!, error:NSError!) -> Void in
                                if error == nil{
                                    // set popular comment depends on results
                                    var newItem = singleComment()
                                    newItem.attitude = comment.objectForKey("Attitude") as! Bool
                                    newItem.text = comment.objectForKey("Content") as! String
                                    newItem.user = comment.objectForKey("user") as! String
                                    newItem.commentId = commentId

                                    self.currentNewsItem.popularComment.loadedMessages.append(newItem)
                                    self.tableView.reloadData()
                                }
                                else {
                                    KVNProgress.showErrorWithStatus("请检查网络")
                                }
                            }
                        }
                    }
                    else {
                        KVNProgress.showErrorWithStatus("请检查网络")
                        
                    }
                }
            }
        }
    }
    
    

    
//    send comment to the server
    func comment_send(newComment: AVIMTextMessage ){
        currentNewsItem.instantComment.loadedMessages.append(newComment)
        currentNewsItem.instantComment.conversation!.sendMessage(newComment) {
            (success:Bool,error: NSError!) -> Void in
            if(!success){
                // fail to send the comment
                 KVNProgress.showErrorWithStatus("请检查网络")
            }
        }
        if shiftSegmentControl.selectedSegmentIndex == instant{
            // draw the new sent comment
            draw_new_comment()
        }
    }
    
// draw a new cell for the latest comment
    func draw_new_comment() {
        let lastsec = tableView.numberOfSections() - 1
        let lastrow = tableView.numberOfRowsInSection(lastsec)
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: lastrow, inSection: lastsec)
            ], withRowAnimation: .Fade)
        tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
    }
    
    
//    click the send button
    func sendAction(sender: UIButton) {
        commentTextView.resignFirstResponder()
        // create the message
        var content : String = commentTextView.text
        var singleComment:AVIMTextMessage
        if sender.tag == leftButtonTag {
          singleComment = AVIMTextMessage(text: content, attributes: ["attitude":true])
        }
        else {
         singleComment = AVIMTextMessage(text: content, attributes: ["attitude":false])
        }
        
        commentTextView.text = nil
        commentTextView.contentSize.height = 0
        
        // send the comment to the server
        comment_send(singleComment)
        // change the height of comment text view
        textViewDidChange(commentTextView)
     
    }
    
    
//    tap the title then show/hide the news content
    func didTap(sender: UITapGestureRecognizer) {
        if showcontent == false {
            // if not showing the content, show it
            showcontent = true
            toolBar.hidden = true
            commentTextView.resignFirstResponder()
            arrow.image = UIImage(named: "up")
            shiftSegmentControl.enabled = false
            shiftSegmentControl.userInteractionEnabled = false
            UIView.animateWithDuration(0.2){
                // show the scroll view, on which web view are
                self.scrollView.frame.size.height =  UIScreen.mainScreen().bounds.height
            }
            
        } else {
            // hide the web view with news content
            toolBar.hidden = false
            showcontent = false
            arrow.image = UIImage(named: "down")
            shiftSegmentControl.enabled = true
            shiftSegmentControl.userInteractionEnabled = true
            UIView.animateWithDuration(0.2){
                self.scrollView.frame.size.height =  0
                
            }
        }
    }
    
    
//  scroll to the bottom with animation
    func tableViewScrollToBottomAnimated(animated: Bool) {
        let lastSection = tableView.numberOfSections() - 1
        let numberOfRows = tableView.numberOfRowsInSection(lastSection)
        if numberOfRows != 0 {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: lastSection),
            atScrollPosition: .Bottom, animated: animated)
        }
    }
    
//  resize the web view and scroll view after loading the content
    func webViewDidFinishLoad(webView: UIWebView) {
        var newFrame = webView.frame
        var actualSize = webView.sizeThatFits(CGSizeZero)
        newFrame.size = actualSize
        webView.frame = newFrame
        scrollView.contentSize = CGSize(width: actualSize.width, height: actualSize.height + 200)
    }

//    receive an instant comment
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        // add it to the array
        currentNewsItem.instantComment.loadedMessages.append(message as! AVIMTextMessage)
        // draw it
        draw_new_comment()
    }
}
