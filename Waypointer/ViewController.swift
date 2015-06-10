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
        let location = locationManager.location
        let startX = CGFloat(location.coordinate.latitude)
        let startY = CGFloat(location.coordinate.longitude)
        var startAngle = CGFloat(0.0)
        if let attitude = motionManager.deviceMotion?.attitude {
            startAngle = CGFloat(-attitude.pitch)
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(true) {
                usleep(100000)
                if(classes.canContinue) {
                    classes.manage.orderWaypoints()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.initApp(startX, startY: startY)
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
        classes.manage.changePersonLocation(MyMath.degreesToFeet(latitude), yPos: MyMath.degreesToFeet(longitude), zPos: feetZ) //To Reverse
    }
    
    func initApp(startX : CGFloat, startY : CGFloat) {
        if(timesInitRun == 0) {
            let location = locationManager.location
            var endX = location.coordinate.latitude
            var endY = location.coordinate.longitude
            var toCalc = Line(startingXPos: Double(startX), startingYPos: Double(startY), startingZPos: 0.0, endingXPos: Double(endX), endingYPos: Double(endY), endingZPos: 0.0)
            var angle = toCalc.getLineHorizontalAngle()
            if(!angle.isNaN) {
                //classes.startFromNorth = 0//To Reverse
                classes.startFromNorth = angle
            } else {
                classes.startFromNorth = 0
            }
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
        
        //var locValue:CLLocationCoordinate2D = manager.location.coordinate
        //var locationArray = locations as NSArray
        //var locationObj = locationArray.lastObject as! CLLocation
        //var coord = locationObj.coordinate
        self.updateLocation()
        if(timesStarted == 0) {
            self.startApp()
            timesStarted = 1
        }
    }
    
    
}

