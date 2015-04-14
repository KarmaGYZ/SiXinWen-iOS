//
//  CommentTableViewController.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/3/25.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

class InputTextView: UITextView {
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if (delegate as! CommentTableViewController).tableView.indexPathForSelectedRow() != nil {
            return action == "copyTextAction:"
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}


public let defaultColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
public let leftColor = UIColor(red: 77/255, green: 188/255, blue: 249/255, alpha: 1)
public let highLeftColor = UIColor(red: 51/255.0, green: 102/255.0, blue: 205/255.0, alpha: 1)
public let rightColor = UIColor(red: 253/255, green: 13/255, blue: 68/255, alpha: 1)
public let highRightColor = UIColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1)
public let bgColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)


class CommentTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{
    
    let comments = Comments()
    
    var popularcomment = popularComment.alloc()
    var newscontent = newsContent.alloc()
    
    var titleview:titleView!
//    var contentView:UIScrollView!
    var tableView = UITableView()
    
   
    var rotating = false
    
    var showcontent = false
    
    let whiteColor = UIColor.whiteColor()

   
    
    var  shiftSegmentControl = UISegmentedControl(frame: CGRectMake(80.0, 8.0, 200.0, 30.0))
    var toolBar:UIToolbar!
    var commentTextView:UITextView!
    var rightButton = UIButton()
    var leftButton = UIButton()
    
    
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
                commentTextView.font = UIFont.systemFontOfSize(commentFontSize)
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
        comments.draft = commentTextView.text
        //   willHideNewsContent()
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
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        
        if !comments.draft.isEmpty {
            commentTextView.text = comments.draft
            comments.draft = ""
            textViewDidChange(commentTextView)
            commentTextView.becomeFirstResponder()
        }
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
    
            
    func shiftSegment(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            toolBar.hidden = true
            tableView.dataSource = popularcomment
//            tableView.delegate = instantcomment
            tableView.reloadData()
            
            break
            
        case 1:
            toolBar.hidden = false
            tableView.dataSource = self
//            tableView.delegate = self
            tableView.reloadData()
            break
            
        default: break
            
        }
        
    }
    
      
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        shiftSegmentControl.insertSegmentWithTitle("即时评论", atIndex: 1, animated: true)
        shiftSegmentControl.insertSegmentWithTitle("热门评论", atIndex: 0, animated: true)
        shiftSegmentControl.selectedSegmentIndex = 1
//        shiftSegmentControl.momentary = true
        shiftSegmentControl.multipleTouchEnabled = false
        shiftSegmentControl.userInteractionEnabled = true
        shiftSegmentControl.addTarget(self, action: "shiftSegment:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = shiftSegmentControl
        
        
        comments.loadedComments = [
        
        aComment(incoming: true, text: "公知简直太多 什么人都可以当。。。"),
        aComment(incoming: false, text: "那您干什么去了？")
        
        ]
                  
        
        
        view.backgroundColor = bgColor
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        tableView.backgroundColor = bgColor
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        self.tableView.contentInset = edgeInsets
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.keyboardDismissMode = .Interactive
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .None
        tableView.registerClass(CommentCell.self, forCellReuseIdentifier: NSStringFromClass(CommentCell))
        view.addSubview(tableView)
    
        

        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "menuControllerWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil)
        
//        setupInstantComment()
        
    }
    
//    func showContent() {
//        showNewsContent()
//    }
    
    

    
   
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
       // hideNewsContent()
//
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    
   func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 40.0
        }
        return 0.0
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        println(section)
        if section == 0 {
            
            titleview = titleView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
            
            
            let tap = UITapGestureRecognizer(target: self, action: "didTap:")
            titleview.addGestureRecognizer(tap)
            return titleview
        }
        return nil
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return comments.loadedComments.count
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //  println(indexPath.section)
        
        //        if indexPath.row == 0 && indexPath.section == 0 {
        //            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(CommentCell)) as UITableViewCell
        //            cell.backgroundColor = backgroundColor
        //            return cell
        //        } else {
        let cellIdentifier = NSStringFromClass(CommentCell)
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CommentCell!
        if cell == nil {
            cell = CommentCell(style: .Default, reuseIdentifier: cellIdentifier)
            
            // Add gesture recognizers #CopyMessage
            //                     let action: Selector = "showMenuAction:"
            //                     let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
            //                     doubleTapGestureRecognizer.numberOfTapsRequired = 2
            //                     cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
            //                     cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
        }
        //            println(comments.loadedComments[indexPath.section-1].count)
        //            println(indexPath.row)
                cell.backgroundColor = bgColor
                let singleComment = comments.loadedComments[indexPath.row]
                cell.configureWithComment(singleComment)
        return cell
        //        }
        
    }

    
      
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
        
    
    
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
    
    
    
    func sendAction(sender: UIButton) {
        // Autocomplete text before sending #hack
        commentTextView.resignFirstResponder()
        commentTextView.becomeFirstResponder()
        
        var left = false
        
        if sender.titleLabel?.text == "动嘴"{
            left = true
            titleview.support.progress /= 0.8
        }
        else {
            titleview.support.progress *= 0.8
        }
        
        comments.loadedComments.append(aComment(incoming: left, text: commentTextView.text))
        commentTextView.text = nil
        updateTextViewHeight()
        leftButton.enabled = false
        rightButton.enabled = false
        
        let lastsec = tableView.numberOfSections() - 1
        let lastrow = tableView.numberOfRowsInSection(lastsec)
        tableView.beginUpdates()
        //        tableView.insertSections(NSIndexSet(index: lastsec+1), withRowAnimation: .None)
        //        tableView.insertRowsAtIndexPaths(NSIndexPath(forRow: lastrow, inSection: lastsec ), withRowAnimation: .Automatic)
//        println(lastrow)
//        println(lastsec)
        tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: lastrow, inSection: lastsec)
            ], withRowAnimation: .Automatic)
        tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
    }
    
    
    

    
    
    
    func didTap(sender: UITapGestureRecognizer) {
        
        
        if showcontent == false {
            
            showcontent = true
            toolBar.hidden = true
            tableView.dataSource = newscontent
            tableView.reloadData()
        } else {
            toolBar.hidden = false
            showcontent = false
            if shiftSegmentControl.selectedSegmentIndex == 1 {
            tableView.dataSource = self
            }
            else {
                tableView.dataSource = popularcomment
            }
//       tableView.dataSource
            tableView.reloadData()

            
            
            
        }
        
        
    }
    
 
    
    func tableViewScrollToBottomAnimated(animated: Bool) {
        let lastSection = tableView.numberOfSections() - 1
        let numberOfRows = tableView.numberOfRowsInSection(lastSection)
        println(lastSection)
        //        println(numberOfRows)
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: lastSection), atScrollPosition: .Bottom, animated: animated)
        
    }

    
//    func setupInstantComment() {
//        
//         var instantcommentDataSource = DataSource(cellData: comments.loadedComments, cellIdentifier: NSStringFromClass(CommentCell)
////            , configureCell: {(cell, cellData) in
////        
////            var instantCommentCell = cell as CommentCell
////            instantCommentCell.configureWithComment(cellData as aComment)
////        }
//        )
//        
//        self.tableView.dataSource = instantcommentDataSource
//    }
    
    
    
    
//    
//    func showMenuAction(gestureRecognizer: UITapGestureRecognizer) {
//        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
//        let doubleTap = (twoTaps && gestureRecognizer.state == .Ended)
//        let longPress = (!twoTaps && gestureRecognizer.state == .Began)
//        if doubleTap || longPress {
//            let pressedIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
//            tableView.selectRowAtIndexPath(pressedIndexPath, animated: false, scrollPosition: .None)
//            
//            let menuController = UIMenuController.sharedMenuController()
//            let bubbleImageView = gestureRecognizer.view!
//            menuController.setTargetRect(bubbleImageView.frame, inView: bubbleImageView.superview!)
//            menuController.menuItems = [UIMenuItem(title: "Copy", action: "copyTextAction:")]
//            menuController.setMenuVisible(true, animated: true)
//        }
//    }
//    // 2. Copy text to pasteboard
//    func copyTextAction(menuController: UIMenuController) {
//        let selectedIndexPath = tableView.indexPathForSelectedRow()
//        let selectedMessage = comments.loadedComments[selectedIndexPath!.section][selectedIndexPath!.row-1]
//        UIPasteboard.generalPasteboard().string = selectedMessage.text
//    }
//    // 3. Deselect row
//    func menuControllerWillHide(notification: NSNotification) {
//        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
//            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
//        }
//        (notification.object as UIMenuController).menuItems = nil
//    }
//    
//    
//    
//    
    
    
}





