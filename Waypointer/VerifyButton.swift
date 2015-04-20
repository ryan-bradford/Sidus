//
//  VerifyButton.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class VerifyButton : UIButton {
    
    var redVal = 1.0
    var blueVal = 1.0
    var alphaVal = 0.3
    
    public init() {
        super.init(frame: CGRectMake(0, 0, CGFloat(classes.screenWidth), CGFloat(classes.screenHeight)))
        self.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: 1, blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
    }
    
    override public func drawRect(rect: CGRect) {
        var message  = "Move Forward Then Tap The Screen"
        
        let fieldColor: UIColor = UIColor.darkGrayColor()
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(18))
        var paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        var skew = 0.1
        var attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        message.drawInRect(CGRectMake(CGFloat(classes.screenWidth / 2.0 - Double(count(message)) * 5.0) + 10, CGFloat(classes.screenHeight / 2.0), 300.0, 60.0), withAttributes: attributes as [NSObject : AnyObject])
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pressed(sender: UIButton!) {
        classes.canContinue = true
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: 1, blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
    }
    
}
