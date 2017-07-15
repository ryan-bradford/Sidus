//
//  AddButton.swift
//  waypointr
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

open class AddButton : UIButton {
    
    var myMath = MyMath()
    var manage : WaypointManager?
	var viewController: ViewController!
    
	init(manager : WaypointManager, frame: CGRect, viewController: ViewController) {
        self.manage = manager
		self.viewController = viewController
		super.init(frame: frame)
		self.backgroundColor = UIColor.red
        myMath = MyMath()
		self.addTarget(self, action: #selector(AddButton.pressed(_:)), for: .touchUpInside)
    }
	
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
	
	func pressed(_ sender: UIButton!) {
		let newFrame = CGRect(x: viewController.view.frame.origin.x, y: -viewController.view.frame.height, width: viewController.view.frame.width, height: viewController.view.frame.height)
		let addScreen = AddScreen(frame: newFrame)
		viewController.view.addSubview(addScreen)
		UIView.animate(withDuration: 0.5, animations: {
			addScreen.frame = self.viewController.view.frame
		})
	}

    func handleLatitude() {
        let alert = UIAlertController(title: "Waypoint Creator", message: "Enter The Latitude Degree Amount", preferredStyle: UIAlertControllerStyle.alert)
        var yDeg : Double = 0.0
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert.textFields![0] as UITextField
            if(textf.text != "") {
                yDeg = Double((textf.text! as NSString).doubleValue)
                self.handleLongitude(yDeg)
            } else {
                //self.finish()
            }
            
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "52.723"
            textField.isSecureTextEntry = false
        })
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleLongitude(_ yDeg: Double) {
        var xDeg = 0.0
        let alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Longitude Degree Amount", preferredStyle: UIAlertControllerStyle.alert)
        alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert2.textFields![0] as UITextField
            if(textf.text != "") {
                xDeg = Double((textf.text! as NSString).doubleValue)
                self.handleHeight(xDeg, yDeg: yDeg)
            } else {
                //self.finish()
            }
        }))
        alert2.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "45.1281"
            textField.isSecureTextEntry = false
        })
        UIApplication.shared.keyWindow?.rootViewController?.present(alert2, animated: true, completion: nil)
    }
    
    func handleHeight(_ xDeg: Double, yDeg: Double) {
        var zHeight = manage!.personZ
        
        let alert = UIAlertController(title: "Waypoint Creator", message: "Enter The Height of the Location", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert.textFields![0] as UITextField
            if(textf.text != "") {
                zHeight = Double((textf.text! as NSString).doubleValue)
                self.handleName(xDeg, yDeg: yDeg, zHeight: zHeight)
            } else {
                //self.finish()
            }
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "45"
            textField.isSecureTextEntry = false
        })
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleName(_ xDeg: Double, yDeg: Double, zHeight: Double) {
        let alert4 = UIAlertController(title: "Waypoint Creator", message: "Enter Name", preferredStyle: UIAlertControllerStyle.alert)
        alert4.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
            let textf = alert4.textFields![0] as UITextField
            if(textf.text != "") {
                let name = textf.text!
                self.manage!.addWaypoint(self.myMath.degreesToFeet(xDeg) , yPos : self.myMath.degreesToFeet(yDeg), zPos: zHeight, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: name)
                //self.finish()
            } else {
                //self.finish()
            }
        }))
        alert4.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Work"
            textField.isSecureTextEntry = false
        })
        UIApplication.shared.keyWindow?.rootViewController?.present(alert4, animated: true, completion: nil)
    }
	
	override open func draw(_ rect: CGRect) {
		let linePath = UIBezierPath()
		linePath.move(to: CGPoint(x: 0, y: 0))
		linePath.addLine(to: CGPoint(x: 100, y: 100))
		linePath.addLine(to: CGPoint(x: 100, y: 0))
		UIColor.black.set()
		linePath.stroke()
	}
}
