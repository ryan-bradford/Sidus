//
//  AppDelegate.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import CoreLocation

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    //Latitude is up down, Logitude is left right
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        readGroups()
        return true
        
    }
    
    func readGroups() {
        let path = NSBundle.mainBundle().pathForResource("groups", ofType: "txt")
        var text = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)!
        var groupTexts = split(text) {$0 == "@"}
        for var i = 1; i < groupTexts.count; i++ {
            processGroup(groupTexts[i])
        }
    }
    
    func processGroup(group : String) {
        var waypointTexts = split(group) {$0 == "!"}
        var group = WaypointGroup(name: waypointTexts[0])
        for var i = 1; i < waypointTexts.count - 1; i++ {
            group.addWaypoint(processWaypoint(waypointTexts[i]))
        }
        classes.groups.append(group)
    }
    
    func processWaypoint(waypoint : String) -> Waypoint {
        var parts = split(waypoint) {$0 == ","}
        var redValue = Int(arc4random_uniform(255))
        if(!(parts[4] as NSString).isEqualToString("-1")) {
            redValue = (parts[4] as NSString).integerValue
        }
        var greenValue = Int(arc4random_uniform(255))
        if(!(parts[5] as NSString).isEqualToString("-1")) {
            greenValue = (parts[5] as NSString).integerValue
        }
        var blueValue = Int(arc4random_uniform(255))
        if(!(parts[6] as NSString).isEqualToString("-1")) {
            blueValue = (parts[6] as NSString).integerValue
        }
        return Waypoint(xPos: MyMath.degreesToFeet((parts[2] as NSString).doubleValue), yPos: MyMath.degreesToFeet((parts[1] as NSString).doubleValue), zPos: (parts[3] as NSString).doubleValue, red: redValue, green: greenValue, blue: blueValue, name: parts[0])
    }
    
    func addMountainGroup() {
        var group = WaypointGroup(name: "App Mtns")
        let waypoint  = Waypoint(xPos: MyMath.degreesToFeet(-71.273333), yPos: MyMath.degreesToFeet(43.954167), zPos: 3480, red: 255, green: 0, blue: 0, name: "Chocorua")
        group.addWaypoint(waypoint)
        classes.groups.append(group)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        classes.isInForeground = false;
        for var i = 0; i < classes.manage.drawnWaypoints.count; i++ {
            classes.manage.drawnWaypoints[i].removeFromSuperview()
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        if(!classes.inInit) {
            classes.shouldRecalibrate = true
        }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

