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
    var cannotRun = CannotRunScreen()
    var activeLine = CenterLine()
    var centerLine = CenterLine()
    var motionStage1Or2 = true //True is 1, false is 2
    var tint = GreyTintScreen()
    var shouldContinue = true
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func viewWillAppear(anim : Bool) {
        initStage1()
        startThread()
    }
    
    func startThread() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(self.shouldContinue) {
                usleep(60000)
                if(classes.isInForeground) {
                    classes.manage.orderWaypoints()
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(self.shouldContinue) {
                usleep(20000)
                if(classes.isInForeground) {
                    self.updateVars()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.manageGroupScreen()
                        self.removeWaypoints()
                        self.updateWaypoints()
                        if(classes.shouldRecalibrate) {
                            self.recalibrate()
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        if(classes.shouldRecalibrate) {
                            self.recalibrate()
                        }
                    }
                }
            }
        }
    }
    
    func manageGroupScreen() {
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
    }
    
    func updateVars() {
        for var i = 0; i < classes.manage.drawnWaypoints.count; i++ {
            classes.manage.drawnWaypoints[i].generateVars()
        }
    }
    
    func removeWaypoints() {
        for var i = 0; i < classes.manage.drawnWaypoints.count; i++ {
            classes.manage.drawnWaypoints[i].removeFromSuperview()
        }
    }
    
    func updateWaypoints() {
        for var i = classes.manage.drawnWaypoints.count - 1; i >= 0; i-- {
            classes.manage.drawnWaypoints[i].drawRect(self.view.frame)
            self.view.addSubview(classes.manage.drawnWaypoints[i])
        }
    }
    
    func initStage1() {
        classes.inInit = true
        initCameraFeed()
        if(shouldContinue) {
            self.view.addSubview(tint)
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.headingFilter = kCLHeadingFilterNone
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func initStage2()  {
        if(shouldContinue) {
            tint.removeFromSuperview()
            initMotionManager()
        }
        if(shouldContinue) {
            self.centerLine.setY(Int(classes.screenHeight / 2))
            self.view.addSubview(activeLine)
            self.view.addSubview(centerLine)
            sleep(2)
            self.view.addSubview(verifyButton)
        }
    }
    
    func initStage3() {
        if(shouldContinue) {
            self.motionStage1Or2 = false
            verifyButton.removeFromSuperview()
            showAllButtons()
            timesInitRun += 1
            self.activeLine.removeFromSuperview()
            self.centerLine.removeFromSuperview()
            locationManager.stopUpdatingHeading()
            classes.inInit = false
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.location.course
        var latitude = Double(manager.location.coordinate.latitude)
        var longitude = Double(manager.location.coordinate.longitude)
        var altitude = manager.location.altitude
        var feetZ = altitude * 3.28084
        classes.manage.changePersonLocation(MyMath.degreesToFeet(longitude), yPos: MyMath.degreesToFeet(latitude), zPos: feetZ) //To Reverse
        if(timesStarted == 0) {
            self.initStage2()
            timesStarted = 1
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        if(classes.canContinue) {
            if(h2 != 0.0 && !headingSet) {
                headingSet = true
                classes.startFromNorth = h2 * M_PI / 180 //To Reverse
                self.initStage3()
                //classes.startFromNorth = 0.0
                var message = "We Have Detected You Are "  + Int(round(classes.startFromNorth * 180 / M_PI)).description + " Degrees From North, Press OK You Agree, or Override"
                var alert = UIAlertController(title: "Waypoint Creator", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
                    let text: AnyObject? = alert.textFields?[0]
                    if let textf = text as? UITextField {
                        if let number = NSNumberFormatter().numberFromString(textf.text) {
                            classes.startFromNorth = Double(number) * M_PI / 180
                        }
                    }
                    classes.isInForeground = true
                }))
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Name"
                    textField.secureTextEntry = false
                })
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            if(h2 == -1) {
                shouldContinue = false
                removeAllGraphics()
                self.view.addSubview(cannotRun)
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
                    } else {
                        
                    }
                } else {
                    removeAllGraphics()
                    shouldContinue = false
                    self.view.addSubview(cannotRun)
                }
            } else {
                shouldContinue = false
                removeAllGraphics()
                self.view.addSubview(cannotRun)
            }
        }
        captureSession.startRunning()
        previewLayer.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
    }
    
    func initMotionManager() {
        if motionManager.gyroAvailable {
            if motionManager.gyroActive == false {
                motionManager.deviceMotionUpdateInterval = 0.02;
                motionManager.startDeviceMotionUpdates()
                motionManager.gyroUpdateInterval = 0.02
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()) {
                    [weak self] (motion: CMDeviceMotion!, error: NSError!) in
                    if(self!.motionStage1Or2) {
                        self!.activeLine.setY(Int(classes.screenHeight / 2 - classes.screenHeight / 2 * cos(motion.attitude.pitch)))
                    } else {
                        if(self!.timesStored == 0) {
                            self!.timesStored++
                            self!.startAttitude = motion.attitude
                        } else {
                            motion.attitude.multiplyByInverseOfAttitude(self!.startAttitude)
                            classes.manage.horAngle = motion.attitude.roll - ((classes.cameraAngle / 2) * (classes.screenWidth / classes.screenHeight))
                            var realVertAngle = cos(motion.attitude.roll) * motion.attitude.pitch - sin(motion.attitude.roll) * motion.attitude.yaw
                            classes.manage.vertAngle = realVertAngle - classes.cameraAngle / 2
                        }
                    }
                }
            } else {
                removeAllGraphics()
                shouldContinue = false
                println("Gyro is already active")
                self.view.addSubview(cannotRun)
            }
        } else {
            removeAllGraphics()
            shouldContinue = false
            println("Gyro isn't available")
            self.view.addSubview(cannotRun)
        }
    }
    
    func recalibrate() {
        self.resetVars()
        locationManager.startUpdatingHeading()
        self.centerLine.setY(Int(classes.screenHeight / 2))
        self.view.addSubview(activeLine)
        activeLine.drawRect(CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        self.view.addSubview(centerLine)
        centerLine.drawRect(CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        self.view.addSubview(verifyButton)
        verifyButton.drawRect(CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
    }
    
    func resetVars() {
        classes.inInit = true
        classes.isInForeground = false
        classes.shouldRecalibrate = false
        self.motionStage1Or2 = true
        headingSet = false
        self.timesStored = 0
        self.verifyButton = VerifyButton()
        classes.canContinue = false
        addGroupButton.removeFromSuperview()
        addressButton.removeFromSuperview()
        addButton.removeFromSuperview()
    }
    
    func removeAllGraphics() {
        for v in self.view.subviews {
            if(!(v is AVCaptureVideoPreviewLayer)) {
                v.removeFromSuperview()
            }
        }
    }
    
}

