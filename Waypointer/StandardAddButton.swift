//
//  AddButton.swift
//  Sidus
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
    var myLetter : String?
    
    public init(myLetter : String, orderNum : Int) {
        super.init(frame: CGRectMake(5, CGFloat(orderNum * (classes.buttonOutlineWidth + classes.buttonGap)), classes.addButtonDimension, classes.addButtonDimension))
        self.myLetter = myLetter
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.addTarget(self, action: #selector(AddGroup.pressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    public init(myLetter : String, y : CGFloat, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRectMake(5, y, width, height))
        self.myLetter = myLetter
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.addTarget(self, action: #selector(AddGroup.pressed(_:)), forControlEvents: .TouchUpInside)
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
        let width = CGFloat(classes.buttonWidth)
        let startX = CGFloat(classes.buttonStart) * rect.width / classes.addButtonDimension
        let startY = CGFloat(classes.buttonStart) * rect.height / classes.addButtonDimension
        let sideLengthW = CGFloat(classes.buttonLength) * rect.width / classes.addButtonDimension
        let sideLengthH = CGFloat(classes.buttonLength) * rect.height / classes.addButtonDimension
        path.moveToPoint(CGPoint(x: startX, y: startY + sideLengthH))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW, y: startY + sideLengthH))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW, y: startY))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW + width, y: startY))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW + width, y: startY + sideLengthH))
        path.addLineToPoint(CGPoint(x: startX + 2 * sideLengthW + width, y: startY + sideLengthH))
        path.addLineToPoint(CGPoint(x: startX + 2 * sideLengthW + width, y: startY + sideLengthH + width))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW + width, y: startY + sideLengthH + width))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW + width, y: startY + 2 * sideLengthH + width))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW, y: startY + 2 * sideLengthH + width))
        path.addLineToPoint(CGPoint(x: startX + sideLengthW, y: startY + sideLengthH + width))
        path.addLineToPoint(CGPoint(x: startX, y: startY + sideLengthH + width))
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
        name!.drawInRect(CGRectMake(5, 0, 10, 10), withAttributes: attributes as [NSObject : AnyObject] as? [String : AnyObject])
    }
    
    func removeAllGraphics() {
        if(self.layer.sublayers != nil) {
            for v in self.layer.sublayers! {
                v.removeFromSuperlayer()
            }
        }
    }
    
    func pressed(sender: UIButton!) {
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
    }
    
    func finish() {
        self.redVal = 0.5
        self.blueVal = 0.5
        self.backgroundColor = UIColor(red: CGFloat(self.redVal), green: CGFloat(self.greenVal), blue: CGFloat(self.blueVal), alpha: CGFloat(self.alphaVal))
        classes.cantRecal = false
    }
}
