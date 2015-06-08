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


let instant = 0 , popular = 1

let momentIndex = 0, friendIndex = 1

let leftButtonTag = 4, rightButtonTag = 5

class CommentViewController: UIViewController, AVIMClientDelegate, UIWebViewDelegate, UITextViewDelegate, UIAlertViewDelegate {
//    @IBOutlet weak var rightSwipeRecognizer: UISwipeGestureRecognizer!
//    @IBOutlet weak var leftSwipeRecognizer: UISwipeGestureRecognizer!
//    
//    @IBAction func rightSwipeAction(sender: UISwipeGestureRecognizer) {
//        println("swipe right")
//        var point = sender.locationInView(self.tableView)
//        var cellIdx = self.tableView.indexPathForRowAtPoint(point)
//        if cellIdx == nil {
//            return
//        }
//        var message = currentNewsItem.instantComment.loadedMessages[cellIdx!.row]
//       // println("\(message.text)")
//        let direction = message.attributes
//        if direction != nil{
//            if direction["attitude"] as! Bool == true {
//                likeMessage(message)
//            } else { // outgoing
//                dislikeMessage(message)
//            }
//        }
//        
//        
//        
//        //var cell = self.tableView.cellForRowAtIndexPath(cellIdx!) as! BubbleCell
//        //println("\(cell.bubbleText.text)")
//        
//    }
    

    
//    @IBAction func leftSwipeAction(sender: UISwipeGestureRecognizer) {
//        println("swipe left")
//        var point = sender.locationInView(self.tableView)
//        var cellIdx = self.tableView.indexPathForRowAtPoint(point)
//        if cellIdx == nil {
//            return
//        }
//        var message = currentNewsItem.instantComment.loadedMessages[cellIdx!.row]
//        let direction = message.attributes
//        if direction != nil{
//            if direction["attitude"] as! Bool == true {
//                dislikeMessage(message)
//            } else { // outgoing
//                likeMessage(message)
//            }
//        }
//    }
    
    
    var menu = QBPopupMenu()
    
    var currentNewsItem:NewsItem!
    
    var popularcomment = popularComment()
//    var newscontent = newsContent()
    var instantcomment = instantComment()
    
    var imClient = AVIMClient()
    
    var instantRefresh = UIRefreshControl()
    var popularRefresh = UIRefreshControl()
    
//    var tableView = UITableView()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var titleview: UIView!
 //   var titleview:titleView!

    @IBOutlet var leftAttitude: UILabel!
    
    
    @IBOutlet var rightAttitude: UILabel!
    
    @IBOutlet var arrow: UIImageView!
    
    
    @IBOutlet var newstitle: UILabel!
    var rotating = false
    var showcontent = false

//    var selectedMessage: AVIMTextMessage!
//    var messageSelected = false
    
    var selectedIdx: NSIndexPath?
    
    var webView: UIWebView!
    var scrollView: UIScrollView!

//    @IBOutlet var scrollView: UIScrollView!
    
    var chosePlatformView:UIAlertView!
    
    var  shiftSegmentControl:UISegmentedControl!
//    var  titleSgCtr:UISegmentedControl!
    
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
                toolBar = UIToolbar(frame: CGRectZero)
//                toolBar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 51))
                toolBar.backgroundColor = bgColor
                
    
                
                leftButton = UIButton.buttonWithType(.Custom) as! UIButton
                leftButton.setBackgroundImage(UIImage(named:"leftButton"), forState: .Normal)
                leftButton.tag = leftButtonTag
//                leftButton.backgroundColor = leftColor
//                leftButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                leftButton.enabled = false
//                leftButton.setTitle("动嘴", forState: .Normal)
//                leftButton.setTitleColor(leftColor, forState: .Disabled)
//                leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                leftButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                leftButton.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(leftButton)
                
                
                rightButton = UIButton.buttonWithType(.Custom) as! UIButton
//                rightButton.backgroundColor = rightColor
                rightButton.enabled = false
                rightButton.setBackgroundImage(UIImage(named:"rightButton"), forState: .Normal)
                rightButton.tag = rightButtonTag
//                rightButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
//                rightButton.setTitle("开撕", forState: .Normal)
//                rightButton.setTitleColor(rightColor, forState: .Disabled)
//                rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                rightButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                rightButton.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(rightButton)
                
                
                
                commentTextView = UITextView(frame: CGRectZero)
//                commentTextView.backgroundColor = UIColor.greenColor()
                commentTextView.delegate = self
                commentTextView.font = UIFont.systemFontOfSize(FontSize)
                commentTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                commentTextView.layer.borderWidth = 0.5
                commentTextView.layer.cornerRadius = 5
//                commentTextView.scrollsToTop = false
//                commentTextView.textContainerInset = UIEdgeInsetsMake(5, 3, 4 , 3)
                
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
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 6))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Right, relatedBy: .Equal, toItem: rightButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -6))
                
                
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: -50))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Top, relatedBy:.Equal , toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: -25))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Bottom, relatedBy: .Equal, toItem: commentTextView, attribute: .Bottom, multiplier: 1, constant: 0))
                
                
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
        if currentNewsItem.instantComment.conversation != nil {
            currentNewsItem.instantComment.conversation!.quitWithCallback(){
                (success:Bool,error: NSError!) -> Void in
                if(!success){
                    KVNProgress.showErrorWithStatus("请检查网络")
                    println("退出群组失败!")
                    println("错误:\(error)")
                    
                }
                else{
                    //println("xiao")
                }
            }
        }
      //  me.newsList[me.currentNews].instantComment.draft = commentTextView.text
    }


    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == momentIndex {
            shareTimeLine()
        }
        else if buttonIndex == friendIndex {
            
            shareFriend()
        }
    }
    
    
    
    
    
    func share(){
        
        var imagePath = NSBundle.mainBundle().pathForResource("ShareSDK", ofType: "png")
        
        var publishContent = ShareSDK.content("分享", defaultContent: "分享", image: ShareSDK.imageWithPath(imagePath), title: currentNewsItem.title, url: "http://sixinwen.avosapps.com", description: currentNewsItem.text, mediaType: SSPublishContentMediaTypeNews)
        
        var container = ShareSDK.container()
        container.setIPadContainerWithView(self.view, arrowDirect: UIPopoverArrowDirection.Up)
        
        ShareSDK.showShareActionSheet(container, shareList: nil, content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: {
            (type:ShareType, state:SSResponseState , statusInfo:AnyObject!, error:AnyObject!, end:Bool)  in
            if state.value == SSResponseStateFail.value {
                KVNProgress.showErrorWithStatus("分享失败")
            }
                
            
        })
//        chosePlatformView.show()
    }
    
    func shareFriend(){
        var msg = WXMediaMessage()
        msg.title = currentNewsItem.title
        msg.description = currentNewsItem.text
        msg.setThumbImage(UIImage(named: "Icon-60"))
        var ext = WXWebpageObject()
        ext.webpageUrl = "http://sixinwen.avosapps.com"
        msg.mediaObject = ext
        
        
        var req = SendMessageToWXReq()
        req.scene = Int32(WXSceneSession.value)
        
        req.message = msg
        req.bText = false
        WXApi.sendReq(req)
    }
    
    func shareTimeLine(){
        
        var msg = WXMediaMessage()
        msg.title = currentNewsItem.title
        msg.description = currentNewsItem.text
        msg.setThumbImage(UIImage(named: "Icon-60"))
        var ext = WXWebpageObject()
        ext.webpageUrl = "http://sixinwen.avosapps.com"
        msg.mediaObject = ext
        
        
        var req = SendMessageToWXReq()
        req.scene = Int32(WXSceneTimeline.value)
        
        req.message = msg
        req.bText = false
        WXApi.sendReq(req)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shiftSegmentControl = UISegmentedControl(frame: CGRectMake(80.0, 8.0, 200.0, 30.0))
        shiftSegmentControl.insertSegmentWithTitle("即时评论", atIndex: instant, animated: true)
        shiftSegmentControl.insertSegmentWithTitle("热门评论", atIndex: popular, animated: true)
        shiftSegmentControl.selectedSegmentIndex = instant
        shiftSegmentControl.multipleTouchEnabled = false
        shiftSegmentControl.userInteractionEnabled = true
        shiftSegmentControl.addTarget(self, action: "shiftSegment:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = shiftSegmentControl
        
        var imgView = UIImageView(frame: CGRectMake(0, 0, 23, 23))
        imgView.image = UIImage(named: "Share-100-1")
        let tapGesture = UITapGestureRecognizer(target: self, action: "share")
        imgView.addGestureRecognizer(tapGesture)
//        var imgedit:UIImage
//        UIGraphicsBeginImageContext(CGSize(width: 29, height: 29))
//        img?.drawInRect(CGRect(x: 0, y: 0, width: 29, height: 29))
//        imgedit = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        //img?.size = CGSize(width: 29, height: 29)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imgView)
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
        
        let tap = UITapGestureRecognizer(target: self, action: "didTap:")
        titleview.addGestureRecognizer(tap)
        
        
        scrollView = UIScrollView(frame: CGRectZero)
        scrollView.backgroundColor = bgColor
        
         webView = UIWebView(frame: UIScreen.mainScreen().bounds)
         view.addSubview(scrollView)
         scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: titleview, attribute: .Bottom, multiplier: 1, constant: 0))
         view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: titleview, attribute: .Bottom, multiplier: 1, constant: 0))
        
        scrollView.addSubview(webView)
        
        webView.delegate = self
        webView.scalesPageToFit = false
        webView.loadHTMLString(currentNewsItem.htmlContent, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath))

        newstitle.text = currentNewsItem.title
        
        leftAttitude.text = currentNewsItem.leftAttitude
        rightAttitude.text = currentNewsItem.rightAttitude
        
        
        tableView.addPullToRefresh({ [weak self] in
            sleep(1)
            self!.comment_refresh()
            })


        let notificationCenter = NSNotificationCenter.defaultCenter()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuControllerWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil)
    
      
//        println(inputAccessoryView.constraints()[0])
//        self.inputAccessoryView.addConstraint(constraint)

        
//
        var tapCellGesture = UITapGestureRecognizer(target: self, action: "tapCell:")
        self.tableView.addGestureRecognizer(tapCellGesture)
        
//        var constraints: NSArray = self.inputAccessoryView.constraints()
//        
//        let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
//            return  (constraint.firstAttribute == .Height)
//        }
//        
//        self.inputAccessoryView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
//        
//        
//        self.inputAccessoryView.addConstraint(NSLayoutConstraint(item: self.inputAccessoryView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 51))
      
        
//        chosePlatformView = UIAlertView(title: "分享", message: "选择分享平台", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "分享到朋友圈", "分享给微信好友")
        
        var replyButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "replyTo")
        var threadButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "showThread")
        var likeButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "likeMessages")
        var dislikeButton = QBPopupMenuItem(image: UIImage(named: "menuReply"), target: self, action: "dislikeMessages")
        menu.items = NSArray(objects: replyButton, threadButton, likeButton, dislikeButton) as [AnyObject]

        
        }

    func showThread(){
        
    }
    func replyTo(){
        if selectedIdx != nil {
            self.commentTextView.text = "@\(currentNewsItem.instantComment.loadedMessages[selectedIdx!.row].clientId) "
            self.commentTextView.becomeFirstResponder()
//            messageSelected = false
        }
        
        
    }
    
    func likeMessages() {
        //点赞操作
        println("shabi")
        if selectedIdx != nil{
            var message = currentNewsItem.instantComment.loadedMessages[selectedIdx!.row] as AVIMTextMessage
            var attribute = message.attributes
            if attribute["commentId"] != nil {
                var commentId = attribute["commentId"]! as! String
                var query = AVQuery(className: "Comments")
                query.getObjectInBackgroundWithId(commentId){
                    (comment:AVObject!, error:NSError!) -> Void in
                    comment.incrementKey("Like")
                    comment.incrementKey("heat")
                    comment.saveInBackground()
                }
                println("点赞操作")
            }
            else {
                println("缺少 commentId")
            }
        }
        else {
            println("shabi")
        }
    }
    
    
    func dislikeMessages() {
        if selectedIdx != nil{
            var message = currentNewsItem.instantComment.loadedMessages[selectedIdx!.row] as AVIMTextMessage
            var attribute = message.attributes
            if attribute["commentId"] != nil {
                var commentId = attribute["commentId"]! as! String
                var query = AVQuery(className: "Comments")
                query.getObjectInBackgroundWithId(commentId){
                    (comment:AVObject!, error:NSError!) -> Void in
                    comment.incrementKey("Dislike")
                    comment.incrementKey("heat")
                    comment.saveInBackground()
                }
                println("点踩操作")
            }
            else {
                println("缺少 commentId")
            }
        }
        
    }
    
    
    
    
    func tapCell(tap:UIGestureRecognizer){
        
        var p:CGPoint = tap.locationInView(self.tableView)
        var point = tap.locationInView(self.view)
        var indexPath = self.tableView.indexPathForRowAtPoint(p)
        if indexPath != nil {
            
            if selectedIdx != nil && self.tableView.cellForRowAtIndexPath(selectedIdx!) != nil {
                 (self.tableView.cellForRowAtIndexPath(selectedIdx!) as! BubbleCell).bubbleImageView.highlighted = false
            }
            
            (self.tableView.cellForRowAtIndexPath(indexPath!) as! BubbleCell).bubbleImageView.highlighted = true
            selectedIdx = indexPath
//            selectedMessage = currentNewsItem.instantComment.loadedMessages[indexPath!.row]
//            messageSelected = true
            menu.showInView(self.view, atPoint:CGPointMake(self.tableView.cellForRowAtIndexPath(indexPath!)!.center.x, point.y))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if currentNewsItem.instantComment.loadedMessages.count == 0 {
      //  self.comment_refresh()
        }
        else {
//            println(self.currentNewsItem.instantComment.loadedMessages.count )
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.currentNewsItem.instantComment.loadedMessages.count - 1 , inSection: 0), atScrollPosition: .Top, animated: false)
//            println(self.currentNewsItem.instantComment.loadedMessages[self.currentNewsItem.instantComment.loadedMessages.count - 1].content )
        }
   
    }
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        
//        if !currentNewsItem.instantComment.draft.isEmpty {
//            commentTextView.text = currentNewsItem.instantComment.draft
//            currentNewsItem.instantComment.draft = ""
//            textViewDidChange(commentTextView)
//            
//        }
//        commentTextView.becomeFirstResponder()
    }
    
    
//    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
//        
//        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
//            if toolBar.frame.height > textViewMaxHeight.landscape {
//                toolBar.frame.size.height = textViewMaxHeight.landscape + 8 * 2
//            }
//        } else { // portrait
//            updateTextViewHeight()
//        }
//    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     //   leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
      //  rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        imClient.delegate = self
        imClient.openWithClientId(me.username, callback: {
            (success:Bool,error: NSError!) -> Void in
            if(!success){
                KVNProgress.showErrorWithStatus("请检查网络")
                println("登陆失败!")
                println("错误:\(error)")
            }
            else{
                //println("xiao")
                var converQuery = self.imClient.conversationQuery()
                
                converQuery.whereKey("title", equalTo: self.currentNewsItem.title)
                converQuery.findConversationsWithCallback(){
                    (result:[AnyObject]!, error:NSError!) -> Void in
                    if(error != nil){
                        KVNProgress.showErrorWithStatus("请检查网络")
                        println("查询对话失败")
                        println("错误:\(error)")
                    }
                    else{
                        //                println("\(result)")
                        if(result.count>1){
                            KVNProgress.showErrorWithStatus("服务器内部错误")
                            println("对话数超过1")
                        }
                        else if(result.count == 0){
                            KVNProgress.showErrorWithStatus("服务器内部错误")
                            println("未找到对话")
                        }
                        else{
                            self.currentNewsItem.instantComment.conversation = (result[0] as! AVIMConversation)
                            self.currentNewsItem.instantComment.conversation!.joinWithCallback(){
                                (success:Bool,error: NSError!) -> Void in
                                if(error != nil){
                                    KVNProgress.showErrorWithStatus("请检查网络")
                                    println("加入群组失败!")
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
//        var converQuery = imClient.conversationQuery()
//    
//        converQuery.whereKey("title", equalTo: currentNewsItem.title)
//        converQuery.findConversationsWithCallback(){
//            (result:[AnyObject]!, error:NSError!) -> Void in
//            if(error != nil){
//                 KVNProgress.showErrorWithStatus("请检查网络")
//                println("查询对话失败")
//                println("错误:\(error)")
//            }
//            else{
////                println("\(result)")
//                if(result.count>1){
//                     KVNProgress.showErrorWithStatus("服务器内部错误")
//                    println("对话数超过1")
//                }
//                else if(result.count == 0){
//                     KVNProgress.showErrorWithStatus("服务器内部错误")
//                    println("未找到对话")
//                }
//                else{
//                    self.currentNewsItem.instantComment.conversation = (result[0] as! AVIMConversation)
//                    self.currentNewsItem.instantComment.conversation!.joinWithCallback(){
//                        (success:Bool,error: NSError!) -> Void in
//                        if(error != nil){
//                            KVNProgress.showErrorWithStatus("请检查网络")
//                            println("加入群组失败!")
//                        }
//                    }
//                }
//            }
//        }

        self.tabBarController?.tabBar.hidden = true
    }
    

    func shiftSegment(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case popular:
            //            toolBar.hidden = true
            menu.dismiss()
            commentTextView.text = currentNewsItem.popularComment.draft
            UIView.transitionFromView(tableView, toView: tableView, duration: 0.3, options:.TransitionFlipFromLeft | .ShowHideTransitionViews, completion: nil)
            tableView.dataSource = popularcomment
            tableView.delegate = popularcomment
            tableView.reloadData()
            self.comment_refresh()
            break
            
        case instant:
//            toolBar.hidden = false
            menu.dismiss()
//            commentTextView.text = currentNewsItem.instantComment.draft
            UIView.transitionFromView(tableView, toView: tableView, duration: 0.3, options:.TransitionFlipFromRight | .ShowHideTransitionViews, completion: nil)
            tableView.dataSource = instantcomment
            tableView.delegate = instantcomment
            tableView.reloadData()
            self.comment_refresh()
            break
            
        default: break
            
        }
        
    }

    
    
    func updateTextViewHeight() {
        
        let oldHeight = self.toolBar.frame.size.height
        var newHeight = self.commentTextView.contentSize.height + 14
        
        let heightChange = newHeight - oldHeight
            println(heightChange)
       
        if newHeight < 51 {
            newHeight = 51
        }
        if  (heightChange > 0 && oldHeight < 60) || (heightChange < 0 ) {
            
            var constraints: NSArray = self.inputAccessoryView.constraints()
            
            let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                return  (constraint.firstAttribute == .Height)
            }
            
            self.inputAccessoryView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
            
            UIView.animateWithDuration(0.2){

                   self.inputAccessoryView.addConstraint(NSLayoutConstraint(item: self.inputAccessoryView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: newHeight))
            }
            
//            self.commentTextView.frame.size.height = newHeight - 4
            self.reloadInputViews()
        }
    
        
    }
    
    
    
    func textViewDidChange(textView: UITextView) {
        
        
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing  = 4.5
//
//        var attributes = [ NSFontAttributeName:UIFont.systemFontOfSize(FontSize),
//            NSParagraphStyleAttributeName:paragraphStyle
//        ]
//        
//        commentTextView.attributedText = NSAttributedString(string: commentTextView.text, attributes: attributes)
        
        updateTextViewHeight()
        leftButton.enabled = textView.hasText()
        rightButton.enabled = textView.hasText()
    }

    
//    func keyboardWillChangeFrame(notification: NSNotification){
//        
//        let userinfo = notification.userInfo as NSDictionary!
//        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        self
//        
//        println("hello from key")
//    }
   
    
    
    
    
    
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

       // println(currentNewsItem.instantComment.conversation)
        if currentNewsItem.instantComment.conversation == nil {
            println("test")
            var converQuery = imClient.conversationQuery()
            converQuery.whereKey("title", equalTo: currentNewsItem.title)
            converQuery.findConversationsWithCallback(){
                (result:[AnyObject]!, error:NSError!) -> Void in
                if(error != nil){
                    KVNProgress.showErrorWithStatus("请检查网络")
                    println("查询对话失败")
                    println("错误:\(error)")
                    return
                }
                else{
                    println("\(result)")
                    if(result.count>1){
                        KVNProgress.showErrorWithStatus("服务器内部错误")
                        println("对话数超过1")
                        return
                    }
                    else if(result.count == 0){
                         KVNProgress.showErrorWithStatus("服务器内部错误")
                        println("未找到对话")
                        return
                    }
                    else{
                        self.currentNewsItem.instantComment.conversation = result[0] as? AVIMConversation
                        self.currentNewsItem.instantComment.conversation!.joinWithCallback(){
                            (success:Bool,error: NSError!) -> Void in
                            if(error != nil){
                                 KVNProgress.showErrorWithStatus("请检查网络")
                                println("加入群组失败!")
                            }
                            else {
                                if self.shiftSegmentControl.selectedSegmentIndex == instant {
                                    var date = NSDate()
                                    // INT64_MAX
                                    var oldestMsgTimestamp:Int64 = Int64(date.timeIntervalSince1970*1000)
                                    // println(oldestMsgTimestamp)
//                                    println("hello1")
                                    if(self.currentNewsItem.instantComment.loadedMessages.count == 0){
//                                        println("hello2")
                                        self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(nil, timestamp: oldestMsgTimestamp , limit: 10 ){
                                            (objects:[AnyObject]!,error: NSError!) -> Void in
                                            if (error != nil) {
                                                 KVNProgress.showErrorWithStatus("请检查网络")
                                                println("刷新错误:\(error)")
                                                // AVHistoryMessageQuery
                                            }
                                            else {
//                                                println(objects)
//                                                println("hello")
                                                var index = 0
                                                for newMessage in objects{
                                                    //println("receiveid\((newMessage as! AVIMTextMessage).messageId)")
                                                    self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMTextMessage), atIndex: index)
                                                    index++
                                                }
                                                self.tableView.reloadData()
                                            }
                                            // println("hello6")
                                        }
                                        
                                  
                                        //                var query = AVHistoryMessageQuery(conversationId: self.currentNewsItem.instantComment.conversation.conversationId, timestamp: oldestMsgTimestamp, limit: 4)
                                        //               // query.timestamp = oldestMsgTimestamp
                                        //             //   query.query
                                        //                var array = query.find()
                                        //               // println(array)
                                        //               // AVHistoryMessage
                                        //                 var index = 0
                                        //                for newHistoryMessage in array{
                                        //                    var newMessage = self.historyMessage2AVIMMessage(newHistoryMessage as! AVHistoryMessage)
                                        //                    self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as (AVIMMessage), atIndex: index)
                                        //                    index++
                                        //                }
                                        //                self.tableView.reloadData()
                                    }
                                    else{
//                                        println("hello3")
//                                        println("\(self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp)")
                                        self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(self.currentNewsItem.instantComment.loadedMessages[0].messageId, timestamp: self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp , limit: 20 ){
                                            (objects:[AnyObject]!,error: NSError!) -> Void in
                                            if (error != nil) {
                                                 KVNProgress.showErrorWithStatus("请检查网络")
                                                println("刷新错误:\(error)")
                                            }
                                            else {
                                                println(objects)
                                                //       println("hello")
                                                var index = 0
                                                for newMessage in objects{
                                                    //println("receiveid\((newMessage as! AVIMTextMessage).messageId)")
                                                    self.currentNewsItem.instantComment.loadedMessages.insert(newMessage as! (AVIMTextMessage), atIndex:index)
                                                    index++
                                                }
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                    //    println("hello4")
                                }
                                else { // popupar
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
                                                        var newItem = singleComment()
                                                        newItem.attitude = comment.objectForKey("Attitude") as! Bool
                                                        newItem.text = comment.objectForKey("Content") as! String
                                                        newItem.user = comment.objectForKey("user") as! String
//                                                        var query = AVUser.query()
//                                                        query.whereKey("username", equalTo: newItem.user)
//                                                        query.findObjectsInBackgroundWithBlock(){
//                                                            (result:[AnyObject]!, error:NSError!) -> Void in
//                                                            if error == nil && result.count > 0{
//                                                                var user = result[0] as! AVUser
//                                                                //user.objectForKey("avartar")
//                                                                var avartarFile = user.objectForKey("Avartar") as? AVFile
//                                                                if avartarFile != nil{
//                                                                    //  println("设置对话头像")
//                                                                    //   println("asdfasdfasdf")
//                                                                    avartarFile?.getThumbnail(true, width: 60, height: 60){
//                                                                        (img:UIImage!, error:NSError!) -> Void in
//                                                                        //println(cell)
//                                                                        if error == nil{
//                                                                            // var tmp = self.tableView.cellForRowAtIndexPath(indexPath)
//                                                                            // println(tmp)
//                                                                            //cell = self.tableView.cellForRowAtIndexPath(indexPath) as! BubbleCell
//                                                                            newItem.avatar = img
//                                                                            //     self.tableView.reloadData()
//                                                                        }
//                                                                    }
//                                                                }
//                                                                
//                                                            }
//                                                            
//                                                        }
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
//                                println("hello5")
                            }
                        }
                    }
                }
            }

        }
        else {
            if shiftSegmentControl.selectedSegmentIndex == instant {
                var date = NSDate()
                var oldestMsgTimestamp:Int64 = Int64(date.timeIntervalSince1970*1000)
//                 println("hello1")
                if(self.currentNewsItem.instantComment.loadedMessages.count == 0){
//                    println("hello2")
                    self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(nil, timestamp: oldestMsgTimestamp , limit: 10 ){
                        (objects:[AnyObject]!,error: NSError!) -> Void in
                        if (error != nil) {
                            KVNProgress.showErrorWithStatus("请检查网络")
                            println("刷新错误:\(error)")
                        }
                        else {
//                           println(objects)
//                            println("hello")
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
                    
//                    println("\(self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp)")
                    self.currentNewsItem.instantComment.conversation!.queryMessagesBeforeId(self.currentNewsItem.instantComment.loadedMessages[0].messageId, timestamp: self.currentNewsItem.instantComment.loadedMessages[0].sendTimestamp , limit: 20 ){
                        (objects:[AnyObject]!,error: NSError!) -> Void in
                        if (error != nil) {
                             KVNProgress.showErrorWithStatus("请检查网络")
                            println("刷新错误:\(error)")
                        }
                        else {
//                            println(objects)
                            //       println("hello")
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
                                    var newItem = singleComment()
                                    newItem.attitude = comment.objectForKey("Attitude") as! Bool
                                    newItem.text = comment.objectForKey("Content") as! String
                                    newItem.user = comment.objectForKey("user") as! String
//                                    var query = AVUser.query()
//                                    query.whereKey("username", equalTo: newItem.user)
//                                    query.findObjectsInBackgroundWithBlock(){
//                                        (result:[AnyObject]!, error:NSError!) -> Void in
//                                        if error == nil && result.count > 0{
//                                            var user = result[0] as! AVUser
//                                            //user.objectForKey("avartar")
//                                            var avartarFile = user.objectForKey("Avartar") as? AVFile
//                                            if avartarFile != nil{
//                                                //  println("设置对话头像")
//                                                //   println("asdfasdfasdf")
//                                                avartarFile?.getThumbnail(true, width: 60, height: 60){
//                                                    (img:UIImage!, error:NSError!) -> Void in
//                                                    //println(cell)
//                                                    if error == nil{
//                                                        // var tmp = self.tableView.cellForRowAtIndexPath(indexPath)
//                                                        // println(tmp)
//                                                        //cell = self.tableView.cellForRowAtIndexPath(indexPath) as! BubbleCell
//                                                        newItem.avatar = img
//                                                        //     self.tableView.reloadData()
//                                                    }
//                                                }
//                                            }
//                                            
//                                        }
//                                        
//                                    }

                                    //avartar to be continue
                                    self.currentNewsItem.popularComment.loadedMessages.append(newItem)
                                    self.tableView.reloadData()
                                }
                                else {
                                    KVNProgress.showErrorWithStatus("请检查网络")
                                    println("1")
                                }
                            }
                        }
                    }
                    else {
                        KVNProgress.showErrorWithStatus("请检查网络")
                        
                    }
                }
            }
//            println("hello5")
        }

    }
    
    
//   
//    func historyMessage2AVIMMessage(historyMessage:AVHistoryMessage)->AVIMMessage{
//        var result = AVIMMessage()
//        result.conversationId = historyMessage.conversationId
//        result.clientId = historyMessage.fromPeerId
//        if historyMessage.payload != nil{
//            result.content = historyMessage.payload
//        }
//        else {
//            result.content = "34534534/r"
//        }
//        result.sendTimestamp = historyMessage.timestamp
//        return result
//    }
    
    
    
    func comment_send(newComment: AVIMTextMessage ){
       currentNewsItem.instantComment.loadedMessages.append(newComment)
        currentNewsItem.instantComment.conversation!.sendMessage(newComment) {
            (success:Bool,error: NSError!) -> Void in
            if(!success){
                 KVNProgress.showErrorWithStatus("请检查网络")
//                println("发送失败!")
//                println("错误:\(error)")
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
        commentTextView.resignFirstResponder()
        //commentTextView.becomeFirstResponder()
        var content : String = commentTextView.text
        var singleComment:AVIMTextMessage
        if sender.tag == leftButtonTag {
          singleComment = AVIMTextMessage(text: content, attributes: ["attitude":true])
        }
        else {
         singleComment = AVIMTextMessage(text: content, attributes: ["attitude":false])
        }
       // println("sendId\(singleComment.messageId)")
//        println("OLD \(commentTextView.contentSize.height)")
        commentTextView.text = nil
        commentTextView.contentSize.height = 0
//        println("new \(commentTextView.contentSize.height)")
        comment_send(singleComment)
        textViewDidChange(commentTextView)
    }
    
    
    
    func menuControllerWillHide(notification: NSNotification){
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
        (notification.object as! UIMenuController).menuItems = nil
        
    }
    
    
    
    
    func didTap(sender: UITapGestureRecognizer) {
        if showcontent == false {
            showcontent = true
            toolBar.hidden = true
             commentTextView.resignFirstResponder()
            arrow.image = UIImage(named: "up")
            shiftSegmentControl.enabled = false
            shiftSegmentControl.userInteractionEnabled = false
            UIView.animateWithDuration(0.2){
                self.scrollView.frame.size.height =  UIScreen.mainScreen().bounds.height
            }
         //   rightSwipeRecognizer.enabled = false
         //   leftSwipeRecognizer.enabled = false
        } else {
            toolBar.hidden = false
//            commentTextView.becomeFirstResponder()
            showcontent = false
            arrow.image = UIImage(named: "down")
            shiftSegmentControl.enabled = true
            shiftSegmentControl.userInteractionEnabled = true
            UIView.animateWithDuration(0.2){
                self.scrollView.frame.size.height =  0
                
            }
       //     rightSwipeRecognizer.enabled = true
        //    leftSwipeRecognizer.enabled = true
        }
        
        
    }
    
    
    
    func tableViewScrollToBottomAnimated(animated: Bool) {
        let lastSection = tableView.numberOfSections() - 1
        let numberOfRows = tableView.numberOfRowsInSection(lastSection)
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: lastSection), atScrollPosition: .Bottom, animated: animated)
        
    }
    

    func webViewDidFinishLoad(webView: UIWebView) {
        var newFrame = webView.frame
        var actualSize = webView.sizeThatFits(CGSizeZero)
        newFrame.size = actualSize
        webView.frame = newFrame
        scrollView.contentSize = CGSize(width: actualSize.width, height: actualSize.height + 200)
    }

    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        println("receiveid\((message as! AVIMTextMessage).messageId)")
        currentNewsItem.instantComment.loadedMessages.append(message as! AVIMTextMessage)
        Redrawcomment()
    }
}
