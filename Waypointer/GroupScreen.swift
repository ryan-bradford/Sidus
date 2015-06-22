//
//  GroupScreen.swift
//  Waypointer
//
//  Created by Ryan on 6/22/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class GroupScreen : UIView {
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        super.init(frame : CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        for var i = 0; i < classes.groups.count; i++ {
            self.addSubview(GroupButton(group: classes.groups[i], order: i))
        }
        self.backgroundColor = (UIColor(red: 1, green: 1, blue: 1, alpha: 0.3))
    }
    
    
    
    
    
    
}