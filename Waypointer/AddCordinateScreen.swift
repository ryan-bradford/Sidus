//
//  AddCordinateScreen.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/14/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class AddCordinateScreen: UIView {
	
	var latBox: UITextField!
	var longBox: UITextField!
	var heightBox: UITextField!
	var manage : WaypointManager?
	var cameraAngleX: Double?
	var cameraAngleY: Double?
	var viewController: ViewController?
	var startShift: CGFloat!
	var myMath = MyMath()
	var superScreen: AddScreen!
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(manage : WaypointManager, viewController: ViewController, frame: CGRect, superScreen: AddScreen) {
		self.superScreen = superScreen
		self.manage = manage
		cameraAngleX = manage.cameraAngleX
		cameraAngleY = manage.cameraAngleY
		self.viewController = viewController
		super.init(frame : frame)
		initTextFeilds()
		self.backgroundColor = UIColor.clear
	}
	
	func initTextFeilds() {
		let boxHeight = self.frame.height/8
		let gap = boxHeight/4
		if(latBox != nil) {
			latBox.removeFromSuperview()
		}
		latBox = UITextField(frame: CGRect(x: 0, y: gap, width: self.frame.width, height: boxHeight))
		latBox.text = "Latitude of Location"
		latBox.clearsOnBeginEditing = true
		latBox.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
		latBox.autocorrectionType = .no
		
		self.addSubview(latBox)
		
		if(longBox != nil) {
			longBox.removeFromSuperview()
		}
		longBox = UITextField(frame: CGRect(x: 0, y: boxHeight + 2*gap, width: self.frame.width, height: boxHeight))
		longBox.text = "Longitude of Location"
		longBox.clearsOnBeginEditing = true
		longBox.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
		longBox.autocorrectionType = .no
		self.addSubview(longBox)
		
		if(heightBox != nil) {
			heightBox.removeFromSuperview()
		}
		heightBox = UITextField(frame: CGRect(x: 0, y: 2*boxHeight + 3*gap, width: self.frame.width, height: boxHeight))
		heightBox.text = "Height of Location"
		heightBox.clearsOnBeginEditing = true
		heightBox.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
		heightBox.autocorrectionType = .no
		self.addSubview(heightBox)
	}
	
	override func submitWaypoints() -> Bool {
		self.endEditing(true)
		let lat = Double(self.latBox.text!)
		let long = Double(self.longBox.text!)
		let height = Double(self.heightBox.text!)
		var broken = false
		if lat == nil {
			latBox.text = "Check Latitude"
			latBox.textColor = UIColor.red
			broken = true
		}
		if long == nil {
			longBox.text = "Check Longitude"
			longBox.textColor = UIColor.red
			broken = true
		}
		if height == nil {
			heightBox.text = "Check Height"
			heightBox.textColor = UIColor.red
			broken = true
		}
		if broken {
			return false
		}
		let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat!), longitude: CLLocationDegrees(long!))
		let alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Name of the Waypoint", preferredStyle: UIAlertControllerStyle.alert)
		alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
			let textf1 = alert2.textFields![0] as UITextField
			self.manage!.addWaypoint(self.myMath.degreesToFeet(coordinate.longitude) , yPos : self.myMath.degreesToFeet(coordinate.latitude), zPos: height!, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: textf1.text!)
			self.superScreen.slideDownDone()
			self.superScreen.transitionAwayFromActiveView()
			self.superScreen.slideSelfUp()
			
		}))
		alert2.addTextField(configurationHandler: {(textField: UITextField) in
			textField.placeholder = "Home"
			textField.isSecureTextEntry = false
		})
		UIApplication.shared.keyWindow?.rootViewController?.present(alert2, animated: true, completion: nil)
		return false
	}
	
	func stopEditing() {
		
	}
	
}
