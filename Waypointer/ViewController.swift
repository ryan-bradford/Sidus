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
    
    var startFromNorth = 0.0
    var locationManager: CLLocationManager!
    var timesInitRun = 0
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
    var cameraAngle = (1.0)
    var isInForeground = false
    //These Are Kinda In Order
    var groups : Array<WaypointGroup> //Just Blank
    var manage : WaypointManager
    var groupScreen : GroupScreen
    var addButton : AddButton
    var addGroupButton : AddGroup
    var verifyButton : VerifyButton
    var addressButton : AddAddressButton
    var myMath : MyMath
    var reader : WaypointReader
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        groups = Array<WaypointGroup>()
        manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngle: cameraAngle, groups: groups, startFromNorth: startFromNorth)
        groupScreen = GroupScreen(groups: groups, manage: manage)
        addButton = AddButton(cameraAngle: cameraAngle, manager: manage)
        addGroupButton = AddGroup()
        verifyButton = VerifyButton()
        addressButton = AddAddressButton(cameraAngle: cameraAngle, manager: manage)
        myMath = MyMath(cameraAngle: cameraAngle)
        reader = WaypointReader(cameraAngle: cameraAngle, groups: groups, startFromNorth: startFromNorth, manage: manage)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        groups = Array<WaypointGroup>()
        manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngle: cameraAngle, groups: groups, startFromNorth: startFromNorth)
        groupScreen = GroupScreen(groups: groups, manage: manage)
        addButton = AddButton(cameraAngle: cameraAngle, manager: manage)
        addGroupButton = AddGroup()
        verifyButton = VerifyButton()
        addressButton = AddAddressButton(cameraAngle: cameraAngle, manager: manage)
        myMath = MyMath(cameraAngle: cameraAngle)
        reader = WaypointReader(cameraAngle: cameraAngle, groups: groups, startFromNorth: startFromNorth, manage: manage)
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewWillAppear(anim : Bool) {
        initStage1()
        startThread()
    }
    
    func startThread() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(self.shouldContinue) {
                usleep(20000)
                if(self.isInForeground && self.buttonsAreGood()) {
                    self.manage.orderWaypoints()
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
                        if(classes.shouldRemove) {
                            self.removeWaypoints()
                            self.removeScreens()
                            classes.shouldRemove = false
                        }
                    }
                }
            }
        }
    }
    
    func manageGroupScreen() {
        if(addGroupButton.showGroupScreen) {
            self.view.addSubview(self.groupScreen)
            addGroupButton.showGroupScreen = false
            self.hideAllButtons()
        }
        if(groupScreen.goAwayGroupScreen) {
            self.showAllButtons()
            self.groupScreen.removeFromSuperview()
            groupScreen.goAwayGroupScreen = false
        }
    }
    
    func updateVars() {
        self.manage.generateVars()
    }
    
    func removeWaypoints() {
        for var i = 0; i < self.manage.drawnWaypoints.count; i++ {
            self.manage.drawnWaypoints[i].removeFromSuperview()
        }
    }
    
    func updateWaypoints() {
        for var i = self.manage.drawnWaypoints.count - 1; i >= 0; i-- {
            self.manage.drawnWaypoints[i].drawRect(self.view.frame)
            self.view.addSubview(self.manage.drawnWaypoints[i])
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.location!.course
        let latitude = Double(manager.location!.coordinate.latitude)
        let longitude = Double(manager.location!.coordinate.longitude)
        let altitude = manager.location!.altitude
        let feetZ = altitude * 3.28084
        self.manage.changePersonLocation(myMath.degreesToFeet(longitude), yPos: myMath.degreesToFeet(latitude), zPos: feetZ) //To Reverse
        if(timesStarted == 0) {
            self.initStage2()
            timesStarted = 1
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        if(verifyButton.canContinue) {
            if(h2 != 0.0 && !headingSet) {
                headingSet = true
                self.startFromNorth = h2 * M_PI / 180 //To Reverse
                self.initStage3()
                //self.startFromNorth = 0.0
                let message = "We Have Detected You Are "  + Int(round(self.startFromNorth * 180 / M_PI)).description + " Degrees From North, Press OK You Agree, or Override"
                let alert = UIAlertController(title: "Waypoint Creator", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                    let text: AnyObject? = alert.textFields?[0]
                    if let textf = text as? UITextField {
                        if let number = NSNumberFormatter().numberFromString(textf.text!) {
                            self.startFromNorth = Double(number) * M_PI / 180
                        }
                    }
                    self.isInForeground = true
                    classes.cantRecal = false
                }))
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
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
            cameraAngle = Double(videoDevice.activeFormat.videoFieldOfView)
            cameraAngle *= M_PI / 180
            let videoIn : AVCaptureDeviceInput?
            do {
                videoIn = try AVCaptureDeviceInput(device: videoDevice)
                if (captureSession.canAddInput(videoIn! as AVCaptureInput)){
                    captureSession.addInput(videoIn! as AVCaptureDeviceInput)
                }
            } catch _ {
                removeAllGraphics()
                shouldContinue = false
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
                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) {
                    [weak self] (motion, error) in
                    if(self!.motionStage1Or2) {
                        self!.activeLine.setY(Int(classes.screenHeight / 2 - classes.screenHeight / 2 * cos(motion!.attitude.pitch)))
                    } else {
                        if(self!.timesStored == 0) {
                            self!.timesStored++
                            self!.startAttitude = motion!.attitude
                        } else {
                            motion!.attitude.multiplyByInverseOfAttitude(self!.startAttitude)
                            self!.manage.horAngle = motion!.attitude.roll - ((self!.cameraAngle / 2) * (classes.screenWidth / classes.screenHeight))
                            let realVertAngle = cos(motion!.attitude.roll) * motion!.attitude.pitch - sin(motion!.attitude.roll) * motion!.attitude.yaw
                            self!.manage.vertAngle = realVertAngle - self!.cameraAngle / 2
                        }
                    }
                }
            } else {
                removeAllGraphics()
                shouldContinue = false
                print("Gyro is already active")
                self.view.addSubview(cannotRun)
            }
        } else {
            removeAllGraphics()
            shouldContinue = false
            print("Gyro isn't available")
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
        classes.cantRecal = true
        self.isInForeground = false
        classes.shouldRecalibrate = false
        self.motionStage1Or2 = true
        headingSet = false
        self.timesStored = 0
        self.verifyButton = VerifyButton()
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
    
    func initStage1() {
        classes.cantRecal = true
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
            reader.readGroups()
            reInitGroupStuff()
            self.motionStage1Or2 = false
            verifyButton.removeFromSuperview()
            showAllButtons()
            timesInitRun += 1
            self.activeLine.removeFromSuperview()
            self.centerLine.removeFromSuperview()
            locationManager.stopUpdatingHeading()
        }
    }
    
    func reInitGroupStuff() {
        groups = reader.groups
        manage.groups = groups
        groupScreen = GroupScreen(groups: groups, manage: manage)
        addressButton = AddAddressButton(cameraAngle: cameraAngle, manager: manage)
        addButton = AddButton(cameraAngle: cameraAngle, manager: manage)
        reader = WaypointReader(cameraAngle: cameraAngle, groups: groups, startFromNorth: startFromNorth, manage: manage)
    }
    
    func buttonsAreGood() -> Bool {
        for var i = 0; i < groupScreen.buttons.count; i++ {
            if !groupScreen.buttons[i].shouldRedraw {
                return false
            }
        }
        return true
    }
    
    func removeScreens() {
        groupScreen.removeFromSuperview()
    }
    
    
    
}

