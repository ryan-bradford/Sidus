//
//  AddScreen.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/11/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class AddScreen: UIView {
	
	var activeView: UIView?
	var addAddressButton: AddAddressButton!
	var addAddressScreen: AddAddressScreen!
	var addCordButton: AddCordinateButton!
	var addCordScreen: AddCordinateScreen!
	var addGroupScreen: AddGroupScreen!
	var addGroupButton: AddGroupButton!
	var cancelButtion: UIButton!
	var doneButton: UIButton!
	var inset = CGFloat(20.0)
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		initBlur()
		initAddGroupButton()
		initAddAddressButton()
		initAddCordinateButton()
		initCancelButton()
		initDoneButton()
		self.backgroundColor = UIColor.clear
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func initCancelButton() {
		cancelButtion = UIButton(frame: CGRect(x: inset, y: 0, width: self.frame.width - inset*2, height: self.frame.height/5))
		self.addSubview(cancelButtion)
	}
	
	func initDoneButton() {
		doneButton = UIButton(frame: CGRect(x: inset, y: 4*self.frame.height/5, width: self.frame.width - 2*inset, height: self.frame.height/5))
		self.addSubview(doneButton)
	}
	
	func initAddCordinateButton() {
		addCordButton = AddCordinateButton(frame: CGRect(x: inset, y: 3*self.frame.height/5, width: self.frame.width - 2*inset, height: self.frame.height/5))
		self.addSubview(addCordButton)
	}
	
	func initAddAddressButton() {
		addAddressButton = AddAddressButton(frame: CGRect(x: inset, y: self.frame.height/5, width: self.frame.width - 2*inset, height: self.frame.height/5))
		self.addSubview(addAddressButton)
	}
	
	func initAddGroupButton() {
		addGroupButton = AddGroupButton(frame: CGRect(x: inset, y: 2*self.frame.height/5, width: self.frame.width - 2*inset, height: self.frame.height/5))
		self.addSubview(addGroupButton)

	}
	
	func transitionToCordinate() {
		
	}
	
	func transitionToAddress() {
		
	}
	
	func transitionToGroup() {
		
	}
	
	func initBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(blurEffectView)
	}
}
