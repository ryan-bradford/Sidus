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
    var manage : WaypointManager
    
    public init(cameraAngle : Double, manager : WaypointManager) {
        self.manage = manager
        super.init(myLetter: "A", orderNum: 3)
        myMath = MyMath(cameraAngle : cameraAngle)
        self.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
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
        let alert = UIAlertController(title: "Waypoint Creator", message: "Enter Address of the Waypoint", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert.textFields![0] as UITextField
            let address = textf.text
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
                if let buffer = placemarks?[0] {
                    let placemark = buffer as! CLPlacemark
                    let location = placemark.location;
                    let coordinate = location!.coordinate;
                    let alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Name of the Waypoint", preferredStyle: UIAlertControllerStyle.Alert)
                    alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction) in
                        let textf1 = alert2.textFields![0] as UITextField
                        self.manage.addWaypoint(self.myMath.degreesToFeet(coordinate.longitude) , yPos : self.myMath.degreesToFeet(coordinate.latitude), zPos: self.manage.personZ, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: textf1.text!)
                        self.finish()

                    }))
                    alert2.addTextFieldWithConfigurationHandler({(textField: UITextField) in
                            textField.placeholder = "Name"
                            textField.secureTextEntry = false
                    })
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert2, animated: true, completion: nil)
                } else {
                    self.finish()
                }
            })
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