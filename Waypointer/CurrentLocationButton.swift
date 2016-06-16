//
//  CurrentLocationButton.swift
//  Waypointer
//
//  Created by Ryan on 6/15/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class CurrentLocationButton: UIButton {
    
    var groups: GroupScreen?
    var redVal = 0.5
    var blueVal = 0.5
    var greenVal = 0.5
    var alphaVal = 0.3
    
    public init(groups : GroupScreen) {
        self.groups = groups
        super.init(frame: CGRect(x: 5, y: groups.frame.height / 2, width: groups.frame.width - 10, height: classes.addButtonDimension))
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.addTarget(self, action: #selector(AddGroup.pressed(_:)), forControlEvents: .TouchUpInside)

    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override public func drawRect(rect: CGRect) {
        let name = "Current Location"
        let fieldColor: UIColor = UIColor.blackColor()
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(25))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        paraStyle.alignment = NSTextAlignment.Center
        let skew = 0.1
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        name.drawInRect(CGRectMake(0, 3, rect.width, rect.height), withAttributes: attributes as [NSObject : AnyObject] as? [String : AnyObject])
    }
    
    func pressed(sender: UIButton!) {
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.groups!.currentLocationGroup()
    }
    
    func finish() {
        self.redVal = 0.5
        self.blueVal = 0.5
        self.backgroundColor = UIColor(red: CGFloat(self.redVal), green: CGFloat(self.greenVal), blue: CGFloat(self.blueVal), alpha: CGFloat(self.alphaVal))
        classes.cantRecal = false
    }
    
}
