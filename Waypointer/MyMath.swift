//
//  MyMath.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import Darwin

public class MyMath {
    
    class func findSmallestAngle(angle : Double) -> Double {
        var calc = angle
        if(calc > M_PI + classes.cameraAngle) {
            calc = calc -  M_PI * 2
            return findSmallestAngle(calc)
        } else if(calc < (-classes.cameraAngle - M_PI)) {
            calc = calc + M_PI * 2
            return findSmallestAngle(calc)
        } else {
            return calc
        }
    }
    
    class func degreesToFeet(angle : Double) -> Double {
        var kiloScaler = Double(10000/90)
        var kilos = angle * kiloScaler
        var feetScaler = 3280.84
        var feet = kilos * feetScaler
        return feet
    }
    
}
