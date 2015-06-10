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
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var timesInitRun = 0
    var addButton = AddButton()
    var addGroupButton = AddGroup()
    var verifyButton = VerifyButton()
    var addressButton = AddAddressButton()
    var timesStarted = 0
    var timesStored = 0
    var startFromNorthSet = false
    var startAttitude = CMAttitude()
    var queue = NSOperationQueue()
    var motionManager = CMMotionManager()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func viewWillAppear(anim : Bool) {
        initLocationManager()
    }
    
    func startApp()  {
        initCameraFeed()
        sleep(2)
        self.view.addSubview(verifyButton)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(true) {
                usleep(100000)
                if(classes.canContinue) {
                    classes.manage.orderWaypoints()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.initApp()
                        for var i = 0; i < classes.manage.drawnWaypoints.count; i++ {
                            classes.manage.drawnWaypoints[i].drawRect(self.view.frame)
                            if(!classes.manage.drawnWaypoints[i].added) {
                                self.view.addSubview(classes.manage.drawnWaypoints[i])
                                classes.manage.drawnWaypoints[i].added = true
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func initMotionManager() {
        
        if motionManager.gyroAvailable{
            
            if motionManager.gyroActive == false{
                motionManager.deviceMotionUpdateInterval = 0.02;
                motionManager.startDeviceMotionUpdates()
                
                motionManager.gyroUpdateInterval = 0.02
                
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()) {
                    [weak self] (motion: CMDeviceMotion!, error: NSError!) in
                    if(self!.timesStored == 0) {
                        self!.timesStored++
                        self!.startAttitude = motion.attitude
                    } else {
                        motion.attitude.multiplyByInverseOfAttitude(self!.startAttitude)
                        classes.manage.pitch = motion.attitude.roll - ((classes.cameraAngle / 2) * (classes.screenWidth / classes.screenHeight))
                        println(motion.attitude.pitch - classes.cameraAngle / 2)
                        classes.manage.yaw = motion.attitude.pitch - classes.cameraAngle / 2
                    }
                }
            } else {
                println("Gyro is already active")
            }
            
        } else {
            println("Gyro isn't available")
        }
    }
    
    func updateLocation() {
        let location = locationManager.location
        var latitude = Double(location.coordinate.latitude)
        var longitude = Double(location.coordinate.longitude)
        var altitude = location.altitude
        var feetZ = altitude * 3.28084
        //classes.manage.changePersonLocation(MyMath.degreesToFeet(latitude), yPos: MyMath.degreesToFeet(longitude), zPos: feetZ) //To Reverse
    }
    
    func initApp() {
        if(timesInitRun == 0) {
            locationManager.startUpdatingHeading()
            usleep(200000)
            verifyButton.removeFromSuperview()
            self.editAddButton(true)
            self.editAddGroup(true)
            self.editAddAddressButton(true)
            timesInitRun += 1
            initMotionManager()
        }
        
    }
    
    func editAddButton(toAddOrRemove : Bool) { //True is add, false is remove
        if(toAddOrRemove) {
            self.view.addSubview(addButton)
        } else {
            addButton.removeFromSuperview()
        }
    }
    
    func editAddAddressButton(toAddOrRemove : Bool) { //True is add, false is remove
        if(toAddOrRemove) {
            self.view.addSubview(addressButton)
        } else {
            addressButton.removeFromSuperview()
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
            classes.cameraAngle *= M_PI / 180
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
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.updateLocation()
        if(timesStarted == 0) {
            self.startApp()
            timesStarted = 1
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        if(h2 != 0.0 && !startFromNorthSet) {
            startFromNorthSet = true
            classes.startFromNorth = h2
            //classes.startFromNorth = 0.0//To Reverse
            println(classes.startFromNorth)
        }
    }
    
    
}

