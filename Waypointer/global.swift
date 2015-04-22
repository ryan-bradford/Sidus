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
    static public var manage = WaypointManager(x: 0, y: 0, z: 0, personLeftRightAngle: 0, personUpDownAngle: 0)
    static public var screenWidth = Double(UIScreen.mainScreen().bounds.width)
    static public var screenHeight = Double(UIScreen.mainScreen().bounds.height)
    static public var cameraAngle = ( (M_PI) / 3 )
    static public var waypointTransparency = ( 255.0 )
    static public var motionManager = CMMotionManager()
    static public var addButton = AddButton()
    static public var addGroupButton = AddGroup()
    static public var verifyButton = VerifyButton()
    static public var canContinue = false
    static public var timesInitRun = 0
    static public var startFromNorth = 0.0
    static public var groups = Array<WaypointGroup>()
    
}