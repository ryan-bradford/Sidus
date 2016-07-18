//
//  AddButton.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

public class AddButton : StandardAddButton {
    
    var myMath = MyMath(cameraAngle: 0.0)
    var manage : WaypointManager?
    
    public init(cameraAngle : Double, manager : WaypointManager) {
        self.manage = manager
        super.init(myLetter: "C", orderNum: 1)
        myMath = MyMath(cameraAngle: cameraAngle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pressed(sender: UIButton!) {
        super.pressed(sender)
        classes.cantRecal = true
        handleLatitude()
        
    }
    
    func handleLatitude() {
        let alert = UIAlertController(title: "Waypoint Creator", message: "Enter The Latitude Degree Amount", preferredStyle: UIAlertControllerStyle.Alert)
        var yDeg : Double = 0.0
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert.textFields![0] as UITextField
            if(textf.text != "") {
                yDeg = Double((textf.text! as NSString).doubleValue)
                self.handleLongitude(yDeg)
            } else {
                self.finish()
            }
            
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "52.723"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleLongitude(yDeg: Double) {
        var xDeg = 0.0
        let alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Longitude Degree Amount", preferredStyle: UIAlertControllerStyle.Alert)
        alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert2.textFields![0] as UITextField
            if(textf.text != "") {
                xDeg = Double((textf.text! as NSString).doubleValue)
                self.handleHeight(xDeg, yDeg: yDeg)
            } else {
                self.finish()
            }
        }))
        alert2.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "45.1281"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert2, animated: true, completion: nil)
    }
    
    func handleHeight(xDeg: Double, yDeg: Double) {
        var zHeight = manage!.personZ
        
        let alert = UIAlertController(title: "Waypoint Creator", message: "Enter The Height of the Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert.textFields![0] as UITextField
            if(textf.text != "") {
                zHeight = Double((textf.text! as NSString).doubleValue)
                self.handleName(xDeg, yDeg: yDeg, zHeight: zHeight)
            } else {
                self.finish()
            }
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "45"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleName(xDeg: Double, yDeg: Double, zHeight: Double) {
        let alert4 = UIAlertController(title: "Waypoint Creator", message: "Enter Name", preferredStyle: UIAlertControllerStyle.Alert)
        alert4.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert4.textFields![0] as UITextField
            if(textf.text != "") {
                let name = textf.text!
                self.manage!.addWaypoint(self.myMath.degreesToFeet(xDeg) , yPos : self.myMath.degreesToFeet(yDeg), zPos: zHeight, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: name)
                self.finish()
            } else {
                self.finish()
            }
        }))
        alert4.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Work"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert4, animated: true, completion: nil)
    }
}
