//
//  GroupButton.swift
//  waypointr
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
    var numPerCollom = classes.groupsPerCollum
    var numPerRow = classes.groupsPerRow
    var spaceNeeded = 80.0
    var manage : WaypointManager
    var shouldRedraw = true
	var superRect: CGRect!

    // #1
    required init?(coder: NSCoder) {
        manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngleX: 1.0, cameraAngleY: 1.0, groups: Array<WaypointGroup>(), startFromNorth: 0.0)
        super.init(coder: coder);
    }
    
    // #2
	init(group : WaypointGroup, order : Int, manage : WaypointManager, superFrame: CGRect) {
        self.manage = manage
		self.superRect = superFrame
        myID = order
        let xPos = order % Int(numPerRow)
        let yPos = order / Int(numPerRow)
        let screenHeight = superFrame.height
        let xCord = 20 + (xPos * (Int(superFrame.width - 20)) / Int(numPerRow)) + Int(superFrame.origin.x)
        let yCord = 20 + yPos * (Int(screenHeight - 20)) / Int(numPerCollom) + Int(superFrame.origin.y)
        width = (Int(superFrame.width)) / Int(numPerRow) - 25
        height = (Int(screenHeight) / Int(numPerCollom) - 12)
        super.init(frame: CGRect(x: xCord, y: yCord, width: width, height: height));
        self.addTarget(self, action: #selector(GroupButton.pressed(_:)), for: UIControlEvents.touchUpInside);
        self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
    }
    
    func pressed(_ sender: UIButton!) {
        shouldRedraw = false
        self.manage.groups[myID].active = !self.manage.groups[myID].active
        if(!self.manage.groups[myID].active) {
            self.backgroundColor = UIColor(red: 1, green: 0, blue: 0.2, alpha: 0.8)
            for i in self.manage.groups[myID].waypoints {
                for x in 0 ..< self.manage.drawnWaypoints.count {
                    if(i.myID == self.manage.drawnWaypoints[x].myID) {
                        self.manage.drawnWaypoints[x].removeFromSuperview()
                        self.manage.drawnWaypoints[x].drawn = false
                        self.manage.drawnWaypoints.remove(at: x)
                        i.removeFromSuperview()
                        break
                    }
                }
            }
        }
        if(self.manage.groups[myID].active) {
            self.backgroundColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.8)
        }
        shouldRedraw = true
    }
    
    override func draw(_ rect: CGRect) {
		self.drawTextWithBox(0, y: 0, width: self.frame.width, height: self.frame.height, toDraw: self.manage.groups[myID].name, fontSize: 12)
    }
    
}
