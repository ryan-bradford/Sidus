//
//  WaypointReader.swift
//  Sidus
//
//  Created by Ryan on 12/22/15.
//  Copyright © 2015 Ryan. All rights reserved.
//

import Foundation

public class WaypointReader {
    
    var myMath : MyMath
    var cameraAngle : Double
    var startFromNorth : Double
    var manage : WaypointManager
    
    init(cameraAngle : Double, startFromNorth : Double, manage : WaypointManager) {
        self.cameraAngle = cameraAngle
        myMath = MyMath(cameraAngle: cameraAngle)
        self.manage = manage
        self.startFromNorth = startFromNorth
    }
    
    func readGroups() {
        let path = NSBundle.mainBundle().pathForResource("groups", ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        var groupTexts = text.characters.split {$0 == "@"}.map { String($0) }
        for i in 1 ..< groupTexts.count {
            processGroup(groupTexts[i])
        }
    }
    
    func processGroup(group : String) {
        var waypointTexts = group.characters.split {$0 == "!"}.map { String($0) }
        let group = WaypointGroup(name: waypointTexts[0])
        for i in 1 ..< waypointTexts.count - 1 {
            group.addWaypoint(processWaypoint(waypointTexts[i]))
        }
        var found = false
        for i in 0 ..< manage.groups.count {
            if manage.groups[i].name == group.name {
                found = true
            }
        }
        if !found {
            manage.groups.append(group)
        }
    }
    
    func processWaypoint(waypoint : String) -> Waypoint {
        var parts = waypoint.characters.split {$0 == ","}.map { String($0) }
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
        return Waypoint(xPos: myMath.degreesToFeet((parts[2] as NSString).doubleValue), yPos: myMath.degreesToFeet((parts[1] as NSString).doubleValue), zPos: (parts[3] as NSString).doubleValue, red: redValue, green: greenValue, blue: blueValue, displayName: parts[0], cameraAngle : cameraAngle, manage : manage)
    }
    
    func addMountainGroup() {
        let group = WaypointGroup(name: "App Mtns")
        let waypoint  = Waypoint(xPos: myMath.degreesToFeet(-71.273333), yPos: myMath.degreesToFeet(43.954167), zPos: 3480, red: 255, green: 0, blue: 0, displayName: "Chocorua", cameraAngle : cameraAngle, manage : manage)
        group.addWaypoint(waypoint)
        manage.groups.append(group)
    }
}