//
//  contentView.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/4/3.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

public enum State {
    case Shown
    case Closed
    case Displaying
}

public typealias completionHandler = Bool -> ()

public class newsContentView: UIView {
   
    
    public var currentState: State?
     public let CRITERION = UIScreen.mainScreen().bounds.size.height / 2
    
    
    var _height: CGFloat?
    public var height: CGFloat? {
        get {
            return _height
        }
        set {
            if _height != newValue {
                var contentFrame: CGRect = frame
                contentFrame.size.height = newValue!
                contentView?.frame = contentFrame
                _height = newValue
            }
        }
    }

    
    
    private var _contentView: UIView?
    private var contentView: UIView? {
        get {
            return _contentView
        }
        set {
            if _contentView != newValue && newValue != nil{
//                newValue?.delegate = self
//                newValue?.dataSource = self
//                newValue?.showsVerticalScrollIndicator = false
//                newValue?.separatorColor = UIColor.clearColor()
//                newValue?.allowsMultipleSelection = false
                _contentView = newValue
                addSubview(_contentView!)
            }
        }
    }

    private var _contentController: UIViewController?
    
    var contentController: UIViewController? {
        
        get {
            return _contentController
        }
        set {
            
            let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPan:")
            if _contentController != newValue {
                if newValue == nil {
                    _contentController = nil
                    
                }
                else {
                    
                if  newValue?.navigationController != nil {
                    _contentController = newValue?.navigationController
                } else {
                    _contentController = newValue
                }
                
               
                
                
                
                _contentController?.view.addGestureRecognizer(pan)
//                
//                setShadowProperties()
                _contentController?.view.autoresizingMask = UIViewAutoresizing.None
                var Controller: UIViewController = UIViewController()
                Controller.view = self
//                UIApplication.sharedApplication().delegate?.window??.rootViewController = Controller
//                UIApplication.sharedApplication().delegate?.window??.addSubview(_contentController!.view!)
                }
            }
        
        }
    }

    // Status Bar
    
    public func showStatusBar() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
    }
    
    public func dismissStatusBar() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
    }
    
    public func animateClosingWithCompletion(completion: completionHandler?) {
        dismissStatusBar()
        UIView.animateWithDuration(0.2, animations: {[unowned self]() -> Void in
            let center = self.contentController!.view.center
            self.contentController?.view.center = CGPointMake(center.x, center.y + MENU_BOUNCE_OFFSET)
            }, completion: {[unowned self](finished: Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: {[unowned self]() -> Void in
                    let center = self.contentController!.view.center
                    self.contentController?.view.center = CGPointMake(center.x, self.CRITERION)
                    }, completion: {(finished: Bool) -> Void in
                        if finished {
                            self.currentState = State.Closed
                            if completion != nil {
                                completion!(finished)
                            }
                        }
                })
        })
    }

    public func animateOpening() {
        showStatusBar()
        if currentState != State.Shown {
            UIView.animateWithDuration(0.2, animations: {[unowned self]() -> Void in
                let x = self.contentController!.view.center.x
                self.contentController?.view.center = CGPointMake(x, self.CRITERION + self.height!)
                }, completion: {[unowned self](finished: Bool) -> Void in
                    UIView.animateWithDuration(0.2, animations: {[unowned self]() -> Void in
                        let x = self.contentController!.view.center.x
                        self.contentController?.view.center = CGPointMake(x, self.CRITERION + self.height! - MENU_BOUNCE_OFFSET
)                        }, completion: {(finished: Bool) -> Void in
                            self.currentState = State.Shown
                    })
            })
        }
    }

    
    public func showContent() {
        if contentController == nil {
            return
        }
        if currentState == State.Shown || currentState == State.Displaying {
            animateClosingWithCompletion(nil)
        } else {
            currentState = State.Displaying
            animateOpening()
        }
    }

    public func hideContent() {
        if contentController == nil {
            return
        }
        animateClosingWithCompletion(nil)
        
    }

    
    
    
    public func openFromCenterWithVelocity(velocity: CGFloat) {
        showStatusBar()
        let viewCenterY: CGFloat = CRITERION + height! - MENU_BOUNCE_OFFSET
        currentState = State.Displaying
        let duration: NSTimeInterval = Double((viewCenterY - contentController!.view.center.y) / velocity)
        UIView.animateWithDuration(duration, animations: {[unowned self]() -> Void in
            let center = self.contentController!.view.center
            self.contentController?.view.center = CGPointMake(center.x, viewCenterY)
            }, completion: {[unowned self](finished: Bool) -> Void in
                self.currentState = State.Shown
        })
    }

    public func closeFromCenterWithVelocity(velocity: CGFloat) {
        dismissStatusBar()
        let viewCenterY: CGFloat = CRITERION
        currentState = State.Displaying
        let duration: NSTimeInterval = Double((contentController!.view.center.y - viewCenterY) / velocity)
        UIView.animateWithDuration(duration, animations: {[unowned self]() -> Void in
            let center = self.contentController!.view.center
            self.contentController?.view.center = CGPointMake(center.x, self.CRITERION)
            }, completion: {[unowned self](finished: Bool) -> Void in
                self.currentState = State.Closed
        })
    }

    
    public func didPan(pan: UIPanGestureRecognizer) {
        if contentController == nil {
            return
        }
        var viewCenter: CGPoint = pan.view!.center
        if pan.state == UIGestureRecognizerState.Began || pan.state == UIGestureRecognizerState.Changed {
            let translation: CGPoint = pan.translationInView(pan.view!.superview!)
            if viewCenter.y >= CRITERION && viewCenter.y <= (CRITERION + height!) - MENU_BOUNCE_OFFSET {
                currentState = State.Displaying
                viewCenter.y = abs(viewCenter.y + translation.y)
                if viewCenter.y >= CRITERION && viewCenter.y <= (CRITERION + height!) - MENU_BOUNCE_OFFSET {
                    contentController?.view.center = viewCenter
                }
                pan.setTranslation(CGPointZero, inView: contentController?.view)
            }
        } else if pan.state == UIGestureRecognizerState.Ended {
            let velocity: CGPoint = pan.velocityInView(contentController?.view.superview)
            if velocity.y > VELOCITY_TRESHOLD {
                openFromCenterWithVelocity(velocity.y)
                return
            } else if velocity.y < -VELOCITY_TRESHOLD {
                closeFromCenterWithVelocity(abs(velocity.y))
                return
            }
            if viewCenter.y <= contentController?.view.frame.size.height {
                animateClosingWithCompletion(nil)
            } else {
                animateOpening()
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.currentState = State.Closed
        self.height = MENU_HEIGHT
    }
/*
    override public init() {
        super.init()
    }
*/
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(viewController: UIViewController)
    {
        self.init()
        self.contentController = viewController
        self.frame =  CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen.mainScreen().bounds))
        self.contentView = UIView(frame: self.frame)
        contentView?.backgroundColor = UIColor.greenColor()
        
    }

    
//    deinit{
//        
//        contentController = nil
//        
//    }
    
//    public class var sharedInstance: newsContentView {
//        struct Static {
//            static let instance: newsContentView = newsContentView()
//        }
//        return Static.instance
//    }
//
    
    
}
