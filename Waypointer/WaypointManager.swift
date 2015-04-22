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
    
    public var waypoints :  Array<Waypoint>
    var screenXAngles : Array<Double>
    var screenYAngles : Array<Double>
    var personX : Double
    var personY : Double
    var personZ : Double
    var personLeftRightRotation = 0.0  // <--> //Left is Positive, Right is Negative
    var personUpDownRotation = 0.0  //Up is Positive, Down is Negative
    
    init(x : Double, y : Double, z : Double, personLeftRightAngle : Double, personUpDownAngle : Double) {
        waypoints = Array<Waypoint>()
        screenXAngles = Array<Double>()
        screenYAngles = Array<Double>()
        personX = x
        personY = y
        personZ = z
        personLeftRightRotation = personLeftRightAngle
        personUpDownRotation = personUpDownAngle
    }
    
    public func addWaypoint(xPos : Double, yPos : Double, zPos : Double, red : Int, green : Int, blue : Int, name : String) {
        waypoints.append(Waypoint(xPos: xPos, yPos: yPos, zPos: zPos, red: red, green: green, blue: blue, name : name))
    }
    
    public func addWaypoint(toAdd : Waypoint) {
        waypoints.append(toAdd)
    }
    
    
    public func removeWaypoint(ID : Int) {
        waypoints.removeAtIndex(ID)
    }
    
    public func changePersonLocation(xPos : Double, yPos : Double, zPos : Double) {
        personX = xPos
        personY = yPos
        personZ = zPos
        for var i = 0;  i < waypoints.count;  i++ {
            waypoints[i].updatePersonPossition()
        }
    }
    
    public func orderWaypoints() {
        var newWaypoints = Array<Waypoint>()
        var waypointCount = waypoints.count
        var heighestID = 0
        for var x = 0; x < waypointCount; x++ {
            heighestID = 0
            for var i = 0; i < waypoints.count; i++ {
                if(waypoints[i].line.length > waypoints[heighestID].line.length) {
                    heighestID = i
                }
            }
            newWaypoints.append(waypoints[heighestID])
            waypoints.removeAtIndex(heighestID)
        }
        waypoints = newWaypoints
    }
    
}

