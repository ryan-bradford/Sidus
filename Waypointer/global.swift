//
//  global.swift
//  waypointr
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
    
    static public var screenWidth = Double(UIScreen.main.bounds.width) //Final
    static public var screenHeight = Double(UIScreen.main.bounds.height) //Final
    static public var screenDiameter = 0.0
    //AppDelegate to ViewController
    
    static public var isInForeground = false
    static public var cantRecal = true
    
    
    
    //Preferences

    static public var waypointTransparency = ( 255.0 ) //Final
    static public var numWaypoints = 20 //Final
    static public var buttonStart = 4 //Final //2 * Start + Width + 2 * Length = 40
    static public var buttonWidth = 6 //Final
    static public var buttonLength = 13 //Final
    static public var buttonOutlineWidth = 40 //Final
    static public var buttonGap = 10 //Final
    static public var timeInbetweenResets = 5.0 //Final //In Millis
    static public var acceptableRecalRange = 0.1

    static public var addButtonDimension = CGFloat(40.0) //Final
    
    static public var groupsPerCollum = CGFloat(15.0) //Final
    static public var groupsPerRow = CGFloat(3.0) //Final
}
