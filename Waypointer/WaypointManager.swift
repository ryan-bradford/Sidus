//
//  WaypointManager.swift
//  waypointr
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


open class WaypointManager {
    
    open var drawnWaypoints :  Array<Waypoint>
    open var allWaypoints :  Array<Waypoint>
    var personX : Double
    var personY : Double
    var personZ : Double
    var horAngle = 0.0
    var vertAngle = 0.0
    var horAngleScaler = 1
    var vertAngleScaler = 1
    var cameraAngleX : Double
    var cameraAngleY : Double
    var groups : Array<WaypointGroup>
    var startFromNorth : Double
    var waitCount = 6
    
    init(x : Double, y : Double, z : Double, cameraAngleX : Double, cameraAngleY: Double, groups : Array<WaypointGroup>, startFromNorth : Double) {
        self.startFromNorth = startFromNorth
        self.cameraAngleX = cameraAngleX
        self.cameraAngleY = cameraAngleY
        self.groups = groups
        allWaypoints = Array<Waypoint>()
        drawnWaypoints = Array<Waypoint>()
        personX = x
        personY = y
        personZ = z
    }
    
    open func addWaypoint(_ xPos : Double, yPos : Double, zPos : Double, red : Int, green : Int, blue : Int, name : String) {
        allWaypoints.append(Waypoint(xPos: xPos, yPos: yPos, zPos: zPos, red: red, green: green, blue: blue, displayName : name, cameraAngleX : cameraAngleX, cameraAngleY: cameraAngleY, manage: self))
    }
    
    open func addWaypoint(_ toAdd : Waypoint) {
        allWaypoints.append(toAdd)
    }
    
    
    open func removeWaypoint(_ ID : Int) {
        allWaypoints.remove(at: ID)
    }
    
    open func changePersonLocation(_ xPos : Double, yPos : Double, zPos : Double) {
        personX = xPos
        personY = yPos
        personZ = zPos
        for i in 0 ..< drawnWaypoints.count {
            drawnWaypoints[i].updatePersonPossition()
        }
    }
    
    open func orderWaypoints() { //Correct Ordering and Add Limit
        if(waitCount > 5) {
            let start = allWaypoints
            for i in 0 ..< self.groups.count {
                if(self.groups[i].active) {
                    for z in 0 ..< self.groups[i].waypoints.count {
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
            for _ in 0 ..< numToAdd {
                heighestID = 0
                for i in 0 ..< allWaypoints.count {
                    if(allWaypoints[i].line!.length < allWaypoints[heighestID].line!.length) {
                        heighestID = i
                    }
                }
                allWaypoints[heighestID].orderNum = newWaypoints.count
                newWaypoints.append(allWaypoints[heighestID])
                allWaypoints.remove(at: heighestID)
            }
            processNewGroup(newWaypoints)
            allWaypoints = start
            waitCount = 0
        } else {
            waitCount += 1
        }
    }
    
    func processNewGroup(_ newGroup : Array<Waypoint>) {
        var drawnWaypoints = Array<Waypoint>()
        for i in 0 ..< self.drawnWaypoints.count {
            drawnWaypoints.append(self.drawnWaypoints[i])
        }
        for i in 0 ..< drawnWaypoints.count {
            var found = false
            for x in 0 ..< newGroup.count {
                if(((newGroup[x].idName! as NSString)).isEqual(to: drawnWaypoints[i].idName!)) {
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
        for i in 0 ..< drawnWaypoints.count {
            drawnWaypoints[i].generateVars()
        }
        for i in 0 ..< drawnWaypoints.count { //This may be reverse
            var count = 0.0
            for x in i ..< drawnWaypoints.count {//Change to checking if both boxes overlap, not just point and box
                if self.checkY(i, x: x) {
                    if self.checkX(i, x: x) {
                        count += drawnWaypoints[x].ySize!
                    }
                }
            }
            drawnWaypoints[i].yShift = count
        }
        self.drawnWaypoints = drawnWaypoints
    }
    
    func checkY(_ i : Int, x : Int) -> Bool {
        //xmax1 >= xmin2 and xmax2 >= xmin1
        let realYSizeX = drawnWaypoints[x].ySize// * 5/3
        let realYSizeI = drawnWaypoints[i].ySize// * 5/3
        let iMax = drawnWaypoints[i].y
        let iMin = drawnWaypoints[i].y! - realYSizeI!
        let xMax = drawnWaypoints[x].y
        let xMin = drawnWaypoints[x].y! - realYSizeX!
        if iMax >= xMin {
            if xMax >= iMin {
                return true
            }
        }
        return false
    }
    
    func checkX(_ i : Int, x : Int) -> Bool {
        //xmax1 >= xmin2 and xmax2 >= xmin1
        let realXSizeX = drawnWaypoints[x].xSize // * 5/2
        let realXSizeI = drawnWaypoints[i].xSize // * 5/2
        let iMax = drawnWaypoints[i].x! + realXSizeI! / 2
        let iMin = drawnWaypoints[i].x! - realXSizeI! / 2
        let xMax = drawnWaypoints[x].x! + realXSizeX! / 2
        let xMin = drawnWaypoints[x].x! - realXSizeX! / 2
        if iMax >= xMin {
            if xMax >= iMin {
                return true
            }
        }
        return false
    }
    
    func updateStartFromNorth() {
        for i in 0 ..< allWaypoints.count {
            allWaypoints[i].manage = self
        }
    }
    
}

