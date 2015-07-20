//
//  GroupScreen.swift
//  Waypointer
//
//  Created by Ryan on 6/22/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class GroupScreen : UIButton {
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        super.init(frame : CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        self.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchUpInside);
        for var i = 0; i < classes.groups.count; i++ {
            self.addSubview(GroupButton(group: classes.groups[i], order: i))
        }
        self.backgroundColor = (UIColor(red: 1, green: 1, blue: 1, alpha: 0.3))
    }
    
    override public func drawRect(rect: CGRect) {

        var message1  = "Press Which Group You Want to Add or Remove"
        var message: NSMutableAttributedString = NSMutableAttributedString(string: message1)
        
        let fieldColor: UIColor = UIColor.blackColor()
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(25))
        var paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.Center
        paraStyle.lineSpacing = 6.0
        var skew = 0.1
        message.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(25)], range: NSRange(location: 5, length: 2))
        
        var attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        let countString = (message.length)
        message.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(25)], range: NSRange(location: 0, length: countString))
        message.addAttributes(attributes as [NSObject : AnyObject], range: NSRange(location: 0, length: countString) )
        let toSubtract = CGFloat(countString / 2 * 7)
        message.drawInRect(CGRectMake(CGFloat(0), CGFloat(classes.screenHeight - 80.0), 300.0, 60.0))
        
    }
    
    func pressed(sender: UIButton!) {
        classes.goAwayGroupScreen = true
    }
    
}