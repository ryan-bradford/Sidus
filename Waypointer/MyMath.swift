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
    
    class func getLineHorizontalAngle(l1 : Line) -> Double {
        var newAngle = 0.0
        var xLength = l1.getXLength()
        var yLength = l1.getYLength()
        newAngle = atan(xLength / yLength)
        if(xLength < 0 && yLength < 0) {
            return M_PI + newAngle
        } else if(xLength < 0) {
            return M_PI * 3 / 2 - newAngle
        } else if(yLength < 0) {
            return M_PI - newAngle
        } else {
            return newAngle
        }
    }
    
    class func getLineVerticalAngle(l1 : Line) -> Double {
        var newAngle = atan(l1.getZLength() / l1.getYLength())
        if(l1.getYLength() < 0 && l1.getZLength() < 0) {
            return M_PI + newAngle
        } else if(l1.getYLength() < 0) {
            return M_PI  - newAngle
        } else if(l1.getZLength() < 0) {
            return M_PI * 2 - newAngle
        } else {
            return newAngle
        }
    }
    
    class func findSmallestAngle(angle : Double) -> Double {
        var calc = angle
        if(calc > M_PI * 2 - classes.cameraAngle) {
            calc = calc -  M_PI * 2
            return findSmallestAngle(calc)
        } else if(calc < -classes.cameraAngle) {
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
