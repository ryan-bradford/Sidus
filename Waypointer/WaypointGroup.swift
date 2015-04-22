//
//  WaypointGroup.swift
//  Waypointer
//
//  Created by Ryan on 4/21/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation


public class WaypointGroup {
    
    public var waypoints :  Array<Waypoint>
    public var name : String
    
    
    init(name : String) {
        waypoints = Array<Waypoint>()
        self.name = name
    }
    
    public func addWaypoint(toAdd : Waypoint) {
        waypoints.append(toAdd)
    }
    
}