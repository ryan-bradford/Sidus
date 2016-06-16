//
//  CurrentLocationButton.swift
//  Waypointer
//
//  Created by Ryan on 6/15/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class CurrentLocationButton: StandardAddButton {
    
    var groups: GroupScreen?
    
    public init(groups : GroupScreen) {
        self.groups = groups
        super.init(myLetter: "C", orderNum: 5)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func pressed(sender: UIButton!) {
        super.pressed(sender)
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.groups!.currentLocationGroup()
    }
    
}
