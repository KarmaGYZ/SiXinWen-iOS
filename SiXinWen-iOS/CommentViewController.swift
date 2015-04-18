//
//  CommentViewController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/14.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloudIM
import AVOSCloud

public let me = User(ID: 1, username: "walker", portraitName: nil)


let conversation = AVIMConversation()



public let defaultColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
public let leftColor = UIColor(red: 77/255, green: 188/255, blue: 249/255, alpha: 1)
public let highLeftColor = UIColor(red: 51/255.0, green: 102/255.0, blue: 205/255.0, alpha: 1)
public let rightColor = UIColor(red: 253/255, green: 13/255, blue: 68/255, alpha: 1)
public let highRightColor = UIColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1)
public let bgColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)





class InputTextView: UITextView {
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if (delegate as! CommentViewController).tableView.indexPathForSelectedRow() != nil {
            return action == "copyTextAction:"
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}




class CommentViewController: UIViewController ,UITextViewDelegate , UIWebViewDelegate{

    var currentNewsItem:NewsItem!
    
    var popularcomment = popularComment()
    var newscontent = newsContent()
    var instantcomment = instantComment()
    
    
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
                
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
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
                
                
                
                commentTextView = InputTextView(frame: CGRectZero)
                commentTextView.backgroundColor = bgColor
                //UIColor(white: 250/255, alpha: 1)
                commentTextView.delegate = self
                commentTextView.font = UIFont.systemFontOfSize(FontSize)
                commentTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                commentTextView.layer.borderWidth = 0.5
                commentTextView.layer.cornerRadius = 5
                commentTextView.scrollsToTop = false
                commentTextView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(commentTextView)
                
                
                // Auto Layout allows `sendButton` to change width, e.g., for localization.
                leftButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                commentTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
                rightButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Left, relatedBy:.Equal , toItem: toolBar, attribute: .Left, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Left, relatedBy: .Equal, toItem: leftButton, attribute: .Right, multiplier: 1, constant: 2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Right, relatedBy: .Equal, toItem: rightButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: rightButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
            }
            return toolBar
        }
    }

    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        

        
//        tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        tableView.backgroundColor = bgColor
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
        
//        let request = NSURLRequest(URL: NSURL(string: "http://www.cnblogs.com/zhuqil/archive/2011/07/28/2119923.html")!)
        webView.scalesPageToFit = false

        webView.loadHTMLString(currentNewsItem.htmlContent, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath))

        
//        webView.loadRequest(request)
        
        titleview.addSubview(scrollView)
        scrollView.addSubview(webView)
//        titleview.addSubview(tableView)
//        tableView.hidden = true
        
        webView.delegate = self
//        webView.hidden = true
//        webView.alpha = 0
        
        newstitle.text = currentNewsItem.title
        
        
        tableView.addPullToRefresh({ [weak self] in
            sleep(1)
          
            self!.comment_refresh()
            })


        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "menuControllerWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil)

        
        
        }
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        
//        if !me.newsList[me.currentNews].instantComment.draft.isEmpty {
//            commentTextView.text = me.newsList[me.currentNews].instantComment.draft
//            me.newsList[me.currentNews].instantComment.draft = ""
//            textViewDidChange(commentTextView)
//            commentTextView.becomeFirstResponder()
//        }
    }
    
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
            if toolBar.frame.height > textViewMaxHeight.landscape {
                toolBar.frame.size.height = textViewMaxHeight.landscape+8*2-0.5
            }
        } else { // portrait
            updateTextViewHeight()
        }
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    

    

    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return nil
//    }
//    
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0
//        {
//            return 40.0
//        }
//        return 0.0
//    }
//    
//override  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        println(section)
////        if section == 0 {
////            
////            titleview = titleView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
////            
////            
////            let tap = UITapGestureRecognizer(target: self, action: "didTap:")
////            titleview.addGestureRecognizer(tap)
////            return titleview
////        }
//        return nil
//    }
//
    
    
    
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
        let oldHeight = commentTextView.frame.height
        //        println("old \(oldHeight)")
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(commentTextView.sizeThatFits(CGSize(width: commentTextView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
            #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        //         println("new \(newHeight)")
        let heightChange = newHeight - oldHeight
        if heightChange != 0 {
            toolBar.frame.origin.y -= heightChange
            commentTextView.frame.size.height += heightChange
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
        
            conversation.queryMessagesBeforeId(currentNewsItem.instantComment.loadedMessages[0].messageId, timestamp: 0, limit: 20) {
            (objects:[AnyObject]!,error: NSError!) -> Void in
            if (error != nil) {
                let alert = UIAlertView(title: "操作失败", message: error.description, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
            }
            else {
                self.tableView.reloadData()
            }
           }
        
        }
        else {
            
            conversation.queryMessagesBeforeId(currentNewsItem.popularComment.loadedMessages[0].messageId, timestamp: 0, limit: 20) {
                (objects:[AnyObject]!,error: NSError!) -> Void in
                if (error != nil) {
                    let alert = UIAlertView(title: "操作失败", message: error.description, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                else {
                    self.tableView.reloadData()
                }
            }

            
            
        }
        
    }
    
    
    
    
    
    
    
    func comment_send(newComment: AVIMMessage ){
        
       currentNewsItem.instantComment.loadedMessages.append(newComment)
        conversation.sendMessage(newComment) {
            (bool:Bool,error: NSError!) -> Void in
//            if (error != nil) {
//                let alert = UIAlertController(title: "错误", message: error.description, preferredStyle: .Alert)
//                let action = UIAlertAction(title: "OK", style: .Default , handler: {
//                    action in
//                    //self.startNewRound()
//                    //self.updateLabels()
//                })
//                alert.addAction(action)
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
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
        
        
     //   comment_send(singleComment)
    }
    
    
    
    
    
    
    
    func didTap(sender: UITapGestureRecognizer) {
        
//        let frame = CGRectMake(0, 0, arrow.image!.size.height, arrow.image!.size.width);
        
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
                    cellheight = actualSize.height
        newFrame.size = actualSize
        webView.frame = newFrame
        scrollView.contentSize = actualSize
        println("as\(actualSize) ch:\(cellheight)")
        
        
        
        
    }

    
    
}
