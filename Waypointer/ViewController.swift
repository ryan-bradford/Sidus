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
    
    var startFromNorth = -1.0 //The heading of the person
    var locationManager: CLLocationManager! //The thing that manages the persons locaion
    var timesLocationRecorded = 0 //Init stage 2 will only run when this is 0
    var gyroBaseImageSet = false //The gyro needs to set a base image once
    var startAttitude = CMAttitude() //The gyros base image
    var motionManager = CMMotionManager() //The gyroscope
    var cannotRun = CannotRunScreen() //The screen that is displayed if the app cannot run
    var activeLine = CenterLine() //The line that moves in initStage1
    var centerLine = CenterLine() //The line that stays in initStage1
    var motionStage1Or2 = true //True is 1, false is 2
    var tint = GreyTintScreen() //The grey tint that is displayed in initStage1
    var isAbleToRun = true //Set to false if the phone is too old or does not allocate the proper permissions
    var cameraAngle = (1.0) //The FOV of the camera
    var initIsFinished = false //Set to true when the heading is set
    var lastTimeInAppReset = CACurrentMediaTime()
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
            while(self.isAbleToRun) {
                usleep(20000)
                if(classes.isInForeground && self.initIsFinished && self.buttonsAreGood()) {
                    self.manage.orderWaypoints()
                    self.updateVars()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.manageGroupScreen()
                        self.removeWaypoints()
                        self.updateWaypoints()
                        if(classes.shouldRecalibrate) {
                            self.fullRecalibrate()
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        if(classes.shouldRecalibrate) {
                            self.fullRecalibrate()
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
    //Periodic Processing ->
    
    func updateVars() {
        self.manage.generateVars()
    }
    
    func buttonsAreGood() -> Bool {
        for var i = 0; i < groupScreen.buttons.count; i++ {
            if !groupScreen.buttons[i].shouldRedraw {
                return false
            }
        }
        return true
    }
    
    //<- Periodic Processing
    
    //Periodic Graphics ->
    
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
    
    
    func updateWaypoints() {
        for var i = self.manage.drawnWaypoints.count - 1; i >= 0; i-- {
            self.manage.drawnWaypoints[i].drawRect(self.view.frame)
            self.view.addSubview(self.manage.drawnWaypoints[i])
        }
    }
    
    //<- Periodic Graphics
    
    func removeWaypoints() {
        for var i = 0; i < self.manage.drawnWaypoints.count; i++ {
            self.manage.drawnWaypoints[i].removeFromSuperview()
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
    
    func removeAllGraphics() {
        for v in self.view.subviews {
            v.removeFromSuperview()
        }
    }
    
    //Init Stages ->
    
    func initStage1() {
        classes.cantRecal = true
        initCameraFeed()
        if(isAbleToRun) {
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
        if(isAbleToRun) {
            tint.removeFromSuperview()
            initMotionManager()
        }
        if(isAbleToRun) {
            self.centerLine.setY(Int(classes.screenHeight / 2))
            self.view.addSubview(activeLine)
            self.view.addSubview(centerLine)
            sleep(2)
            self.view.addSubview(verifyButton)
        }
    }
    
    func initStage3() {
        if(isAbleToRun) {
            reader.readGroups()
            reInitGroups()
            self.motionStage1Or2 = false
            verifyButton.removeFromSuperview()
            showAllButtons()
            self.activeLine.removeFromSuperview()
            self.centerLine.removeFromSuperview()
            locationManager.stopUpdatingHeading()
            
        }
    }
    
    //<- Init Stages
    
    //Device Parts Init ->
    
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
                isAbleToRun = false
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
                self.setMotionManagerThread(motionManager)
            } else {
                removeAllGraphics()
                isAbleToRun = false
                print("Gyro is already active")
                self.view.addSubview(cannotRun)
            }
        } else {
            removeAllGraphics()
            isAbleToRun = false
            print("Gyro isn't available")
            self.view.addSubview(cannotRun)
        }
    }
    
    //<- Device Parts Init
    
    //Device Parts Update Threads ->
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.location!.course
        let latitude = Double(manager.location!.coordinate.latitude)
        let longitude = Double(manager.location!.coordinate.longitude)
        let altitude = manager.location!.altitude
        let feetZ = altitude * 3.28084
        self.manage.changePersonLocation(myMath.degreesToFeet(longitude), yPos: myMath.degreesToFeet(latitude), zPos: feetZ) //To Reverse
        if(timesLocationRecorded == 0) {
            self.initStage2()
        }
        timesLocationRecorded++
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        if(verifyButton.canContinue) {
            if(h2 == -1) {
                isAbleToRun = false
                removeAllGraphics()
                self.view.addSubview(cannotRun)
            } else if(self.startFromNorth == -1.0) {
                self.startFromNorth = h2 * M_PI / 180 //To Reverse
                self.manage.startFromNorth = self.startFromNorth
                self.reader.manage = self.manage
                self.manage.updateStartFromNorth()
                if !classes.isInForeground {
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
                        self.initIsFinished = true
                        classes.isInForeground = true
                        classes.cantRecal = false
                        self.lastTimeInAppReset = CACurrentMediaTime()
                    }))
                    alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                        textField.placeholder = "Name"
                        textField.secureTextEntry = false
                    })
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setMotionManagerThread(motionManager : CMMotionManager) {
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!) {
            [weak self] (motion, error) in
            if(self!.motionStage1Or2) {
                self!.activeLine.setY(Int(classes.screenHeight / 2 - classes.screenHeight / 2 * cos(motion!.attitude.pitch)))
            } else {
                if(!self!.gyroBaseImageSet) {
                    self!.gyroBaseImageSet = true
                    self!.startAttitude = motion!.attitude
                } else {
                    motion!.attitude.multiplyByInverseOfAttitude(self!.startAttitude)
                    self!.manage.horAngle = motion!.attitude.roll - ((self!.cameraAngle / 2) * (classes.screenWidth / classes.screenHeight))
                    let realVertAngle = cos(motion!.attitude.roll) * motion!.attitude.pitch - sin(motion!.attitude.roll) * motion!.attitude.yaw
                    self!.manage.vertAngle = realVertAngle - self!.cameraAngle / 2
                }
            }
        }
    }
    
    //<-- Device Parts Update Threads
    
    
    //Recalibrate Stuff ->
    
    func fullRecalibrate() {
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
    
    func inAppRecalibrate() {
        classes.cantRecal = true
        self.initIsFinished = false
        self.startFromNorth = -1.0
        self.gyroBaseImageSet = false
        locationManager.startUpdatingHeading()
    }
    
    func resetVars() {
        classes.cantRecal = true
        self.initIsFinished = false
        classes.shouldRecalibrate = false
        self.motionStage1Or2 = true
        self.startFromNorth = -1.0
        self.gyroBaseImageSet = false
        self.verifyButton = VerifyButton()
        addGroupButton.removeFromSuperview()
        addressButton.removeFromSuperview()
        addButton.removeFromSuperview()
    }
    
    //<- Recalibrate Stuff
    
    func reInitGroups() {
        groups = reader.groups
        manage.groups = groups
        groupScreen = GroupScreen(groups: groups, manage: manage)
        addressButton = AddAddressButton(cameraAngle: cameraAngle, manager: manage)
        addButton = AddButton(cameraAngle: cameraAngle, manager: manage)
        reader = WaypointReader(cameraAngle: cameraAngle, groups: groups, startFromNorth: startFromNorth, manage: manage)
    }
    
    func removeScreens() {
        groupScreen.removeFromSuperview()
    }
    
    
    
}

