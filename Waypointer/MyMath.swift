//
//  MyMath.swift
//  Sidus
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import Darwin

open class MyMath {
    
    
    public init() {
        
    }
    
    func findSmallestAngle(_ angle : Double, currentFOV: Double) -> Double {
        var calc = angle
        if(calc > M_PI - currentFOV) {
            calc = calc -  M_PI * 2
            return findSmallestAngle(calc, currentFOV: currentFOV)
        } else if(calc < (-currentFOV - M_PI)) {
            calc = calc + M_PI * 2
            return findSmallestAngle(calc, currentFOV: currentFOV
            )
        } else {
            return calc
        }
    }
    
    func degreesToFeet(_ angle : Double) -> Double {
        let kiloScaler = Double(10000/90)
        let kilos = angle * kiloScaler
        let feetScaler = 3280.84
        let feet = kilos * feetScaler
        return feet
    }
    
    func getMyAverage(_ nums : Array<Double>, placeToRoundTo : Double) -> Double {
        var heighestCount = 0.0
        var heighestID = 0.0
        var currentCount = 0.0
        var currentID = 0.0
        var currentID1 = 0.0
        for i in 0 ..< nums.count {
            currentCount = 0
            currentID = round(nums[i] / placeToRoundTo) * placeToRoundTo
            for x in 0 ..< nums.count {
                currentID1 = round(nums[x] / placeToRoundTo) * placeToRoundTo
                if(currentID == currentID1) {
                    currentCount += 1
                }
            }
            if(currentCount > heighestCount) {
                heighestCount = currentCount
                heighestID = currentID
            }
        }
        var total = 0.0
        for i in 0 ..< nums.count {
            currentID = round(nums[i] / placeToRoundTo) * placeToRoundTo
            if( currentID == heighestID) {
                total += nums[i]
            }
        }
        return total / heighestCount;
    }
    
    
}
