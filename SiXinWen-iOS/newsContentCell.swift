//
//  newsContentCell.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/4/7.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

class newsContentCell: UITableViewCell, UIWebViewDelegate {

//    let bubbleImageView: UIImageView
//    let newsContentText: UILabel
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        
//        let backgroundColor = bgColor
//        
//        
//        newsContentText = UILabel(frame: CGRectZero)
//        newsContentText.font = UIFont.systemFontOfSize(FontSize)
//        newsContentText.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        newsContentText.numberOfLines = 0
//        newsContentText.text = "柴静走访多个污染现场寻找雾霾根源，赴多国实地了解治污经验，并从国家层面和个人层面提出了行动方案。\n她实地勘察：在燃煤消耗和钢材生产大省河北，经历了无人机因雾霾过重而无法记录污染情况的尴尬；她亲自携带采样仪，在雾霾中生活一天，一个白色的采样仪变为黑色，从中检测出15种致癌物质，最危险的一种物质的含量超过国家标准14倍.\n通过调查她告诉我们，在北京，每天高峰时段，有34%的车在路上堵着，六环以内每小时PM2.5的排放量是1吨；在燃煤污染致死数千人的伦敦雾霾事件过后62年，她前往因雾霾丧生者的墓地凭吊，也去到仍烧壁炉的人家拜访，当年伦敦“禁排黑烟”、“限烟区只能烧无烟煤，财政补贴壁炉改造的大部分费用”等规定的条文，具体化为男主人手中清洁的煤块——煤是可以干净的；为考察同样恶名昭著但污染源主要是汽车尾气的洛杉矶光化学污染现象，她在直升机上俯瞰这座车轮上的城市摊大饼式的道路模式和对汽车的高度依赖，在公路边直击加州空气资源管理委员会的官员向没给重型柴油车加装空气颗粒物过滤器的司机开出罚单。\n她查阅文献：对一些人所称的伦敦雾霾治理四五十年方见成效的说法，她发现开始治理的头十年就降低了80%的大气污染物；还把官员和业界已知的秘密推到公众视野之中：一艘海轮排放的PM2.5几乎等于50万辆货车，而轮船和飞机的燃油还没有得到像汽车用油那样的哪怕不算严格的监管。\n她拜访各方面专家：她直问中国石化集团前总工程师、国家石油标准委员会主任曹湘洪：为什么是石化行业而不是环保部门主导油品标准制定？为什么不公开油品标准升级的成本？有没有可能放开油品市场？她用数据视觉化，把包括中国科学院院士、前卫生部部长陈竺与专家合作发表于《柳叶刀》杂志的报告估计的中国每年因室外空气污染导致35万至50万人早死这样惨烈的数字，处理得通俗、形象、警醒。\n探查真相之后，她用行动以尽绵薄之力：看到家门口有一片工地裸露，她试着与施工者交涉，结果扬尘的土堆得到覆盖；楼下的餐馆没有加装油烟处理装置，她打了举报电话12369，餐馆老板果然装上了法规要求安装的设备；加油站的加油枪汽油挥发严重，她又向环保部门举报，加油站答应马上修好防挥发装置。她的体会是，如果不打，12369就只是一个数字。她建议网友：表达你的不满、维护你的权益。"
//        
//        
//        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .None
//        
//        
//        
//        contentView.addSubview(newsContentText)
//        newsContentText.setTranslatesAutoresizingMaskIntoConstraints(false)
//        contentView.addConstraint(NSLayoutConstraint(item: newsContentText, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
//        
//        contentView.addConstraint(NSLayoutConstraint(item: newsContentText, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -10))
//        
//        contentView.addConstraint(NSLayoutConstraint(item: newsContentText, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 4.5))
//        contentView.addConstraint(NSLayoutConstraint(item: newsContentText, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
////
//    }
    
    let scrollView: UIScrollView
//    let webView: UIWebView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
    
        scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    
        let request = NSURLRequest(URL: NSURL(string: "http://www.cnblogs.com/zhuqil/archive/2011/07/28/2119923.html")!)
//        webView.scalesPageToFit = false
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
       
        let webView = UIWebView(frame: scrollView.frame)
        
        webView.loadRequest(request)
        webView.delegate = self
//
        scrollView.addSubview(webView)
        contentView.addSubview(scrollView)
//        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        
//        
//        
//        contentView.addConstraint(NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
//        
//        contentView.addConstraint(NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -10))
//        
//        contentView.addConstraint(NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 4.5))
//        
//        contentView.addConstraint(NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
//

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let actualSize = webView.sizeThatFits(CGSizeZero)
        var newFrame = webView.frame
        newFrame.size = actualSize
        if newFrame != webView.frame
        {
            webView.frame = newFrame
            println("hi actualsize\(actualSize)")
            scrollView.contentSize = actualSize
        }
    }
    

    
    
    
}
