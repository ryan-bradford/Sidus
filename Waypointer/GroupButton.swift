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
    var numPerCollom = 15
    var numPerRow = 3
    var spaceNeeded = 80.0
    
    // #1
    required init(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    // #2
    init(group : WaypointGroup, order : Int) {
        myID = order
        var xPos = order % numPerRow
        var yPos = order / numPerRow
        var screenHeight = classes.screenHeight - spaceNeeded
        var xCord = 20 + (xPos * (Int(classes.screenWidth - 20)) / numPerRow)
        var yCord = 20 + yPos * (Int(screenHeight - 20)) / numPerCollom
        width = (Int(classes.screenWidth)) / numPerRow - 25
        height = (Int(screenHeight) / numPerCollom - 12)
        super.init(frame: CGRect(x: xCord, y: yCord, width: width, height: height));
        self.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchUpInside);
        self.backgroundColor = UIColor(red: 1, green: 0, blue: 0.2, alpha: 0.8)
    }
    
    func pressed(sender: UIButton!) {
        classes.groups[myID].active = !classes.groups[myID].active
        if(!classes.groups[myID].active) {
            self.backgroundColor = UIColor(red: 1, green: 0, blue: 0.2, alpha: 0.8)
            for var i = 0; i < classes.groups[myID].waypoints.count; i++ {
                for var x = 0; x < classes.manage.drawnWaypoints.count; x++ {
                    if(classes.groups[myID].waypoints[i].myID == classes.manage.drawnWaypoints[x].myID) {
                        classes.manage.drawnWaypoints[x].removeFromSuperview()
                        classes.manage.drawnWaypoints.removeAtIndex(x)
                        classes.groups[myID].waypoints[i].removeFromSuperview()                        
                    }
                }
            }
        }
        if(classes.groups[myID].active) {
            self.backgroundColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.8)
        }
        classes.goAwayGroupScreen = true
    }
    
    override func drawRect(rect: CGRect) {
        var width = CGFloat(classes.screenWidth - 80) / CGFloat(numPerRow)
        let stringDraw = UILabel(frame: CGRect(x: 2, y: CGFloat(1), width: width, height: 20))
        stringDraw.text = classes.groups[myID].name
        stringDraw.font = UIFont(name: "Times New Roman", size: CGFloat(12))
        self.addSubview(stringDraw)
    }
    
}