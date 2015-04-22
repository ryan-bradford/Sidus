//
//  ViewController.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import UIKit
import SceneKit
import CoreText
import AVFoundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var timesInitRun = 0
    var addButton = AddButton()
    var addGroupButton = AddGroup()
    var verifyButton = VerifyButton()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(anim : Bool) {
        classes.manage.addWaypoint(0, yPos: 300, zPos: 0, red: 0, green: 0, blue: 0, name: "Hello")
        classes.manage.addWaypoint(0, yPos: 1, zPos: 0, red: 0, green: 0, blue: 0, name: "Upper")
        initLocationManager()
        initCameraFeed()
        sleep(2)
        self.view.addSubview(verifyButton)
        let location = locationManager.location
        let startX = CGFloat(location.coordinate.latitude)
        let startY = CGFloat(location.coordinate.longitude)
        var startAngle = CGFloat(0.0)
        if let attitude = classes.motionManager.deviceMotion?.attitude {
            startAngle = CGFloat(-attitude.pitch)
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(true) {
                usleep(100000)
                if(classes.canContinue) {
                    self.updateLocation()
                    classes.manage.orderWaypoints()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.initApp(startX, startY: startY, startAngle: startAngle)
                        for var i = 0; i < classes.manage.drawnWaypoints.count; i++ {
                            classes.manage.drawnWaypoints[i].drawRect(self.view.frame)
                            if(!classes.manage.drawnWaypoints[i].added) {
                                self.view.addSubview(classes.manage.drawnWaypoints[i])
                                classes.manage.drawnWaypoints[i].added = true
                            }
                        }
                        classes.startFromNorth += M_PI/1000
                    }
                }
            }
        }
        
        let priority1 = DISPATCH_QUEUE_PRIORITY_DEFAULT
    }
    
    func updateLocation() {
        let location = locationManager.location
        var latitude = Double(location.coordinate.latitude)
        var longitude = Double(location.coordinate.longitude)
        var altitude = location.altitude
        var feetZ = altitude * 3.28084
        //classes.manage.changePersonLocation(MyMath.degreesToFeet(latitude), yPos: MyMath.degreesToFeet(longitude), zPos: feetZ)
    }
    
    func initApp(startX : CGFloat, startY : CGFloat, startAngle : CGFloat) {
        if(timesInitRun == 0) {
            let location = locationManager.location
            var endX = location.coordinate.latitude
            var endY = location.coordinate.longitude
            var endAngle = CGFloat(0.0)
            if let attitude = classes.motionManager.deviceMotion?.attitude {
                endAngle = CGFloat(-attitude.pitch)
            }
            var toCalc = Line(startingXPos: Double(startX), startingYPos: Double(startY), startingZPos: 0.0, endingXPos: Double(endX), endingYPos: Double(endY), endingZPos: 0.0)
            var angle = MyMath.getLineHorizontalAngle(toCalc)
            if(!angle.isNaN) {
                classes.startFromNorth = angle
            } else {
                classes.startFromNorth = 0
            }
            usleep(200000)
            verifyButton.removeFromSuperview()
            self.editAddButton(true)
            self.editAddGroup(true)
            timesInitRun += 1
        }
        
    }
    
    func editAddButton(toAddOrRemove : Bool) { //True is add, false is remove
        if(toAddOrRemove) {
            self.view.addSubview(addButton)
        } else {
            addButton.removeFromSuperview()
        }
    }
    
    func editAddGroup(toAddOrRemove : Bool) { //True is add, false is remove
        if(toAddOrRemove) {
            self.view.addSubview(addGroupButton)
        } else {
            addGroupButton.removeFromSuperview()
        }
    }
    
    func initCameraFeed() {
        let captureSession = AVCaptureSession()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        if let videoDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            var err: NSError? = nil
            classes.cameraAngle = Double(videoDevice.activeFormat.videoFieldOfView)
            if let videoIn : AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &err) as? AVCaptureDeviceInput {
                if(err == nil){
                    if (captureSession.canAddInput(videoIn as AVCaptureInput)){
                        captureSession.addInput(videoIn as AVCaptureDeviceInput)
                    }
                    else {
                    }
                }
                else {
                }
            }
            else {
            }
        }
        captureSession.startRunning()
        previewLayer.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
    }
    
    
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) { // Updated to current array syntax [AnyObject] rather than AnyObject[]
    }
    
    
}

