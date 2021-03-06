//
//  MyLocationManager.swift
//  waypointr
//
//  Created by Ryan on 1/23/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import CoreLocation
import SceneKit

open class MyLocationManager : NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager? //The thing that manages the persons locaion
    var myView : ViewController?
    var timesLocationRecorded = 0 //Init stage 2 will only run when this is 0
    var stageOne = true
    var lastHeadings = Array<Double>()
    var timesCorrected = 0
    var horSubtract: Double
    
    init(myView : ViewController) {
        horSubtract = ((myView.cameraAngleX / 2) * (classes.screenWidth / classes.screenHeight))
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
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if(myView!.manage != nil) {
			let latitude = Double(manager.location!.coordinate.latitude)
			let longitude = Double(manager.location!.coordinate.longitude)
			let altitude = manager.location!.altitude
			let feetZ = altitude * 3.28084
			myView!.manage.changePersonLocation(myView!.myMath!.degreesToFeet(longitude), yPos: myView!.myMath!.degreesToFeet(latitude), zPos: feetZ) //To Reverse
		}
		if(timesLocationRecorded == 0) {
			myView!.initStage2()
		}
		timesLocationRecorded += 1
    }
	
    open func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        if(stageOne) {
            if(myView!.verifyButton!.canContinue) {
                if(h2 == -1) {
                    myView!.isAbleToRun = false
                    myView!.removeAllGraphics()
                    myView!.cannotRun = CannotRunScreen(message: "Could not get a compass reading")
                    myView!.view.addSubview(myView!.cannotRun)
                } else if(myView!.startFromNorth == -1.0 && newHeading.headingAccuracy > 0.0) {
                    myView!.startFromNorth = 0
                    myView!.manage.startFromNorth = myView!.startFromNorth
                    myView!.manage.updateStartFromNorth()
                    if !classes.isInForeground {
						usleep(250000)
                        myView!.initStage3()
						self.myView!.initIsFinished = true
						classes.isInForeground = true
						classes.cantRecal = false
						self.stageOne = false
						self.myView!.lastTimeInAppReset = CACurrentMediaTime()
						//self.locationManager!.headingFilter = 1.0
                    }
                }
            }
        } else {
            let toUse = -h2 * .pi / 180 - horSubtract
            if((abs(toUse - myView!.manage.horAngle)) < .pi) {
                myView!.manage.horAngle = (myView!.manage.horAngle + (toUse)) / 2
            } else {
                myView!.manage.horAngle = toUse
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
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {               myView!.removeAllGraphics()
        myView!.isAbleToRun = false
        myView!.cannotRun = CannotRunScreen(message: "Could not get a GPS signal")
        myView!.view.addSubview(myView!.cannotRun)
    }
    
    open func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        if(myView!.isAbleToRun && myView!.startFromNorth == -1.0) {
            if let h = manager.heading {
                return (h.headingAccuracy < 0 || h.headingAccuracy > 10)
            }
        }
        return false
    }
}
