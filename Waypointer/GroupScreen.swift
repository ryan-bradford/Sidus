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
    
    var buttons : Array<GroupButton>
    var manage : WaypointManager
    var goAwayGroupScreen = false

    required public init?(coder aDecoder: NSCoder) {
        buttons = Array<GroupButton>()
        manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngle: 1.0, groups: Array<WaypointGroup>(), startFromNorth: 0.0)
        goAwayGroupScreen = false
        super.init(coder: aDecoder)
    }
    
    public init(manage : WaypointManager) {
        self.manage = manage
        buttons = Array<GroupButton>()
        super.init(frame : CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        self.addTarget(self, action: #selector(GroupScreen.pressed(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        for i in 0 ..< self.manage.groups.count {
            buttons.append(GroupButton(group: manage.groups[i], order: i, manage: manage, goAwayGroupScreen: goAwayGroupScreen))
            self.addSubview(buttons[buttons.count - 1])
            
        }
        self.backgroundColor = (UIColor(red: 1, green: 1, blue: 1, alpha: 0.3))
    }
    
    override public func drawRect(rect: CGRect) {

        let message1  = "Press Which Group You Want to Add or Remove"
        let message: NSMutableAttributedString = NSMutableAttributedString(string: message1)
        
        let fieldColor: UIColor = UIColor.blackColor()
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(25))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.Center
        paraStyle.lineSpacing = 6.0
        let skew = 0.1
        message.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(25)], range: NSRange(location: 5, length: 2))
        
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        let countString = (message.length)
        message.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(25)], range: NSRange(location: 0, length: countString))
        message.addAttributes(attributes as! [String : AnyObject], range: NSRange(location: 0, length: countString) )
        //let toSubtract = CGFloat(countString / 2 * 7)
        message.drawInRect(CGRectMake(CGFloat(0), CGFloat(classes.screenHeight - 80.0), 300.0, 60.0))
        
    }
    
    func pressed(sender: UIButton!) {
        self.goAwayGroupScreen = true
    }
    
}