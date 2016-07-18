//
//  MyLocationManager.swift
//  Waypointer
//
//  Created by Ryan on 1/23/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

public class MyLocationManager : NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager? //The thing that manages the persons locaion
    var myView : ViewController?
    var timesLocationRecorded = 0 //Init stage 2 will only run when this is 0
    var stageOne = true
    var lastHeadings = Array<Double>()
    var timesCorrected = 0
    
    init(myView : ViewController) {
        locationManager = CLLocationManager()
        self.myView = myView
        super.init()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager!.headingFilter = kCLHeadingFilterNone
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
        locationManager!.startUpdatingHeading()
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.location!.course
        let latitude = Double(manager.location!.coordinate.latitude)
        let longitude = Double(manager.location!.coordinate.longitude)
        let altitude = manager.location!.altitude
        let feetZ = altitude * 3.28084
        myView!.manage.changePersonLocation(myView!.myMath!.degreesToFeet(longitude), yPos: myView!.myMath!.degreesToFeet(latitude), zPos: feetZ) //To Reverse
        if(timesLocationRecorded == 0) {
            myView!.initStage2()
        }
        timesLocationRecorded += 1
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        if(stageOne) {
            if(myView!.verifyButton!.canContinue) {
                if(h2 == -1) {
                    myView!.isAbleToRun = false
                    myView!.removeAllGraphics()
                    myView!.view.addSubview(myView!.cannotRun)
                } else if(myView!.startFromNorth == -1.0 && newHeading.headingAccuracy > 0.0) {
                    myView!.startFromNorth = h2 * M_PI / 180 //To Reverse
                    myView!.manage.startFromNorth = myView!.startFromNorth
                    myView!.manage.updateStartFromNorth()
                    if !classes.isInForeground {
                        myView!.initStage3()
                        //self.startFromNorth = 0.0
                        let message = "We Have Detected You Are "  + Int(round(myView!.startFromNorth * 180 / M_PI)).description + " Degrees From North, Press OK You Agree, or Override"
                        let alert = UIAlertController(title: "Waypoint Creator", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                            let text: AnyObject? = alert.textFields?[0]
                            if let textf = text as? UITextField {
                                if let number = NSNumberFormatter().numberFromString(textf.text!) {
                                    self.myView!.startFromNorth = Double(number) * M_PI / 180
                                }
                            }
                            self.myView!.initIsFinished = true
                            classes.isInForeground = true
                            classes.cantRecal = false
                            self.stageOne = false
                            self.myView!.lastTimeInAppReset = CACurrentMediaTime()
                        }))
                        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                            textField.placeholder = ""
                            textField.secureTextEntry = false
                        })
                        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            if(myView!.motionManager != nil && myView!.motionManager!.isDeviceVert() == true) {
                let currentHeading = h2 * M_PI / 180 + myView!.manage.horAngle
                if(newHeading.headingAccuracy < 6) {
                    self.lastHeadings.append(currentHeading)
                }
                if(self.lastHeadings.count > 3) {
                    self.lastHeadings.removeFirst()
                    if(headingsAgree() && abs(myView!.startFromNorth - currentHeading) > 0.17453) {
                        var toSet = (myView!.startFromNorth * Double(timesCorrected))
                        toSet += currentHeading
                        toSet /= Double(timesCorrected + 1)
                        timesCorrected += 1
                        myView!.startFromNorth = toSet
                        print("Yo" + String(myView!.startFromNorth))
                        myView!.manage.startFromNorth = myView!.startFromNorth
                        myView!.manage.updateStartFromNorth()
                        self.lastHeadings.removeAll()
                    }
                }
            }
        }
    }
    
    func headingsAgree() -> Bool {
        var smallest = 5000.0
        var biggest = 0.0
        for x in self.lastHeadings {
            if x < smallest {
                smallest = x
            }
            if x > biggest {
                biggest = x
            }
        }
        if(biggest - smallest < 0.05235) {
            return true
        }
        return false
    }
    
    
    
    public func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool {
        if(myView!.isAbleToRun && myView!.startFromNorth == -1.0) {
            if let h = manager.heading {
                return (h.headingAccuracy < 0 || h.headingAccuracy > 10)
            }
        }
        return false
    }
}