//
//  CommentCell.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/3/25.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit


let incomingTag = 0, outgoingTag = 1

let bubbleTag = 8

func coloredImage(image: UIImage, color:UIColor) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    var components = CGColorGetComponents(color.CGColor)
    CGContextSetRGBFillColor(context, components[0],components[1],components[2],components[3])
        CGContextSetBlendMode(context, kCGBlendModeSourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

func bubbleImageMake() -> (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) {
    let maskOutgoing = UIImage(named: "MessageBubble")!
    let maskIncoming = UIImage(CGImage: maskOutgoing.CGImage, scale: 2, orientation: .UpMirrored)!
    
    let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)

    let incoming = coloredImage(maskIncoming,leftColor).resizableImageWithCapInsets(capInsetsIncoming)
    let incomingHighlighted = coloredImage(maskIncoming, highLeftColor).resizableImageWithCapInsets(capInsetsIncoming)
    let outgoing = coloredImage(maskOutgoing, rightColor).resizableImageWithCapInsets(capInsetsOutgoing)
    let outgoingHighlighted = coloredImage(maskOutgoing,highRightColor).resizableImageWithCapInsets(capInsetsOutgoing)
    
    return (incoming, incomingHighlighted, outgoing, outgoingHighlighted)
}


let bubbleImage = bubbleImageMake()

let commentFontSize: CGFloat = 17

class CommentCell: UITableViewCell {
    
    
//    let usrPhoto:UIImage
    
    let bubbleImageView: UIImageView
    let commentLabel: UILabel
    let like: UIButton
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
        bubbleImageView = UIImageView(image: bubbleImage.incoming, highlightedImage: bubbleImage.incomingHighlighed)
        bubbleImageView.backgroundColor = bgColor
        bubbleImageView.tag = bubbleTag
        bubbleImageView.userInteractionEnabled = true // #CopyMesage
        
        commentLabel = UILabel(frame: CGRectZero)
        commentLabel.font = UIFont.systemFontOfSize(commentFontSize)
        commentLabel.numberOfLines = 0
        commentLabel.userInteractionEnabled = false   // #Copycomment
       
        like = UIButton(frame: CGRectZero)
        
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(commentLabel)
        
        bubbleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        commentLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 4.5))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Width, relatedBy: .Equal, toItem: commentLabel, attribute: .Width, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
        
        bubbleImageView.addConstraint(NSLayoutConstraint(item: commentLabel, attribute: .CenterX, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1, constant: 3))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: commentLabel, attribute: .CenterY, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterY, multiplier: 1, constant: -0.5))
        commentLabel.preferredMaxLayoutWidth = 218
        bubbleImageView.addConstraint(NSLayoutConstraint(item: commentLabel, attribute: .Height, relatedBy: .Equal, toItem: bubbleImageView, attribute: .Height, multiplier: 1, constant: -15))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Highlight cell #Copy
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImageView.highlighted = selected
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureWithComment(comment: aComment) {
        commentLabel.text = comment.text
        
//        if comment.incoming != (tag == incomingTag) {
            var layoutAttribute: NSLayoutAttribute
            var layoutConstant: CGFloat
            
            if comment.incoming {
                tag = incomingTag
                bubbleImageView.image = bubbleImage.incoming
                bubbleImageView.highlightedImage = bubbleImage.incomingHighlighed
                commentLabel.textColor = UIColor.whiteColor()
                layoutAttribute = .Left
                layoutConstant = 10
            } else { // outgoing
                tag = outgoingTag
                bubbleImageView.image = bubbleImage.outgoing
                bubbleImageView.highlightedImage = bubbleImage.outgoingHighlighed
                commentLabel.textColor = UIColor.whiteColor()
                layoutAttribute = .Right
                layoutConstant = -10
            }
            
            let layoutConstraint: NSLayoutConstraint = bubbleImageView.constraints()[1] as! NSLayoutConstraint // `messageLabel` CenterX
            layoutConstraint.constant = -layoutConstraint.constant
            
            let constraints: NSArray = contentView.constraints()
            let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                return (constraint.firstItem as! UIView).tag == bubbleTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
            contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: layoutAttribute, relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: layoutConstant))
//        }
    }
    
    
    
    
    
}
