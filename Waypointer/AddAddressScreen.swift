//
//  AddAddressScreen.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/14/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class AddAddressScreen: UIView {
	
	var addressNameBox: UITextField!
	var cityBox: UITextField!
	var stateBox: UITextField!
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
		if(addressNameBox != nil) {
			addressNameBox.removeFromSuperview()
		}
		addressNameBox = UITextField(frame: CGRect(x: 0, y: gap, width: self.frame.width, height: boxHeight))
		addressNameBox.text = "Address/Name of Location"
		addressNameBox.clearsOnBeginEditing = true
		addressNameBox.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
		addressNameBox.autocorrectionType = .no
		
		self.addSubview(addressNameBox)
		
		if(cityBox != nil) {
			cityBox.removeFromSuperview()
		}
		cityBox = UITextField(frame: CGRect(x: 0, y: boxHeight + 2*gap, width: self.frame.width, height: boxHeight))
		cityBox.text = "City of Location"
		cityBox.clearsOnBeginEditing = true
		cityBox.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
		cityBox.autocorrectionType = .no
		self.addSubview(cityBox)
		
		if(stateBox != nil) {
			stateBox.removeFromSuperview()
		}
		stateBox = UITextField(frame: CGRect(x: 0, y: 2*boxHeight + 3*gap, width: self.frame.width, height: boxHeight))
		stateBox.text = "State of Location"
		stateBox.clearsOnBeginEditing = true
		stateBox.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
		stateBox.autocorrectionType = .no
		self.addSubview(stateBox)
	}
	
	override func submitWaypoints() -> Bool {
		self.endEditing(true)
		let address = addressNameBox.text! + " " + cityBox.text! + " " + stateBox.text!
		let geocoder = CLGeocoder()
		var result: Bool? = nil
		geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
			if let buffer = placemarks?[0] {
				let placemark = buffer
				let location = placemark.location;
				let coordinate = location!.coordinate;
				let alert2 = UIAlertController(title: "Waypoint Creator", message: "Enter The Name of the Waypoint", preferredStyle: UIAlertControllerStyle.alert)
				alert2.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (alertAction:UIAlertAction) in
					let textf1 = alert2.textFields![0] as UITextField
					self.manage!.addWaypoint(self.myMath.degreesToFeet(coordinate.longitude) , yPos : self.myMath.degreesToFeet(coordinate.latitude), zPos: self.manage!.personZ, red: Int(arc4random_uniform(256)), green: Int(arc4random_uniform(256)), blue: Int(arc4random_uniform(256)), name: textf1.text!)
					result = true
					self.superScreen.slideDownDone()
					self.superScreen.transitionAwayFromActiveView()
					self.superScreen.slideSelfUp()
					
				}))
				alert2.addTextField(configurationHandler: {(textField: UITextField) in
					textField.placeholder = "Home"
					textField.isSecureTextEntry = false
				})
				UIApplication.shared.keyWindow?.rootViewController?.present(alert2, animated: true, completion: nil)
			} else {
				self.addressNameBox.text = "Please Enter a Valid Address"
				self.addressNameBox.textColor = UIColor.red
				
			}
		})
		return false
	}
	
	func invalidAddress() {
		
	}
	
	func stopEditing() {
		
	}
	
}
