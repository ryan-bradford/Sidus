//
//  AddAddressButton.swift
//  Waypointer
//
//  Created by Ryan on 6/2/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class AddAddressButton : StandardAddButton {
    
    var myMath = MyMath(cameraAngle: 0.0)
    var manage : WaypointManager?
    
    public init(cameraAngle : Double, manager : WaypointManager) {
        self.manage = manager
        super.init(myLetter: "A", orderNum: 3)
        myMath = MyMath(cameraAngle : cameraAngle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pressed(sender: UIButton!) {
        super.pressed(sender)
        classes.cantRecal = true
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        let alert = UIAlertController(title: "Waypoint Creator", message: "Enter Address of the Waypoint", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert.textFields![0] as UITextField
            let address = textf.text
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
                if let buffer = placemarks?[0] {
                    let placemark = buffer 
                    let location = placemark.location;
                    let coordinate = location!.coordinate;
                    let alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Name of the Waypoint", preferredStyle: UIAlertControllerStyle.Alert)
                    alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                        let textf1 = alert2.textFields![0] as UITextField
                        self.manage!.addWaypoint(self.myMath.degreesToFeet(coordinate.longitude) , yPos : self.myMath.degreesToFeet(coordinate.latitude), zPos: self.manage!.personZ, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: textf1.text!)
                        self.finish()

                    }))
                    alert2.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                            textField.placeholder = "Home"
                            textField.secureTextEntry = false
                    })
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert2, animated: true, completion: nil)
                } else {
                    self.finish()
                }
            })
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField) in
            textField.placeholder = "52 Wood Ave"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }
}