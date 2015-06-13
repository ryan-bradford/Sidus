//
//  AddButton.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

public class AddGroup : StandardAddButton {
    
    public init() {
        super.init(myLetter: "G", orderNum: 2)
        self.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pressed(sender: UIButton!) {
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: 1, blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        var alert = UIAlertController(title: "Group Adder", message: "Enter The Name of the Group", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
            let textf = alert.textFields?[0] as! UITextField
            for var i = 0; i < classes.groups.count; i++ {
                if(classes.groups[i].name == textf.text.uppercaseString) {
                    for var x = 0; x < classes.groups[i].waypoints.count; x++ {
                        classes.groups[i].waypoints[x].updateDistance()
                        classes.manage.addWaypoint(classes.groups[i].waypoints[x])
                    }
                    break;
                }
            }
            self.redVal = 0.5
            self.blueVal = 0.5
            self.backgroundColor = UIColor(red: CGFloat(self.redVal), green: CGFloat(self.greenVal), blue: CGFloat(self.blueVal), alpha: CGFloat(self.alphaVal))
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Name"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
}
