//
//  GroupButton.swift
//  Waypointer
//
//  Created by Ryan on 6/22/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

class GroupButton : UIButton {

    var width = 0
    var height = 0
    var myID = 0
    
    // #1
    required init(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    // #2
    init(group : WaypointGroup, order : Int) {
        myID = order
        var numPerRow = 3
        var numPerCollom = 15
        var xPos = order % numPerRow
        var yPos = order / numPerCollom
        var xCord = 50 + (xPos * (Int(classes.screenWidth) - 50) / numPerRow)
        var yCord = 50 + yPos * (Int(classes.screenHeight) - 50) / numPerCollom
        width = (Int(classes.screenWidth) - 50) / numPerRow - 5
        height = (Int(classes.screenHeight - 50) / numPerCollom - 5)
        super.init(frame: CGRect(x: xCord, y: yCord, width: width, height: height));
        self.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchUpInside);
        self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    func pressed(sender: UIButton!) {
        classes.goAwayGroupScreen = true
        classes.manage.addGroup(classes.groups[myID])
    }
    
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    
    
    
    
    
}