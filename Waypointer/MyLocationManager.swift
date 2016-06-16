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
    var accuracy = 0.0
    var lastAccuracy = -100.0
    var drawn = false
    
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
        accuracy = newHeading.headingAccuracy
        if(myView?.verifyButton != nil && (accuracy != lastAccuracy || !drawn)) {
            myView?.verifyButton?.accuracy = accuracy
            myView?.verifyButton!.redraw()
            drawn = true
            lastAccuracy = accuracy
        }
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
    }
    
}