//
//  GroupButton.swift
//  Sidus
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
    var goAwayGroupScreen : Bool
    var shouldRedraw = true

    // #1
    required init?(coder: NSCoder) {
        manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngleX: 1.0, cameraAngleY: 1.0, groups: Array<WaypointGroup>(), startFromNorth: 0.0)
        goAwayGroupScreen = false
        super.init(coder: coder);
    }
    
    // #2
    init(group : WaypointGroup, order : Int, manage : WaypointManager, goAwayGroupScreen : Bool) {
        self.manage = manage
        self.goAwayGroupScreen = goAwayGroupScreen
        myID = order
        let xPos = order % Int(numPerRow)
        let yPos = order / Int(numPerRow)
        let screenHeight = classes.screenHeight - spaceNeeded
        let xCord = 20 + (xPos * (Int(classes.screenWidth - 20)) / Int(numPerRow))
        let yCord = 20 + yPos * (Int(screenHeight - 20)) / Int(numPerCollom)
        width = (Int(classes.screenWidth)) / Int(numPerRow) - 25
        height = (Int(screenHeight) / Int(numPerCollom) - 12)
        super.init(frame: CGRect(x: xCord, y: yCord, width: width, height: height));
        self.addTarget(self, action: #selector(GroupButton.pressed(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        self.backgroundColor = UIColor(red: 1, green: 0, blue: 0.2, alpha: 0.8)
    }
    
    func pressed(sender: UIButton!) {
        shouldRedraw = false
        self.manage.groups[myID].active = !self.manage.groups[myID].active
        if(!self.manage.groups[myID].active) {
            self.backgroundColor = UIColor(red: 1, green: 0, blue: 0.2, alpha: 0.8)
            for i in self.manage.groups[myID].waypoints {
                for x in 0 ..< self.manage.drawnWaypoints.count {
                    if(i.myID == self.manage.drawnWaypoints[x].myID) {
                        self.manage.drawnWaypoints[x].removeFromSuperview()
                        self.manage.drawnWaypoints[x].drawn = false
                        self.manage.drawnWaypoints.removeAtIndex(x)
                        i.removeFromSuperview()
                        break
                    }
                }
            }
        }
        if(self.manage.groups[myID].active) {
            self.backgroundColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.8)
        }
        self.goAwayGroupScreen = true
        shouldRedraw = true
    }
    
    override func drawRect(rect: CGRect) {
        let width = CGFloat(classes.screenWidth - 80) / CGFloat(numPerRow)
        let stringDraw = UILabel(frame: CGRect(x: 2, y: CGFloat(1), width: width, height: 20))
        stringDraw.text = self.manage.groups[myID].name
        stringDraw.font = UIFont(name: "Times New Roman", size: CGFloat(12))
        self.addSubview(stringDraw)
    }
    
}