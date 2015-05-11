//
//  newsContentCell.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/7.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

class newsContentCell: UITableViewCell {

//    let scrollView: UIScrollView
//    let webView: UIWebView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        
//        println("cellheight \(cellheight)")
//        
//        webView = UIWebView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width, cellheight))
//    
//        let request = NSURLRequest(URL: NSURL(string: "http://www.cnblogs.com/zhuqil/archive/2011/07/28/2119923.html")!)
//        webView.scalesPageToFit = false
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
       
//        let webView = UIWebView(frame: scrollView.frame)
        
//          contentView.frame =  CGRectMake(0,0,UIScreen.mainScreen().bounds.width, cellheight)
//        
//        webView.loadRequest(request)
//      
//        contentView.backgroundColor = UIColor.greenColor()
//       webView.alpha = 0
//
//        scrollView.addSubview(webView)
//        contentView.addSubview(webView)
        
        
        
//        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        contentView.addConstraint(NSLayoutConstraint(item: webView, attribute: .Left, relatedBy:.Equal , toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
//        contentView.addConstraint(NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
//        contentView.addConstraint(NSLayoutConstraint(item:webView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -10))
//        contentView.addConstraint(NSLayoutConstraint(item:webView, attribute: .Top, relatedBy: .Equal, toItem:contentView, attribute: .Top, multiplier: 1, constant: 4.5))
//        
//        
        
        
        
    }
    
        
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
  

    
    
    
}
