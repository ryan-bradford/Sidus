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

public class AddAddressButton : UIButton {

    var redVal = 0.5
    var blueVal = 0.5
    var greenVal = 0.5
    var alphaVal = 0.3
    
    public init() {
        super.init(frame: CGRectMake(5, 110, 20, 20))
        self.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: CGFloat(greenVal), blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        removeAllGraphics()
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineWidth = 1
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(0/255), alpha: CGFloat(0.5)).CGColor
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 4, y: 9))
        path.addLineToPoint(CGPoint(x: 9, y: 9))
        path.addLineToPoint(CGPoint(x: 9, y: 4))
        path.addLineToPoint(CGPoint(x: 11, y: 4))
        path.addLineToPoint(CGPoint(x: 11, y: 9))
        path.addLineToPoint(CGPoint(x: 16, y: 9))
        path.addLineToPoint(CGPoint(x: 16, y: 11))
        path.addLineToPoint(CGPoint(x: 11, y: 11))
        path.addLineToPoint(CGPoint(x: 11, y: 16))
        path.addLineToPoint(CGPoint(x: 9, y: 16))
        path.addLineToPoint(CGPoint(x: 9, y: 11))
        path.addLineToPoint(CGPoint(x: 4, y: 11))
        path.closePath()
        shape.path = path.CGPath
        
        var name = "A"
        let fieldColor: UIColor = UIColor.darkGrayColor()
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(6))
        var paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        var skew = 0.1
        var attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        name.drawInRect(CGRectMake(13, 0, 10, 10), withAttributes: attributes as [NSObject : AnyObject])
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
    
    func removeAllGraphics() {
        if(self.layer.sublayers != nil) {
            for v in self.layer.sublayers {
                v.removeFromSuperlayer()
            }
        }
    }


}