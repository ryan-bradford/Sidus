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
    var personLeftRightRotation = 0.0  // <--> //Left is Positive, Right is Negative
    var personUpDownRotation = 0.0  //Up is Positive, Down is Negative
    
    init(x : Double, y : Double, z : Double, personLeftRightAngle : Double, personUpDownAngle : Double) {
        allWaypoints = Array<Waypoint>()
        drawnWaypoints = Array<Waypoint>()
        personX = x
        personY = y
        personZ = z
        personLeftRightRotation = personLeftRightAngle
        personUpDownRotation = personUpDownAngle
    }
    
    public func addWaypoint(xPos : Double, yPos : Double, zPos : Double, red : Int, green : Int, blue : Int, name : String) {
        allWaypoints.append(Waypoint(xPos: xPos, yPos: yPos, zPos: zPos, red: red, green: green, blue: blue, name : name))
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
        var newWaypoints = Array<Waypoint>()
        var heighestID = 0
        var numToAdd = classes.numWaypoints
        if(allWaypoints.count < classes.numWaypoints) {
            numToAdd = allWaypoints.count
        }
        for var x = 0; x < numToAdd; x++ {
            heighestID = 0
            for var i = 0; i < allWaypoints.count; i++ {
                if(allWaypoints[i].line.length > allWaypoints[heighestID].line.length) {
                    heighestID = i
                }
            }
            newWaypoints.append(allWaypoints[heighestID])
            allWaypoints.removeAtIndex(heighestID)
        }
        drawnWaypoints = newWaypoints
        allWaypoints = start
    }
    
}

