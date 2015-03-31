//
//  NewsCell.swift
//  SiXinWen-iOS
//
//  Created by Karma Guo on 3/31/15.
//  Copyright (c) 2015 SiXinWen. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var support: UIProgressView!
    @IBOutlet weak var commentNum: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
