//
//  WaypointGroup.swift
//  Sidus
//
//  Created by Ryan on 4/21/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation


open class WaypointGroup {
    
    open var waypoints :  Array<Waypoint>
    open var name : String
    open var active = false
    
    init(name : String) {
        waypoints = Array<Waypoint>()
        self.name = name
    }
    
    open func addWaypoint(_ toAdd : Waypoint) {
        waypoints.append(toAdd)
    }
    
}
