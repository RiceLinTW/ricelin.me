//
//  RLMenuButtons.swift
//  SwiftExample
//
//  Created by RiceLin on 8/18/16.
//  Copyright © 2016 RiceLin. All rights reserved.
//

import UIKit

enum RLMenuButtonExpandDirection : Int {
    case LeftToRight = 0
    case RightToLeft = 1
    case TopToBottom = 2
    case BottomToTop = 3
    case CenterToLeftTop = 4
    case CenterToLeftBottom = 5
    case CenterToRightTop = 6
    case CenterToRightBottom = 7
}

class RLMenuButton: UIButton {
    
    var fillColor        : UIColor = UIColor.redColor()
    var strokeColor      : UIColor = UIColor.whiteColor()
    
    var menuItems           : [UIView]?
    var parentItem          : RLMenuButton?
    var expandDirection     : RLMenuButtonExpandDirection   = .BottomToTop
    var isExpand            : Bool                          = false
    var horizontalExpandGap : CGFloat                       = 10
    var verticalExpandGap   : CGFloat                       = 10
    var sectorExpandRadius  : CGFloat?
    var animateDuration     : NSTimeInterval                = 0.3
    var image               : UIImage?
    var textEdgeInsets      : UIEdgeInsets?
    
    convenience init(frame: CGRect, menuItems: [UIView]?, expandDirection: RLMenuButtonExpandDirection) {
        self.init()
        self.frame = frame
        self.menuItems = menuItems
        self.expandDirection = expandDirection
        self.addTarget(self, action: #selector(RLMenuButton.tapButtonAction), forControlEvents: .TouchUpInside)
    }

    override func drawRect(rect: CGRect) {
        self.clipsToBounds = false
        if self.sectorExpandRadius == nil {
            self.sectorExpandRadius = rect.size.width / 2 * CGFloat(1 / sin(M_PI_2 / Double(self.menuItems!.count + 1) / 2))
        }
        if self.image == nil {
            let path = UIBezierPath(ovalInRect: rect)
            fillColor.setFill()
            path.fill()
            
            let menuPath = UIBezierPath()
            menuPath.lineWidth = rect.height / 12
            
            let quotientX = Int(rect.size.width / 4)
            let quotientY = Int(rect.size.height / 6)
            let remainderX = Int(rect.size.width % 4)
            let remainderY = Int(rect.size.height % 6)
            
            for i in 1...3 {
                let initailX = CGFloat(remainderX / 2 + quotientX)
                let initailY = CGFloat(remainderY / 2 + quotientY * (i + 1))
                let initailPostion = CGPointMake(initailX, initailY)
                let endX = rect.size.width - CGFloat(remainderX / 2 + quotientX)
                
                let endPosition = CGPointMake(endX, initailY)
                
                menuPath.moveToPoint(initailPostion)
                menuPath.addLineToPoint(endPosition)
            }
            
            strokeColor.setStroke()
            menuPath.stroke()
        } else {
            self.setBackgroundImage(image, forState: .Normal)
        }
        
        setTextEdgeInsets()
    }
    
    func setTextEdgeInsets() {
        if textEdgeInsets == nil {
            switch self.expandDirection {
            case .LeftToRight, .RightToLeft:
                self.titleEdgeInsets = UIEdgeInsetsMake(self.frame.height, -self.frame.width, -self.frame.height, -self.frame.width)
                break
            case .TopToBottom, .BottomToTop, .CenterToLeftTop, .CenterToLeftBottom:
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.frame.width * 2, 0, self.frame.width)
                break
            case .CenterToRightTop, .CenterToRightBottom:
                self.titleEdgeInsets = UIEdgeInsetsMake(0, self.frame.width, 0, -self.frame.width * 2)
                break
            }
        } else {
            self.titleEdgeInsets = textEdgeInsets!
        }
    }
    
    func showTextLabel() {
        UIView.animateWithDuration(animateDuration, animations: { 
            self.titleLabel?.alpha = 1
            }, completion: nil)
    }
    
    func hideTextLabel() {
        UIView.animateWithDuration(animateDuration, animations: { 
            self.titleLabel?.alpha = 0
            }, completion: nil)
    }
    
    func tapButtonAction() {
        self.enabled = false
        guard self.allTargets().count < 2 else {
            return
        }
        if self.parentItem != nil {
            for button in self.parentItem!.menuItems! {
                if button != self && button.isKindOfClass(RLMenuButton) {
                    if (button as! RLMenuButton).isExpand {
                        (button as! RLMenuButton).tapButtonAction()
                    }
                }
            }
        }
        
        if menuItems?.count > 0 {
            for i in 1...menuItems!.count {
                let menuItem = self.menuItems![i - 1]
                if menuItem.superview == nil {
                    menuItem.frame = self.frame
                    menuItem.layer.cornerRadius = menuItem.frame.width / 2
                    menuItem.layer.masksToBounds = true
                    if i == 1 {
                        superview?.insertSubview(menuItem, belowSubview: self)
                    } else {
                        superview?.insertSubview(menuItem, belowSubview: self.menuItems![i - 2])
                    }
                    if menuItem.isKindOfClass(RLMenuButton) {
                        (menuItem as! RLMenuButton).parentItem = self
                        (menuItem as! RLMenuButton).setTextEdgeInsets()
                        (menuItem as! RLMenuButton).titleLabel?.alpha = 0
                    }
                } else {
                    UIView.animateWithDuration(animateDuration, animations: { 
                        menuItem.frame.origin = self.frame.origin
                    })
                }
            }
            
            if isExpand {
                unexpandAll()
            } else {
                expandAll()
            }
        }
    }
    
    func unexpandSubItems(sender : UIView) {
        if sender.isKindOfClass(RLMenuButton) {
            let menuButton = sender as! RLMenuButton
            if menuButton.menuItems != nil {
                for item in menuButton.menuItems! {
                    if item.superview != nil {
                        UIView.animateWithDuration(animateDuration, animations: {
                            item.frame.origin = menuButton.frame.origin
                        })
                        menuButton.isExpand = false
                        unexpandSubItems(item)
                    }
                }
            }
        }
    }
    
    func unexpandAll() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.duration = animateDuration
        
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat(-M_PI * 2)
        for i in 1...menuItems!.count {
            self.menuItems![i - 1].layer.addAnimation(rotateAnimation, forKey: nil)
            if self.menuItems![i - 1].isKindOfClass(RLMenuButton) {
                (self.menuItems![i - 1] as! RLMenuButton).titleLabel?.alpha = 0
            }
            UIView.animateWithDuration(animateDuration, animations: {
                self.titleLabel?.alpha = 1
                self.unexpandSubItems(self.menuItems![i - 1])
                self.menuItems![i - 1].frame.origin = self.frame.origin
            })
        }
        self.enabled = true
        isExpand = false
    }
    
    func expandAll() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.duration = animateDuration
        
        let popAnimation = CABasicAnimation(keyPath: "transform.scale")
        popAnimation.duration = animateDuration
        popAnimation.fromValue = 1
        popAnimation.toValue = 1.3
        popAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        popAnimation.autoreverses = true
        popAnimation.repeatCount = 1
        
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat(M_PI * 2)
        for i in 1...menuItems!.count {
            UIView.animateWithDuration(animateDuration, animations: {
                self.titleLabel?.alpha = 0
                self.menuItems![i - 1].layer.addAnimation(rotateAnimation, forKey: nil)
                
                var centerX : CGFloat = 0
                var centerY : CGFloat = 0
                switch self.expandDirection {
                case .LeftToRight:
                    centerX = self.center.x + CGFloat(i) * (self.horizontalExpandGap + self.frame.width)
                    centerY = self.center.y
                    break
                case .RightToLeft:
                    centerX = self.center.x - CGFloat(i) * (self.horizontalExpandGap + self.frame.width)
                    centerY = self.center.y
                    break
                case .TopToBottom:
                    centerX = self.center.x
                    centerY = self.center.y + CGFloat(i) * (self.verticalExpandGap + self.frame.height)
                    break
                case .BottomToTop:
                    centerX = self.center.x
                    centerY = self.center.y - CGFloat(i) * (self.verticalExpandGap + self.frame.height)
                    break
                case .CenterToLeftTop:
                    centerX = self.center.x - self.sectorExpandRadius! * cos(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    centerY = self.center.y - self.sectorExpandRadius! * sin(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    break
                case .CenterToLeftBottom:
                    centerX = self.center.x - self.sectorExpandRadius! * cos(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    centerY = self.center.y + self.sectorExpandRadius! * sin(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    break
                case .CenterToRightTop:
                    centerX = self.center.x + self.sectorExpandRadius! * cos(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    centerY = self.center.y - self.sectorExpandRadius! * sin(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    break
                case .CenterToRightBottom:
                    centerX = self.center.x + self.sectorExpandRadius! * cos(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    centerY = self.center.y + self.sectorExpandRadius! * sin(CGFloat(M_PI_2 / Double(self.menuItems!.count * 2) * Double(i * 2 - 1)))
                    break
                }
                self.menuItems![i - 1].center = CGPointMake(centerX, centerY)
                self.unexpandSubItems(self.menuItems![i - 1])
                }, completion: { (complete) in
                    if self.menuItems![i - 1].isKindOfClass(RLMenuButton) {
                        (self.menuItems![i - 1] as! RLMenuButton).showTextLabel()
                    }
                    self.enabled = true
            })
        }
        self.layer.addAnimation(popAnimation, forKey: nil)
        isExpand = true
    }
}
