//
//  CurrentLocationButton.swift
//  waypointr
//
//  Created by Ryan on 6/15/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import UIKit

open class CurrentLocationButton: UIButton {
    
    var groups: AddGroupScreen?
    var redVal = 0.5
    var blueVal = 0.5
    var greenVal = 0.5
    var alphaVal = 0.3
    
    public init(groups : AddGroupScreen) {
        self.groups = groups
        super.init(frame: CGRect(x: 5, y: groups.frame.height / 2, width: groups.frame.width - 10, height: classes.addButtonDimension))
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.addTarget(self, action: #selector(CurrentLocationButton.pressed(_:)), for: .touchUpInside)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override open func draw(_ rect: CGRect) {
        let name = "Current Location"
        let fieldColor: UIColor = UIColor.black
        let fieldFont = UIFont(name: "Symbol", size: CGFloat(25))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        paraStyle.alignment = NSTextAlignment.center
        let skew = 0.1
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        name.draw(in: CGRect(x: 0, y: 3, width: rect.width, height: rect.height), withAttributes: attributes as! [AnyHashable: Any] as? [String : AnyObject])
    }
    
    func pressed(_ sender: UIButton!) {
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
