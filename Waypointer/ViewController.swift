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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(anim : Bool) {
        initLocationManager()
        initCameraFeed()
        sleep(1)
        self.view.addSubview(classes.verifyButton)
        let location = locationManager.location
        var startX = CGFloat(location.coordinate.latitude)
        var startY = CGFloat(location.coordinate.longitude)
        var startAngle = CGFloat(0.0)
        if let attitude = classes.motionManager.deviceMotion?.attitude {
            startAngle = CGFloat(-attitude.pitch)
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            while(true) {
                usleep(1000000)
                if(classes.canContinue) {
                    self.initApp(startX, startY: startY, startAngle: startAngle)
                    classes.manage.orderWaypoints()
                    dispatch_async(dispatch_get_main_queue()) {
                        for var i = 0; i < classes.manage.waypoints.count; i++ {
                            self.view.addSubview(classes.manage.waypoints[i])
                        }
                        classes.addButton.removeFromSuperview()
                        self.view.addSubview(classes.addButton)
                    }
                }
            }
        }
    }
    
    func updateWaypoints() {
        classes.manage.orderWaypoints()
        for var i = 0; i < classes.manage.waypoints.count; i++ {
            self.view.addSubview(classes.manage.waypoints[i])
        }
        
    }
    
    func initApp(startX : CGFloat, startY : CGFloat, startAngle : CGFloat) {
        if(classes.timesInitRun == 0) {
            let location = locationManager.location
            var endX = location.coordinate.latitude
            var endY = location.coordinate.longitude
            var endAngle = CGFloat(0.0)
            if let attitude = classes.motionManager.deviceMotion?.attitude {
                endAngle = CGFloat(-attitude.pitch)
            }
            var toCalc = Line(startingXPos: Double(startX), startingYPos: Double(startY), startingZPos: 0.0, endingXPos: Double(endX), endingYPos: Double(endY), endingZPos: 0.0)
            classes.startFromNorth = MyMath.getLineHorizontalAngle(toCalc)
            usleep(200000)
            classes.verifyButton.removeFromSuperview()
            classes.timesInitRun += 1
        }
        
    }
    
    func editAddButton(toAddOrRemove : Bool) { //True is add, false is remove
        if(toAddOrRemove) {
            self.view.addSubview(classes.addButton)
        } else {
            classes.addButton.removeFromSuperview()
        }
    }
    
    func editWaypointEditor(toAddOrRemove : Bool) {
        if(toAddOrRemove) {
            //Make it slide in
            //Tell the editor which waypoint you are changing, or if you are adding
        } else {
            //Make it slide out
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
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            var coord = locationObj.coordinate
            var latitude = Double(coord.latitude)
            var longitude = Double(coord.longitude)
            var altitude = Double(locationObj.altitude)
            var kiloScaler = Double(10000/90)
            var kiloX = latitude * kiloScaler
            var kiloY = longitude * kiloScaler
            var kiloZ = altitude
            var feetScaler = 3280.84
            var feetX = kiloX * feetScaler
            var feetY = kiloY * feetScaler
            var feetZ = kiloZ * 3.28084
            println(feetX)
            println(feetY)
            classes.manage.changePersonLocation(feetX, yPos: feetY, zPos: feetZ)
        }
    }
    
    // authorization status
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            if (shouldIAllow == true) {
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
            }
    }
    
    
}

