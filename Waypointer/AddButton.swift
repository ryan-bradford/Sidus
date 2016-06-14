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
    var manage : WaypointManager
    
    public init(cameraAngle : Double, manager : WaypointManager) {
        self.manage = manager
        super.init(myLetter: "W", orderNum: 1)
        self.addTarget(self, action: #selector(AddButton.pressed(_:)), forControlEvents: .TouchUpInside)
        myMath = MyMath(cameraAngle: cameraAngle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngle: 1.0, groups: Array<WaypointGroup>(), startFromNorth: 0.0)
        super.init(coder: aDecoder)
    }
    
    func pressed(sender: UIButton!) {
        classes.cantRecal = true
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        let alert = UIAlertController(title: "Waypoint Creator", message: "Enter The Latitude Degree Amount", preferredStyle: UIAlertControllerStyle.Alert)
        var xDeg : Double = 0.0
        var yDeg : Double = 0.0
        var zHeight : Double = 0.0
        var name = ""
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert.textFields![0] as UITextField
            if(textf.text != "") {
                yDeg = Double((textf.text! as NSString).doubleValue)
                let alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Longitude Degree Amount", preferredStyle: UIAlertControllerStyle.Alert)
                alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                    let textf = alert2.textFields![0] as UITextField
                    if(textf.text != "") {
                        xDeg = Double((textf.text! as NSString).doubleValue)
                        let alert3 = UIAlertController(title: "Waypoint Creator", message: "Enter Height (In Feet)", preferredStyle: UIAlertControllerStyle.Alert)
                        alert3.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                            let textf = alert3.textFields![0] as UITextField
                            if(textf.text != "") {
                                zHeight = Double((textf.text! as NSString).doubleValue)
                                let alert4 = UIAlertController(title: "Waypoint Creator", message: "Enter Name", preferredStyle: UIAlertControllerStyle.Alert)
                                alert4.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                                    let textf = alert4.textFields![0] as UITextField
                                    if(textf.text != "") {
                                        name = textf.text!
                                        self.manage.addWaypoint(self.myMath.degreesToFeet(xDeg) , yPos : self.myMath.degreesToFeet(yDeg), zPos: zHeight, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: name)
                                        self.finish()
                                    } else {
                                        self.finish()
                                    }
                                }))
                                alert4.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                                    textField.placeholder = "Name"
                                    textField.secureTextEntry = false
                                })
                                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert4, animated: true, completion: nil)
                            } else {
                                self.finish()
                            }
                        }))
                        alert3.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                            textField.placeholder = "Name"
                            textField.secureTextEntry = false
                        })
                        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert3, animated: true, completion: nil)
                    } else {
                        self.finish()
                    }
                }))
                alert2.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                    textField.placeholder = "Name"
                    textField.secureTextEntry = false
                })
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert2, animated: true, completion: nil)
            } else {
                self.finish()
            }
            
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "Name"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func finish() {
        self.redVal = 0.5
        self.blueVal = 0.5
        self.backgroundColor = UIColor(red: CGFloat(self.redVal), green: CGFloat(self.greenVal), blue: CGFloat(self.blueVal), alpha: CGFloat(self.alphaVal))
        classes.cantRecal = false
    }
}
