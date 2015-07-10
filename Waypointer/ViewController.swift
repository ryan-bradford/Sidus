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
import CoreLocation //Longitude is X, Latitude is Y

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var timesInitRun = 0
    var addButton = AddButton()
    var addGroupButton = AddGroup()
    var verifyButton = VerifyButton()
    var addressButton = AddAddressButton()
    var timesStarted = 0
    var timesStored = 0
    var startAttitude = CMAttitude()
    var queue = NSOperationQueue()
    var motionManager = CMMotionManager()
    var headingSet = false
    var headingCounter = 0
    
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
                usleep(20000)
                if(classes.canContinue) {
                    classes.manage.orderWaypoints()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.initApp()
                        if(classes.showGroupScreen) {
                            self.view.addSubview(classes.groupScreen)
                            classes.showGroupScreen = false
                            self.hideAllButtons()
                        }
                        if(classes.goAwayGroupScreen) {
                            self.showAllButtons()
                            classes.groupScreen.removeFromSuperview()
                            classes.goAwayGroupScreen = false
                        }
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
                        classes.manage.horAngle = motion.attitude.roll - ((classes.cameraAngle / 2) * (classes.screenWidth / classes.screenHeight))
                        classes.manage.vertAngle = motion.attitude.pitch - classes.cameraAngle / 2
                        var realVertAngle = cos(motion.attitude.roll) * motion.attitude.pitch - sin(motion.attitude.roll) * motion.attitude.yaw
                        classes.manage.vertAngle = realVertAngle - classes.cameraAngle / 2
                    }
                }
            } else {
                println("Gyro is already active")
            }
            
        } else {
            println("Gyro isn't available")
        }
    }
    
    func initApp() {
        if(timesInitRun == 0) {
            locationManager.startUpdatingHeading()
            if(headingSet) {
                verifyButton.removeFromSuperview()
                showAllButtons()
                timesInitRun += 1
                initMotionManager()
            }
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.location.course
        var latitude = Double(manager.location.coordinate.latitude)
        var longitude = Double(manager.location.coordinate.longitude)
        var altitude = manager.location.altitude
        var feetZ = altitude * 3.28084
        //classes.manage.changePersonLocation(MyMath.degreesToFeet(longitude), yPos: MyMath.degreesToFeet(latitude), zPos: feetZ) //To Reverse
        if(timesStarted == 0) {
            self.startApp()
            timesStarted = 1
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        headingCounter++
        if(headingCounter > 9) {
            if(h2 != 0.0 && !headingSet) {
                headingSet = true
                //classes.startFromNorth = h2 * M_PI / 180 //To Reverse
                classes.startFromNorth = 0.0
            }
        }
    }
    
    
    func showAllButtons() {
        self.view.addSubview(addButton)
        self.view.addSubview(addressButton)
        self.view.addSubview(addGroupButton)
    }
    
    func hideAllButtons() {
        addButton.removeFromSuperview()
        addressButton.removeFromSuperview()
        addGroupButton.removeFromSuperview()
    }
    
    
}

