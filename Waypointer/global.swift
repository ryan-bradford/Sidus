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
    
    static public var screenWidth = Double(UIScreen.mainScreen().bounds.width) //Final
    static public var screenHeight = Double(UIScreen.mainScreen().bounds.height) //Final
   
    //AppDelegate to ViewController
    
    static public var shouldRecalibrate = false
    static public var shouldRemove = false
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

    
}