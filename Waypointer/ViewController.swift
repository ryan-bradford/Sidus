//
//  ViewController.swift
//  waypointr
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
    var cannotRun = CannotRunScreen(message: "Could not get a compass reading") //The screen that is displayed if the app cannot run
    var locationManager : MyLocationManager?
    internal var motionManager : MyMotionManager?
    var activeLine = CenterLine() //The line that moves in initStage1
    var centerLine = CenterLine() //The line that stays in initStage1
    var tint = GreyTintScreen() //The grey tint that is displayed in initStage1
    var isAbleToRun = true //Set to false if the phone is too old or does not allocate the proper permissions
    var cameraAngleX = (1.0) //The FOV of the camera
    var cameraAngleY = (1.0) //The FOV of the camera
    var initIsFinished = false //Set to true when the heading is set
    var lastTimeInAppReset = CACurrentMediaTime()
    //These Are Kinda In Order
    var groups : Array<WaypointGroup>! //Just Blank
    internal var manage : WaypointManager!
    var addButton : AddButton?
    var verifyButton : VerifyButton?
    var myMath : MyMath?
    var reader : WaypointReader?
    var addScreen: AddScreen!
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewWillAppear(_ anim : Bool) {
        initStage1()
        startThread()
    }
    
    func startThread() {
        DispatchQueue.global().async {
            while(self.isAbleToRun) {
                usleep(20000)
                if(classes.isInForeground && self.initIsFinished) {
                    DispatchQueue.main.async {
                        self.updateVars()
                        self.manage!.orderWaypoints()
                        self.updateWaypoints()
                    }
                }
            }
        }
    }
	
    //Periodic Processing ->
    
    func updateVars() {
        self.manage!.generateVars()
    }
    
    //<- Periodic Processing
    
    //Periodic Graphics ->
    
    func updateWaypoints() {
        for i in (self.manage!.drawnWaypoints.reversed()) {
            i.draw(self.view.frame)
            if(!i.drawn) {
                self.view.addSubview(i)
                i.drawn = true
            }
        }
    }
    
    //<- Periodic Graphics
    
    func removeWaypoints() {
        for i in 0 ..< self.manage!.drawnWaypoints.count {
            self.manage.drawnWaypoints[i].removeFromSuperview()
            self.manage.drawnWaypoints[i].drawn = false
        }
    }
    
    
    func showAllButtons() {
        self.view.addSubview(addButton!)
    }
    
    func hideAllButtons() {
		if(addScreen != nil) {
			addScreen.removeFromSuperview()
			addScreen = nil
		}
        addButton!.removeFromSuperview()
    }
    
    func removeAllGraphics() {
        for v in self.view.subviews {
            v.removeFromSuperview()
        }
        for i in self.manage!.drawnWaypoints {
                i.drawn = false
        }
    }
    
    //Init Stages ->
    
    func initStage1() {
		groups = Array<WaypointGroup>()
		manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngleX: cameraAngleX, cameraAngleY: cameraAngleY, groups: groups, startFromNorth: startFromNorth)
        classes.cantRecal = true
        initCameraFeed()
        if(isAbleToRun) {
            self.view.addSubview(tint)
            locationManager = MyLocationManager(myView: self)
            self.verifyButton = VerifyButton()
        }
    }
    
    func initStage2()  {
        if(isAbleToRun) {
            motionManager = MyMotionManager(myView: self, manage: manage!)
        }
        if(isAbleToRun) {
            self.centerLine.setY(Int(classes.screenHeight / 2))
            self.view.addSubview(activeLine)
            self.view.addSubview(centerLine)
            sleep(2)
            self.view.addSubview(verifyButton!)
        }
    }
    
    func initStage3() {
        if(isAbleToRun) {
			reader = WaypointReader(cameraAngleX: cameraAngleX, cameraAngleY: cameraAngleY, startFromNorth: startFromNorth, manage: manage)
			reader!.readGroups()
			let addWidth = CGFloat(120)
			addButton = AddButton(manager: manage, frame: CGRect(x: (self.view.frame.width/2-addWidth/2), y: 0, width: addWidth, height: addWidth), viewController: self)
            motionManager!.motionStage1Or2 = false
			tint.removeFromSuperview()
            verifyButton!.removeFromSuperview()
            showAllButtons()
            self.activeLine.removeFromSuperview()
            self.centerLine.removeFromSuperview()
            //locationManager?.locationManager?.stopUpdatingHeading()
            
        }
    }
    
    //<- Init Stages
    
    //Device Parts Init ->
    
    func initCameraFeed() { //TO STUDY
        let captureSession = AVCaptureSession()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResize //TO STUDY
        if let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
            //videoDevice.activeFormat.highResolutionStillImageDimensions
            var cameraRatio = 1.0
            var cameraHeight = 1.0
            var cameraWidth = 1.0
            if let formatDescription = videoDevice.activeFormat.formatDescription {
                let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
                cameraRatio = Double(dimensions.height) / Double(dimensions.width)
                cameraWidth = Double(dimensions.height)
                cameraHeight = Double(dimensions.width)
            }
            cameraAngleX = Double(videoDevice.activeFormat.videoFieldOfView) * cameraRatio
            cameraAngleY = Double(videoDevice.activeFormat.videoFieldOfView)
            let screenRatio = classes.screenWidth / classes.screenHeight
            if(screenRatio > cameraRatio) {
                let scaleFactor = 1 - (((classes.screenWidth * cameraHeight / classes.screenHeight) - cameraWidth) / cameraWidth)
                cameraAngleX *= scaleFactor
            } else if(screenRatio < cameraRatio) {
                let scaleFactor = 1 - (((classes.screenHeight * cameraWidth / classes.screenWidth) - cameraHeight) / cameraHeight)
                cameraAngleY *= scaleFactor
            }
            cameraAngleX *= (.pi / 180)
            cameraAngleY *= (.pi / 180)
            myMath = MyMath()
            let videoIn : AVCaptureDeviceInput?
            do {
                videoIn = try AVCaptureDeviceInput(device: videoDevice)
                if (captureSession.canAddInput(videoIn! as AVCaptureInput)){
                    captureSession.addInput(videoIn! as AVCaptureDeviceInput)
                }
            } catch _ {
                removeAllGraphics()
                isAbleToRun = false
                cannotRun = CannotRunScreen(message: "No camera available")
                self.view.addSubview(cannotRun)
            }
        } else {
            removeAllGraphics()
            isAbleToRun = false
            cannotRun = CannotRunScreen(message: "No camera available")
            self.view.addSubview(cannotRun)
        }
        captureSession.startRunning()
        previewLayer?.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer!)
    }
    
    //<- Device Parts Init
    
    
    //Recalibrate Stuff ->
    
    func removeStuff() {
        self.removeWaypoints()
        self.removeScreens()
    }
    
    func fullRecalibrate() {
        self.resetVars()
        locationManager!.locationManager!.startUpdatingHeading()
        self.centerLine.setY(Int(classes.screenHeight / 2))
        self.view.addSubview(activeLine)
        activeLine.draw(CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        self.view.addSubview(centerLine)
        centerLine.draw(CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        self.view.addSubview(verifyButton!)
        verifyButton!.draw(CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
    }
    
    func inAppRecalibrate() {
        classes.cantRecal = true
        self.initIsFinished = false
        self.startFromNorth = -1.0
        locationManager!.stageOne = true
        locationManager!.locationManager!.startUpdatingHeading()
    }
    
    func resetVars() {
        classes.cantRecal = true
        self.initIsFinished = false
        motionManager!.motionStage1Or2 = true
        motionManager!.gyroBaseImageSet = false
        self.startFromNorth = -1.0
        locationManager!.stageOne = true
        self.verifyButton = VerifyButton()
		hideAllButtons()
    }
    
    //<- Recalibrate Stuff
    
    func removeScreens() {
        //if(groupScreen != nil) {
        //    groupScreen!.removeFromSuperview()
        //}
    }
    
    func checkResume(_ canRun: Bool) {
        if (!self.isAbleToRun) && canRun && classes.isInForeground {
            self.cannotRun.removeFromSuperview()
            isAbleToRun = true
            self.view.addSubview(addButton!)
            startThread()
        }
    }

    
    
}

