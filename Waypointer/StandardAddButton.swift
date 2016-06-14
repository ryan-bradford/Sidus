//
//  AddButton.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

public class StandardAddButton : UIButton {
    
    var redVal = 0.5
    var blueVal = 0.5
    var greenVal = 0.5
    var alphaVal = 0.3
    var myLetter = "A"
    
    public init(myLetter : String, orderNum : Int) {
        super.init(frame: CGRectMake(5, CGFloat(orderNum * (classes.buttonOutlineWidth + classes.buttonGap)), 40, 40))
        self.myLetter = myLetter
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        removeAllGraphics()
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineWidth = 1
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(0/255), alpha: CGFloat(0.5)).CGColor
        let path = UIBezierPath()
        let width = classes.buttonWidth
        let start = classes.buttonStart
        let sideLength = classes.buttonLength
        path.moveToPoint(CGPoint(x: start, y: start + sideLength))
        path.addLineToPoint(CGPoint(x: start + sideLength, y: start + sideLength))
        path.addLineToPoint(CGPoint(x: start + sideLength, y: start))
        path.addLineToPoint(CGPoint(x: start + sideLength + width, y: start))
        path.addLineToPoint(CGPoint(x: start + sideLength + width, y: start + sideLength))
        path.addLineToPoint(CGPoint(x: start + 2 * sideLength + width, y: start + sideLength))
        path.addLineToPoint(CGPoint(x: start + 2 * sideLength + width, y: start + sideLength + width))
        path.addLineToPoint(CGPoint(x: start + sideLength + width, y: start + sideLength + width))
        path.addLineToPoint(CGPoint(x: start + sideLength + width, y: start + 2 * sideLength + width))
        path.addLineToPoint(CGPoint(x: start + sideLength, y: start + 2 * sideLength + width))
        path.addLineToPoint(CGPoint(x: start + sideLength, y: start + sideLength + width))
        path.addLineToPoint(CGPoint(x: start, y: start + sideLength + width))
        path.closePath()
        shape.path = path.CGPath
        
        let name = myLetter
        let fieldColor: UIColor = UIColor.darkGrayColor()
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(9))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        let skew = 0.1
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        name.drawInRect(CGRectMake(5, 0, 10, 10), withAttributes: attributes as [NSObject : AnyObject] as? [String : AnyObject])
    }
    
    func removeAllGraphics() {
        if(self.layer.sublayers != nil) {
            for v in self.layer.sublayers! {
                v.removeFromSuperlayer()
            }
        }
    }
    
}
