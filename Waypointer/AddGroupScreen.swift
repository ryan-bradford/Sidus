//
//  GroupScreen.swift
//  waypointr
//
//  Created by Ryan on 6/22/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

open class AddGroupScreen : UIButton {
    
    var buttons : Array<GroupButton>?
    var manage : WaypointManager?
    var goAwayGroupScreen = false
    var cameraAngleX: Double?
    var cameraAngleY: Double?
    var currentLocButton: CurrentLocationButton?
    var buttonLimit: Int?
    var viewController: ViewController?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(manage : WaypointManager, viewController: ViewController) {
        self.manage = manage
        cameraAngleX = manage.cameraAngleX
        cameraAngleY = manage.cameraAngleY
        buttons = Array<GroupButton>()
        self.viewController = viewController
        super.init(frame : CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
        self.addTarget(self, action: #selector(AddGroupScreen.pressed(_:)), for: UIControlEvents.touchUpInside);
        buttonLimit = Int(floor((self.frame.height / 2) - 20) / ((CGFloat(self.frame.height - 20.0)) / classes.groupsPerCollum)) * Int(classes.groupsPerRow)
        for i in 0 ..< self.manage!.groups.count {
            buttons!.append(GroupButton(group: manage.groups[i], order: i, manage: manage, goAwayGroupScreen: goAwayGroupScreen))
            self.addSubview(buttons![buttons!.count - 1])
            
        }
        currentLocButton = CurrentLocationButton(groups: self)
        self.addSubview(currentLocButton!)
        self.backgroundColor = (UIColor(red: 1, green: 1, blue: 1, alpha: 0.3))
    }
    
    func addGroup(_ toAdd: WaypointGroup) {
        if(manage!.groups.count < buttonLimit!) {
            manage!.groups.append(toAdd)
            let id = manage!.groups.count - 1
            buttons!.append(GroupButton(group: manage!.groups[id], order: id, manage: manage!, goAwayGroupScreen: goAwayGroupScreen))
            self.addSubview(buttons![buttons!.count - 1])
        }
    }
    
    func currentLocationGroup() {
        let alert = UIAlertController(title: "Current Location Name", message: "What do you want to call your current location?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
            let textf1 = alert.textFields![0] as UITextField
            let name = textf1.text
            let currentWaypoint = Waypoint(xPos: self.manage!.personX, yPos: self.manage!.personY, zPos: self.manage!.personZ, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), displayName: name!, cameraAngleX: self.cameraAngleX!, cameraAngleY: self.cameraAngleY!, manage: self.manage!)
            let group = WaypointGroup(name: name!)
            group.addWaypoint(currentWaypoint)
            self.addGroup(group)
            self.currentLocButton?.finish()
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField) in
                textField.placeholder = "My Car"
                textField.isSecureTextEntry = false
        })
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    override open func draw(_ rect: CGRect) {

        let message  = "Press Which Group You Want to Add or Remove" + "\n" + "(tap screen to dismiss)"
	
        //let toSubtract = CGFloat(countString / 2 * 7)
		self.drawTextWithBox(0, y: CGFloat(classes.screenHeight - 120.0), width: 300, height: 120, toDraw: message, fontSize: 25)
        message.draw(in: CGRect(x: CGFloat(0), y: CGFloat(classes.screenHeight - 120.0), width: 300.0, height: 120.0))
        
    }
    
    func pressed(_ sender: UIButton!) {
    }
    
}
