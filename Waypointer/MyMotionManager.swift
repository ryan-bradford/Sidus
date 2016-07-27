//
//  MyMotionManager.swift
//  Sidus
//
//  Created by Ryan on 1/23/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import CoreMotion

public class MyMotionManager {
    
    var myView : ViewController?
    var manage : WaypointManager?
    var motionManager : CMMotionManager?
    var motionStage1Or2 = true //True is 1, false is 2
    var startAttitude = CMAttitude() //The gyros base image
    var gyroBaseImageSet = false
    var lastPitch = 0.0
    var vertSubtract: Double?
    
    init(myView : ViewController, manage : WaypointManager) {
        vertSubtract = (myView.cameraAngleY / 2)
        motionManager = CMMotionManager()
        self.myView = myView
        self.manage = manage
        if motionManager!.gyroAvailable {
            if motionManager!.gyroActive == false {
                motionManager!.deviceMotionUpdateInterval = 0.02;
                motionManager!.startDeviceMotionUpdates()
                motionManager!.gyroUpdateInterval = 0.02
                self.setMotionManagerThread(motionManager!)
            } else {
                myView.removeAllGraphics()
                myView.isAbleToRun = false
                print("Gyro is already active")
                myView.view.addSubview(myView.cannotRun)
            }
        } else {
            myView.removeAllGraphics()
            myView.isAbleToRun = false
            print("Gyro isn't available")
            myView.view.addSubview(myView.cannotRun)
        }
    }
    
    init() {
        myView = nil
        manage = nil
        motionManager = nil
    }
    
    func setMotionManagerThread(motionManager : CMMotionManager) {
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) {
            [weak self] (motion, error) in
            self!.lastPitch = motion!.attitude.pitch
            if(self!.motionStage1Or2) {
                self!.myView!.activeLine.setY(Int(classes.screenHeight / 2 - classes.screenHeight / 2 * cos(motion!.attitude.pitch)))
            } else {
                
                if(!self!.gyroBaseImageSet) {
                    self!.gyroBaseImageSet = true
                    self!.startAttitude = motion!.attitude
                } else {
                    self!.manageMotion(motion!.attitude)
                }
            }
        }
    }
    
    func isDeviceVert() -> Bool {
        let cosVal = cos(lastPitch)
        if(cosVal < 0.03 && cosVal > -0.03) {
            return true
        }
        return false
    }
    
    func manageMotion(attitude : CMAttitude) {
        attitude.multiplyByInverseOfAttitude(startAttitude)
        let realVertAngle = cos(attitude.roll) * attitude.pitch - sin(attitude.roll) * attitude.yaw
        manage!.vertAngle = realVertAngle - vertSubtract!
    }
    
}
