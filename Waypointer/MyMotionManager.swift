//
//  MyMotionManager.swift
//  waypointr
//
//  Created by Ryan on 1/23/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import CoreMotion

open class MyMotionManager {
    
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
        if motionManager!.isGyroAvailable {
            if motionManager!.isGyroActive == false {
                motionManager!.deviceMotionUpdateInterval = 0.02;
                motionManager!.startDeviceMotionUpdates()
                motionManager!.gyroUpdateInterval = 0.02
                self.setMotionManagerThread(motionManager!)
            } else {
                myView.removeAllGraphics()
                myView.isAbleToRun = false
                myView.cannotRun = CannotRunScreen(message: "No gyroscope available.")
                myView.view.addSubview(myView.cannotRun)
            }
        } else {
            myView.removeAllGraphics()
            myView.isAbleToRun = false
            myView.cannotRun = CannotRunScreen(message: "No gyroscope available.")
            myView.view.addSubview(myView.cannotRun)
        }
    }
    
    init() {
        myView = nil
        manage = nil
        motionManager = nil
    }
    
    func setMotionManagerThread(_ motionManager : CMMotionManager) {
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {
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
    
    func manageMotion(_ attitude : CMAttitude) {
        attitude.multiply(byInverseOf: startAttitude)
        let realVertAngle = cos(attitude.roll) * attitude.pitch - sin(attitude.roll) * attitude.yaw
        manage!.vertAngle = realVertAngle - vertSubtract!
    }
    
}
