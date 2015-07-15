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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        addMountainGroup()

        classes.manage.addWaypoint(0, yPos: 1, zPos: 0, red: 255, green: 0, blue: 0, name: "1")
        classes.manage.addWaypoint(0, yPos: 10, zPos: 0, red: 255, green: 0, blue: 0, name: "2")
        classes.manage.addWaypoint(0, yPos: 100, zPos: 0, red: 255, green: 0, blue: 0, name: "3")
        classes.manage.addWaypoint(0, yPos: 1000, zPos: 0, red: 255, green: 0, blue: 0, name: "4")
        classes.manage.addWaypoint(0, yPos: 10000, zPos: 0, red: 255, green: 0, blue: 0, name: "5")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "6")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "7")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "8")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "9")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "10")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "11")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "12")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "13")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "14")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "15")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "16")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "17")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "18")
        classes.manage.addWaypoint(0, yPos: 100000, zPos: 0, red: 255, green: 0, blue: 0, name: "19")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "20")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "21")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "22")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "23")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "24")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "25")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "26")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "27")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "28")
        classes.manage.addWaypoint(0, yPos: 100000000, zPos: 0, red: 255, green: 0, blue: 0, name: "29")
        classes.manage.addWaypoint(0, yPos: 1000009000, zPos: 0, red: 255, green: 0, blue: 0, name: "30")


        return true
            
    }
    
    func addMountainGroup() {
        var group = WaypointGroup(name: "MOUNTAINS")
        let waypoint  = Waypoint(xPos: 0.0, yPos: -1.0, zPos: 0.0, red: 255, green: 0, blue: 0, name: "HI")
        group.addWaypoint(waypoint)
        classes.groups.append(group)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

