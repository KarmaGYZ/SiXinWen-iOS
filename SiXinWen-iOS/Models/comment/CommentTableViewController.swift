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
        if (delegate as CommentTableViewController).tableView.indexPathForSelectedRow() != nil {
            return action == "messageCopyTextAction:"
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}


class CommentTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {


    let toolBarMinHeight: CGFloat = 44
    let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)
    
    
    var tableView = UITableView()
    let comments = Comments()
    var toolBar:UIToolbar!
    var commentTextView:UITextView!
    var sendButton:UIButton!
    var rotating = false
    
    
    let whiteColor = UIColor.whiteColor()
    
  
    
    
    func shiftSegment(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:  break
            
        case 1: break
            
        default: break
            
        }
        
    }
    


    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
                
               commentTextView = InputTextView(frame: CGRectZero)
               commentTextView.backgroundColor = UIColor(white: 250/255, alpha: 1)
               commentTextView.delegate = self
               commentTextView.font = UIFont.systemFontOfSize(commentFontSize)
               commentTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
               commentTextView.layer.borderWidth = 0.5
               commentTextView.layer.cornerRadius = 5
               commentTextView.scrollsToTop = false
               commentTextView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(commentTextView)
                
                sendButton = UIButton.buttonWithType(.System) as UIButton
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                sendButton.setTitle("Send", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(sendButton)
                
                // Auto Layout allows `sendButton` to change width, e.g., for localization.
               commentTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
                sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 8))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item:commentTextView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
            }
            return toolBar
        }
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        var shiftSegmentControl = UISegmentedControl(frame: CGRectMake(80.0, 8.0, 200.0, 30.0))
        shiftSegmentControl.insertSegmentWithTitle("即时评论", atIndex: 0, animated: true)
        shiftSegmentControl.insertSegmentWithTitle("热门评论", atIndex: 1, animated: true)
        shiftSegmentControl.momentary = true
        shiftSegmentControl.multipleTouchEnabled = false
        shiftSegmentControl.userInteractionEnabled = true
        shiftSegmentControl.addTarget(self, action: "shiftSegment:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = shiftSegmentControl
        
        
        comments.loadedComments =  [
            [
                aComment(incoming: true, text: "I really enjoyed programming with you! :-)"),
                aComment(incoming: false, text: "Thanks! Me too! :-)")
            ]

        ]
    
        view.backgroundColor = whiteColor
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        tableView.backgroundColor = whiteColor
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
    
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        comments.draft = commentTextView.text
    }
    
    
    func updateTextViewHeight() {
        let oldHeight = commentTextView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(commentTextView.sizeThatFits(CGSize(width: commentTextView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
            #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight+8*2-0.5
        }
    }

    
    
    func textViewDidChange(textView: UITextView!) {
        updateTextViewHeight()
        sendButton.enabled = textView.hasText()
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

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return comments.loadedComments.count + 1
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section != 0{
             return  comments.loadedComments[section-1].count
        }
       
        return 1
        
        
    }

    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
  //  println(indexPath.section)
    
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(CommentCell)) as UITableViewCell
            return cell
        } else {
            let cellIdentifier = NSStringFromClass(CommentCell)
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as CommentCell!
            if cell == nil {
                cell = CommentCell(style: .Default, reuseIdentifier: cellIdentifier)
                
                // Add gesture recognizers #CopyMessage
//                let action: Selector = "messageShowMenuAction:"
//                let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
//                doubleTapGestureRecognizer.numberOfTapsRequired = 2
//                cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
//                cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
            }
            println(comments.loadedComments[indexPath.section-1].count)
            println(indexPath.row)
            let singleComment = comments.loadedComments[indexPath.section-1][indexPath.row]
            cell.configureWithComment(singleComment)
            return cell
        }

        }
    
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let insetNewBottom = self.tableView.convertRect(frameNew, fromView: nil).height
        let insetOld = self.tableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        let overflow = self.tableView.contentSize.height - (self.tableView.frame.height-insetOld.top-insetOld.bottom)
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
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
            let options = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
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


    func tableViewScrollToBottomAnimated(animated: Bool) {
        let numberOfRows = tableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }


    func sendAction() {
        // Autocomplete text before sending #hack
        commentTextView.resignFirstResponder()
        commentTextView.becomeFirstResponder()
        
        comments.loadedComments.append([aComment(incoming: false, text: commentTextView.text)])
        commentTextView.text = nil
        updateTextViewHeight()
        sendButton.enabled = false
        
        let lastSection = tableView.numberOfSections()
        tableView.beginUpdates()
        tableView.insertSections(NSIndexSet(index: lastSection), withRowAnimation: .Automatic)
        tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: 0, inSection: lastSection),
            NSIndexPath(forRow: 1, inSection: lastSection)
            ], withRowAnimation: .Automatic)
//        tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
    }

    
    
    func messageShowMenuAction(gestureRecognizer: UITapGestureRecognizer) {
        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
        let doubleTap = (twoTaps && gestureRecognizer.state == .Ended)
        let longPress = (!twoTaps && gestureRecognizer.state == .Began)
        if doubleTap || longPress {
            let pressedIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
            tableView.selectRowAtIndexPath(pressedIndexPath, animated: false, scrollPosition: .None)
            
            let menuController = UIMenuController.sharedMenuController()
            let bubbleImageView = gestureRecognizer.view!
            menuController.setTargetRect(bubbleImageView.frame, inView: bubbleImageView.superview!)
            menuController.menuItems = [UIMenuItem(title: "Copy", action: "messageCopyTextAction:")]
            menuController.setMenuVisible(true, animated: true)
        }
    }
    // 2. Copy text to pasteboard
    func messageCopyTextAction(menuController: UIMenuController) {
        let selectedIndexPath = tableView.indexPathForSelectedRow()
        let selectedMessage = comments.loadedComments[selectedIndexPath!.section][selectedIndexPath!.row-1]
        UIPasteboard.generalPasteboard().string = selectedMessage.text
    }
    // 3. Deselect row
    func menuControllerWillHide(notification: NSNotification) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
        (notification.object as UIMenuController).menuItems = nil
    }



    
    
    
}

    
    
    

