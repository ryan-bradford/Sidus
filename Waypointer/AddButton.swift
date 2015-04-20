//
//  AddButton.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

public class AddButton : UIButton {
    
    public init() {
        super.init(frame: CGRectMake(5, 50, 20, 20))
        self.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        self.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
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
    }
    
    func pressed(sender: UIButton!) {
        var alert = UIAlertController(title: "Waypoint Creator", message: "Enter The Latitude Degree Amount", preferredStyle: UIAlertControllerStyle.Alert)
        var xDeg : Double = 0.0
        var yDeg : Double = 0.0
        var zHeight : Double = 0.0
        var name = ""
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
            let textf = alert.textFields?[0] as! UITextField
            xDeg = Double((textf.text as NSString).doubleValue)
            var alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Longitude Degree Amount", preferredStyle: UIAlertControllerStyle.Alert)
            alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
                let textf = alert2.textFields?[0] as! UITextField
                yDeg = Double((textf.text as NSString).doubleValue)
                var alert3 = UIAlertController(title: "Waypoint Creator", message: "Enter Height (In Feet)", preferredStyle: UIAlertControllerStyle.Alert)
                alert3.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
                    let textf = alert3.textFields?[0] as! UITextField
                    zHeight = Double((textf.text as NSString).doubleValue)
                    var alert4 = UIAlertController(title: "Waypoint Creator", message: "Enter Name", preferredStyle: UIAlertControllerStyle.Alert)
                    alert4.addAction(UIAlertAction(title: "Ok", style: .Default, handler:{ (alertAction:UIAlertAction!) in
                        let textf = alert4.textFields?[0] as! UITextField
                        name = textf.text
                        classes.manage.addWaypoint(xDeg * 10000 * 3280.4 / 90 , yPos : yDeg * 10000 * 3280.4 / 90 , zPos: zHeight, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: name)
                    }))
                    alert4.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                        textField.placeholder = "Name"
                        textField.secureTextEntry = false
                    })
                    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert4, animated: true, completion: nil)
                }))
                alert3.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Name"
                    textField.secureTextEntry = false
                })
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert3, animated: true, completion: nil)
            }))
            alert2.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Name"
                textField.secureTextEntry = false
            })
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert2, animated: true, completion: nil)
            
        }))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Name"
            textField.secureTextEntry = false
        })
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        let textf = alert.textFields
        
    }
    
}
