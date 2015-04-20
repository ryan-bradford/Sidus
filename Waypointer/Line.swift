//
//  Line.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation

public class Line {
    
    var length : Double
    var start : Point3D
    var end : Point3D
    
    /*
    * X Distance = cos(yRadians) * distancePerItteration Y Distance =
    * sin(yRadians) * distancePerItteration Z Distance = cos(xRadians) *
    * distancePerItteration
    */
    
    init(startingXPos : Double, startingYPos : Double, startingZPos : Double,
        endingXPos : Double, endingYPos : Double, endingZPos : Double) {
            self.start = Point3D(xPos1: startingXPos, yPos1: startingYPos, zPos1: startingZPos)
            self.end = Point3D(xPos1: endingXPos, yPos1: endingYPos, zPos1: endingZPos)
            self.length = sqrt(pow(end.xPos - start.xPos, 2) + pow(end.yPos - start.yPos, 2) + pow(end.zPos - start.zPos, 2))
    }
    
    func getXLength() ->  Double {
        return end.getXPos() - start.getXPos()
    }
    
    func getYLength() ->  Double {
        return end.getYPos() - start.getYPos()
    }
    
    func getZLength() ->  Double {
        return end.getZPos() - start.getZPos()
    }
    
}

