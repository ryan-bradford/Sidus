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
        super.init(frame: CGRect(x: 5, y: groups.frame.height - 2*classes.addButtonDimension, width: groups.frame.width - 10, height: classes.addButtonDimension))
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.addTarget(self, action: #selector(CurrentLocationButton.pressed(_:)), for: .touchUpInside)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override open func draw(_ rect: CGRect) {
        let name = "Current Location"
		self.drawTextWithBox(0, y: 0, width: self.frame.width, height: self.frame.height, toDraw: name, fontSize: 25)
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
