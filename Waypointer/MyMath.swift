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
        if(yLength < 0) {
            return -90
        } else if(yLength == 0) {
            return 0.0
        }
        newAngle = atan(abs(xLength) / yLength)
        if(xLength > 0) {
            return newAngle
        } else {
            return -newAngle
        }
        
    }
    
    class func getLineVerticalAngle(l1 : Line) -> Double {
        var newAngle = 0.0
        var hypotenuse = sqrt(pow(l1.getXLength(), 2) + pow(l1.getYLength(), 2))
        var length = l1.length
        if(l1.getYLength() < 0) {
            return -90
        }
        newAngle = acos(hypotenuse / length)
        return newAngle
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
    
}
