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
            return action == "copyTextAction:"
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
}




class CommentTableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{
    
    let comments = Comments()
    
    var popularcomment = popularComment.alloc()
    var newscontent = newsContent.alloc()
    
    var titleview:UIView!
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
    
    let backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    
    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
                let defaultColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
                let leftColor = UIColor(red: 77/255, green: 188/255, blue: 249/255, alpha: 1)
                let rightColor = UIColor(red: 253/255, green: 13/255, blue: 68/255, alpha: 1)
                
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
                toolBar.backgroundColor = UIColor.whiteColor()
                
                
                
                leftButton = UIButton.buttonWithType(.Custom) as UIButton
                leftButton.backgroundColor = leftColor
                leftButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                leftButton.enabled = false
                leftButton.setTitle("动嘴", forState: .Normal)
                leftButton.setTitleColor(leftColor, forState: .Disabled)
                leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                leftButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                leftButton.addTarget(self, action: "sendAction:", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(leftButton)
                
                
                rightButton = UIButton.buttonWithType(.Custom) as UIButton
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
                commentTextView.backgroundColor = UIColor(white: 250/255, alpha: 1)
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
                  
        
        
        view.backgroundColor = backgroundColor
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        tableView.backgroundColor = backgroundColor
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        self.tableView.contentInset = edgeInsets
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.keyboardDismissMode = .Interactive
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .None
        tableView.registerClass(CommentCell.self, forCellReuseIdentifier: NSStringFromClass(CommentCell))
        view.addSubview(tableView)
    
        
//        contentView = UIScrollView(frame: CGRectMake(0, 40, tableView.frame.width, tableView.frame.height - 40))
//        contentView.scrollEnabled = true

        
//        var contentText = UILabel(frame: CGRectMake(20, 0, tableView.frame.width-40, tableView.frame.height - 40));
//        contentText.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        contentText.numberOfLines = 0
//        contentText.text = "柴静走访多个污染现场寻找雾霾根源，赴多国实地了解治污经验，并从国家层面和个人层面提出了行动方案。\n她实地勘察：在燃煤消耗和钢材生产大省河北，经历了无人机因雾霾过重而无法记录污染情况的尴尬；她亲自携带采样仪，在雾霾中生活一天，一个白色的采样仪变为黑色，从中检测出15种致癌物质，最危险的一种物质的含量超过国家标准14倍.\n通过调查她告诉我们，在北京，每天高峰时段，有34%的车在路上堵着，六环以内每小时PM2.5的排放量是1吨；在燃煤污染致死数千人的伦敦雾霾事件过后62年，她前往因雾霾丧生者的墓地凭吊，也去到仍烧壁炉的人家拜访，当年伦敦“禁排黑烟”、“限烟区只能烧无烟煤，财政补贴壁炉改造的大部分费用”等规定的条文，具体化为男主人手中清洁的煤块——煤是可以干净的；为考察同样恶名昭著但污染源主要是汽车尾气的洛杉矶光化学污染现象，她在直升机上俯瞰这座车轮上的城市摊大饼式的道路模式和对汽车的高度依赖，在公路边直击加州空气资源管理委员会的官员向没给重型柴油车加装空气颗粒物过滤器的司机开出罚单。\n她查阅文献：对一些人所称的伦敦雾霾治理四五十年方见成效的说法，她发现开始治理的头十年就降低了80%的大气污染物；还把官员和业界已知的秘密推到公众视野之中：一艘海轮排放的PM2.5几乎等于50万辆货车，而轮船和飞机的燃油还没有得到像汽车用油那样的哪怕不算严格的监管。\n她拜访各方面专家：她直问中国石化集团前总工程师、国家石油标准委员会主任曹湘洪：为什么是石化行业而不是环保部门主导油品标准制定？为什么不公开油品标准升级的成本？有没有可能放开油品市场？她用数据视觉化，把包括中国科学院院士、前卫生部部长陈竺与专家合作发表于《柳叶刀》杂志的报告估计的中国每年因室外空气污染导致35万至50万人早死这样惨烈的数字，处理得通俗、形象、警醒。\n探查真相之后，她用行动以尽绵薄之力：看到家门口有一片工地裸露，她试着与施工者交涉，结果扬尘的土堆得到覆盖；楼下的餐馆没有加装油烟处理装置，她打了举报电话12369，餐馆老板果然装上了法规要求安装的设备；加油站的加油枪汽油挥发严重，她又向环保部门举报，加油站答应马上修好防挥发装置。她的体会是，如果不打，12369就只是一个数字。她建议网友：表达你的不满、维护你的权益。"
//        contentText.backgroundColor = whiteColor
//        contentView.addSubview(contentText)
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as CommentCell!
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
                cell.backgroundColor = backgroundColor
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
    
    
    
    func sendAction(sender: UIButton) {
        // Autocomplete text before sending #hack
        commentTextView.resignFirstResponder()
        commentTextView.becomeFirstResponder()
        
        var left = false
        
        if sender.titleLabel?.text == "动嘴"{
            left = true
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
        println(lastrow)
        println(lastsec)
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





