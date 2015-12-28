//
//  WaypointManager.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class WaypointManager {
    
    public var drawnWaypoints :  Array<Waypoint>
    public var allWaypoints :  Array<Waypoint>
    var personX : Double
    var personY : Double
    var personZ : Double
    var horAngle = 0.0
    var vertAngle = 0.0
    var horAngleScaler = 1
    var vertAngleScaler = 1
    var cameraAngle : Double
    var groups : Array<WaypointGroup>
    var startFromNorth : Double
    
    init(x : Double, y : Double, z : Double, cameraAngle : Double, groups : Array<WaypointGroup>, startFromNorth : Double) {
        self.startFromNorth = startFromNorth
        self.groups = groups
        self.cameraAngle = cameraAngle
        allWaypoints = Array<Waypoint>()
        drawnWaypoints = Array<Waypoint>()
        personX = x
        personY = y
        personZ = z
    }
    
    public func addWaypoint(xPos : Double, yPos : Double, zPos : Double, red : Int, green : Int, blue : Int, name : String) {
        allWaypoints.append(Waypoint(xPos: xPos, yPos: yPos, zPos: zPos, red: red, green: green, blue: blue, name : name, cameraAngle : cameraAngle, manage: self, startFromNorth: startFromNorth))
    }
    
    public func addWaypoint(toAdd : Waypoint) {
        allWaypoints.append(toAdd)
    }
    
    
    public func removeWaypoint(ID : Int) {
        allWaypoints.removeAtIndex(ID)
    }
    
    public func changePersonLocation(xPos : Double, yPos : Double, zPos : Double) {
        personX = xPos
        personY = yPos
        personZ = zPos
        for var i = 0;  i < drawnWaypoints.count;  i++ {
            drawnWaypoints[i].updatePersonPossition()
        }
    }
    
    public func orderWaypoints() { //Correct Ordering and Add Limit
        let start = allWaypoints
        for var i = 0; i < self.groups.count; i++ {
            if(self.groups[i].active) {
                for var z = 0; z < self.groups[i].waypoints.count; z++ {
                    allWaypoints.append(self.groups[i].waypoints[z])
                }
            }
        }
        var newWaypoints = Array<Waypoint>()
        var heighestID = 0
        var numToAdd = classes.numWaypoints
        if(allWaypoints.count < classes.numWaypoints) {
            numToAdd = allWaypoints.count
        }
        for var x = 0; x < numToAdd; x++ {
            heighestID = 0
            for var i = 0; i < allWaypoints.count; i++ {
                if(allWaypoints[i].line.length < allWaypoints[heighestID].line.length) {
                    heighestID = i
                }
            }
            allWaypoints[heighestID].orderNum = newWaypoints.count
            newWaypoints.append(allWaypoints[heighestID])
            allWaypoints.removeAtIndex(heighestID)
        }
        processNewGroup(newWaypoints)
        allWaypoints = start
    }
    
    func processNewGroup(newGroup : Array<Waypoint>) {
        var drawnWaypoints = Array<Waypoint>()
        for var i = 0; i < self.drawnWaypoints.count; i++ {
            drawnWaypoints.append(self.drawnWaypoints[i])
        }
        for var i = 0; i < drawnWaypoints.count; i++ {
            var found = false
            for var x = 0; x < newGroup.count; x++ {
                if((newGroup[x].name as NSString).isEqualToString(drawnWaypoints[i].name)) {
                    found = true
                }
            }
            if(!found) {
                drawnWaypoints[i].removeFromSuperview()
            }
        }
        self.drawnWaypoints = newGroup
    }
    
    func generateVars() {
        var drawnWaypoints = self.drawnWaypoints
        for var i = 0; i < drawnWaypoints.count; i++ {
            drawnWaypoints[i].generateVars()
        }
        for var i = 0; i < drawnWaypoints.count; i++ { //This may be reverse
            var count = 0.0
            for var x = i; x < drawnWaypoints.count; x++ {//Change to checking if both boxes overlap, not just point and box
                if self.checkY(i, x: x) {
                    if self.checkX(i, x: x) {
                        count += drawnWaypoints[x].ySize
                    }
                }
            }
            drawnWaypoints[i].yShift = count
        }
        self.drawnWaypoints = drawnWaypoints
    }
    
    func checkY(i : Int, x : Int) -> Bool {
        //xmax1 >= xmin2 and xmax2 >= xmin1
        let realYSizeX = drawnWaypoints[x].ySize// * 5/3
        let realYSizeI = drawnWaypoints[i].ySize// * 5/3
        let iMax = drawnWaypoints[i].y
        let iMin = drawnWaypoints[i].y - realYSizeI
        let xMax = drawnWaypoints[x].y
        let xMin = drawnWaypoints[x].y - realYSizeX
        if iMax >= xMin {
            if xMax >= iMin {
                return true
            }
        }
        return false
    }
    
    func checkX(i : Int, x : Int) -> Bool {
        //xmax1 >= xmin2 and xmax2 >= xmin1
        let realXSizeX = drawnWaypoints[x].xSize // * 5/2
        let realXSizeI = drawnWaypoints[i].xSize // * 5/2
        let iMax = drawnWaypoints[i].x + realXSizeI / 2
        let iMin = drawnWaypoints[i].x - realXSizeI / 2
        let xMax = drawnWaypoints[x].x + realXSizeX / 2
        let xMin = drawnWaypoints[x].x - realXSizeX / 2
        if iMax >= xMin {
            if xMax >= iMin {
                return true
            }
        }
        return false
    }
    
}

