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
    
    public init() {
        super.init(myLetter: "A", orderNum: 3)
        self.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pressed(sender: UIButton!) {
        redVal = 0
        blueVal = 0
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        var alert = UIAlertController(title: "Waypoint Creator", message: "Enter Address of the Waypoint", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
            let textf = alert.textFields?[0] as! UITextField
            var address = textf.text
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    let location = placemark.location;
                    let coordinate = location.coordinate;
                    var alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Name of the Waypoint", preferredStyle: UIAlertControllerStyle.Alert)
                    alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
                        let textf1 = alert2.textFields?[0] as! UITextField
                        classes.manage.addWaypoint(MyMath.degreesToFeet(coordinate.latitude) , yPos : MyMath.degreesToFeet(coordinate.longitude), zPos: classes.manage.personZ, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: textf1.text)
                        self.redVal = 0.5
                        self.blueVal = 0.5
                        self.backgroundColor = UIColor(red: CGFloat(self.redVal), green: CGFloat(self.greenVal), blue: CGFloat(self.blueVal), alpha: CGFloat(self.alphaVal))

                    }))
                    alert2.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                            textField.placeholder = "Name"
                            textField.secureTextEntry = false
                    })
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert2, animated: true, completion: nil)
                }
            })
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Name"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        
    }


}