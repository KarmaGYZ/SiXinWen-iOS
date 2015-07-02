//
//  CommentCell.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/3/25.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit
import AVOSCloudIM
import AVOSCloud


let oppoTag = 0, teamTag = 1
let bubbleTag = 2, photoTag = 3


// create image with different colors according to different opinions
func coloredImage(image: UIImage, color:UIColor) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    var components = CGColorGetComponents(color.CGColor)
//    change the color
    CGContextSetRGBFillColor(context, components[0],components[1],components[2],components[3])
        CGContextSetBlendMode(context, kCGBlendModeSourceAtop)
    CGContextFillRect(context, rect)
//    get the image and return it
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}


//make bubble image
func bubbleImageMake() -> (oppo: UIImage, oppoHighlighed: UIImage, team: UIImage, teamHighlighed: UIImage) {
    
    //oppo means left side opinion, team means right side
    let maskTeam = UIImage(named: "MessageBubble")!
    let maskOppo = UIImage(CGImage: maskTeam.CGImage, scale: 2, orientation: .UpMirrored)!
    let capInsetsOppo = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsTeam = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    //create image with four different colors
    let oppo = coloredImage(maskOppo,leftColor).resizableImageWithCapInsets(capInsetsOppo)
    let oppoHighlighted = coloredImage(maskOppo, highLeftColor).resizableImageWithCapInsets(capInsetsOppo)
    let team = coloredImage(maskTeam, rightColor).resizableImageWithCapInsets(capInsetsTeam)
    let teamHighlighted = coloredImage(maskTeam,highRightColor).resizableImageWithCapInsets(capInsetsTeam)
    
    return (oppo, oppoHighlighted, team, teamHighlighted)
}


class BubbleCell: UITableViewCell {
    
    let bubbleImage = bubbleImageMake()
    let bubbleImageView: UIImageView
    let bubbleText: UILabel
    let usrPhoto: UIImageView
    let defaultPhoto: UIImage
    
//    Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
        //create bubble image
        bubbleImageView = UIImageView(image: bubbleImage.oppo, highlightedImage: bubbleImage.oppoHighlighed)
        bubbleImageView.backgroundColor = bgColor
        bubbleImageView.tag = bubbleTag
        bubbleImageView.userInteractionEnabled = true
        
        //initialize the text in the bubble
        bubbleText = UILabel(frame: CGRectZero)
        bubbleText.font = UIFont.systemFontOfSize(FontSize)
        bubbleText.numberOfLines = 0
        bubbleText.userInteractionEnabled = false
        bubbleText.preferredMaxLayoutWidth = 218
        bubbleText.textColor = UIColor.whiteColor()

        //initialize a default round avatar
        defaultPhoto = UIImage(named: "usrwalker")!
        usrPhoto = UIImageView(frame: CGRectZero)
        usrPhoto.layer.cornerRadius = photoSize / 2
        usrPhoto.layer.masksToBounds = true
        usrPhoto.image = defaultPhoto
        usrPhoto.tag = photoTag
        
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        //add those into the contenview of the cell
        contentView.addSubview(usrPhoto)
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(bubbleText)
        
        
        // set layouts for those things (it is supposed to be the cell for left comments defaultly)
        usrPhoto.setTranslatesAutoresizingMaskIntoConstraints(false)
        bubbleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        bubbleText.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // set layout for the bubble
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView,
            attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 50))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView,
            attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView,
            attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -9))
        
        // set layout for the avatar
        contentView.addConstraint(NSLayoutConstraint(item: usrPhoto, attribute: .Left,
            relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -50))
        contentView.addConstraint(NSLayoutConstraint(item: usrPhoto, attribute: .Right,
            relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -20))
        contentView.addConstraint(NSLayoutConstraint(item: usrPhoto, attribute: .Bottom,
            relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -9))
        contentView.addConstraint(NSLayoutConstraint(item: usrPhoto, attribute: .Top,
            relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -39))
        
        // set layout for the text
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleText, attribute: .CenterX,
            relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1, constant: 0))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleText, attribute: .CenterY,
            relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterY, multiplier: 1, constant: -0.5))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Width,
            relatedBy: .Equal, toItem: bubbleText, attribute: .Width, multiplier: 1, constant: 30))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleText, attribute: .Height,
            relatedBy: .Equal, toItem: bubbleImageView, attribute: .Height, multiplier: 1, constant: -15))
        

        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//   highlight cell when selected
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImageView.highlighted = selected
    }
    
    
//    remove old contraints and add new ones 
//    in order to match the opinion
    func reAddConstraints(layoutAttribute:NSLayoutAttribute, layoutConstant:CGFloat,
        leftConstant:CGFloat, rightConstant:CGFloat){
        
        let constraints: NSArray = contentView.constraints()
        
            // find the contraints that determine the location of the bubble and the avatar
        let indexOfConstraint1 = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
            return (constraint.firstItem as! UIView).tag == bubbleTag &&
                (constraint.firstAttribute == .Left || constraint.firstAttribute == .Right)
        }
        let indexOfLeftConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
            return (constraint.firstItem as! UIView).tag == photoTag && constraint.firstAttribute == .Left
        }
        let indexOfRightConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
            return (constraint.firstItem as! UIView).tag == photoTag && constraint.firstAttribute == .Right
        }
        
            // remove those constraints
        contentView.removeConstraint(constraints[indexOfConstraint1] as! NSLayoutConstraint)
        contentView.removeConstraint(constraints[indexOfLeftConstraint] as! NSLayoutConstraint)
        contentView.removeConstraint(constraints[indexOfRightConstraint] as! NSLayoutConstraint)
            
            // readd constraints according to the opinion
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: layoutAttribute,
            relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: layoutConstant))
        
        contentView.addConstraint(NSLayoutConstraint(item: usrPhoto, attribute: .Left,
            relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: leftConstant))
        
        contentView.addConstraint(NSLayoutConstraint(item: usrPhoto, attribute: .Right,
            relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: rightConstant))
        
    }
    
//    cofigure the cell that supports left opinion
    func configureLeftCell(){
        
        var layoutAttribute: NSLayoutAttribute
        var layoutConstant: CGFloat
        var leftConstant: CGFloat
        var rightConstant: CGFloat
    
        tag = oppoTag
        // set the bubble with left color image
        bubbleImageView.image = bubbleImage.oppo
        bubbleImageView.highlightedImage = bubbleImage.oppoHighlighed
        // set the arguments
        layoutAttribute = .Left
        layoutConstant = 50
        leftConstant = 20
        rightConstant = 50
        
        
        //readd the constraints according to different opinions
        reAddConstraints(layoutAttribute, layoutConstant: layoutConstant,
            leftConstant: leftConstant, rightConstant: rightConstant)
        
    }
    
//    cofigure the cell that supports right opinion
    func configureRightCell(){
        
        var layoutAttribute: NSLayoutAttribute
        var layoutConstant: CGFloat
        var leftConstant: CGFloat
        var rightConstant: CGFloat

        tag = teamTag
        // set the bubble with right color image
        bubbleImageView.image = bubbleImage.team
        bubbleImageView.highlightedImage = bubbleImage.teamHighlighed
        // set the arguments
        layoutAttribute = .Right
        layoutConstant = -50
        leftConstant = -50
        rightConstant = -20
        
        //readd the constraints according to different opinions
        reAddConstraints(layoutAttribute, layoutConstant: layoutConstant,
            leftConstant: leftConstant, rightConstant: rightConstant)
        
    }
    
    
    
//    configure the cell for instant comment message
    func configureWithInstantMessage(message: AVIMTextMessage) {
        
            // get its attitude and content
            let attitude = message.attributes
            bubbleText.text = message.text
        
            // this comment supports right opinion
            if attitude["attitude"] != nil && attitude["attitude"] as! Bool == false  {
                configureRightCell()
                
            }
            else { // this comment supports left opinion
                configureLeftCell()
            }
        
        }
    
    
//    configure the cell for popular comment message
    func configureWithPopularMessage(message: singleComment) {
        // get its attitude and content
        let attitude = message.attitude
        bubbleText.text = message.text
        
        // this comment supports left opinion
        if attitude == true {
             configureLeftCell()
                
        } else { // this comment supports right opinion
             configureRightCell()
        }
        
    }

    
    
}
