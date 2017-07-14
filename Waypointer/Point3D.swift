//
//  Point3D.swift
//  waypointr
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation

open class Point3D {
    
    open var xPos : Double
    open var yPos : Double
    open var zPos : Double
    
    init(xPos1 : Double, yPos1 : Double, zPos1 : Double) {
        self.xPos = xPos1
        self.yPos = yPos1
        self.zPos = zPos1
    }
    
    func getXPos() -> Double {
        return xPos
    }
    
    func getYPos() -> Double {
        return yPos
    }
    
    func getZPos() -> Double {
        return zPos
    }
    
}

