//
//  MyMotionManager.swift
//  Waypointer
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
    
    init(myView : ViewController, manage : WaypointManager) {
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
    
    func manageMotion(attitude : CMAttitude) {
        /*
        let insideRoll = 2*(attitude.quaternion.w*attitude.quaternion.x + attitude.quaternion.z*attitude.quaternion.y) / (attitude.quaternion.w * attitude.quaternion.w - attitude.quaternion.x * attitude.quaternion.x - attitude.quaternion.y * attitude.quaternion.y - attitude.quaternion.z * attitude.quaternion.z)
        let roll = atan(insideRoll)
        let pitch = -sin(2 * (attitude.quaternion.x * attitude.quaternion.z - attitude.quaternion.w * attitude.quaternion.y))
        let insideYaw = 2 * (attitude.quaternion.w * attitude.quaternion.z + attitude.quaternion.x * attitude.quaternion.y) / (attitude.quaternion.w * attitude.quaternion.w + attitude.quaternion.x * attitude.quaternion.x + attitude.quaternion.y * attitude.quaternion.y + attitude.quaternion.z * attitude.quaternion.z)
        let yaw = atan(insideYaw)
        print(String(yaw) + " Yaw")
        print(String(roll) + " Roll")
        print(String(pitch) + " Pitch")
        */
        attitude.multiplyByInverseOfAttitude(startAttitude)
        manage!.horAngle = attitude.roll - ((myView!.cameraAngle / 2) * (classes.screenWidth / classes.screenHeight))
        let realVertAngle = cos(attitude.roll) * attitude.pitch - sin(attitude.roll) * attitude.yaw
        manage!.vertAngle = realVertAngle - myView!.cameraAngle / 2
    }
    
}
