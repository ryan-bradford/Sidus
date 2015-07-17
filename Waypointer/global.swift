//
//  global.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import CoreLocation

public struct classes {
    
    //System Derived
    
    static public var manage = WaypointManager(x: 0, y: 0, z: 0, personLeftRightAngle: 0, personUpDownAngle: 0) //Global
    static public var screenWidth = Double(UIScreen.mainScreen().bounds.width) //Final
    static public var screenHeight = Double(UIScreen.mainScreen().bounds.height) //Final
    static public var cameraAngle = (0.0) //Global
    static public var canContinue = false //Global
    static public var startFromNorth = 0.0 //Final
    static public var groups = Array<WaypointGroup>() //Final
    static public var groupScreen = GroupScreen() //Global
    static public var goAwayGroupScreen = false //Global
    static public var showGroupScreen = false //Global
    static public var shouldRecalibrate = false
    
    //Preferences

    static public var waypointTransparency = ( 255.0 ) //Final
    static public var numWaypoints = 20 //Final
    static public var buttonStart = 4 //Final //2 * Start + Width + 2 * Length = 40
    static public var buttonWidth = 6 //Final
    static public var buttonLength = 13 //Final
    static public var buttonOutlineWidth = 40 //Final
    static public var buttonGap = 10 //Final

    
}