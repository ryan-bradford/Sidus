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
	var cancelButtion: CancelButton!
	var doneButton: DoneButton!
	var xInset = CGFloat(20.0)
	var yInset = CGFloat(20.0)
	
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
	
	func getButtonHeight() -> CGFloat {
		return (self.frame.height - yInset*2)/5
	}
	
	func initCancelButton() {
		cancelButtion = CancelButton(frame: CGRect(x: xInset, y: yInset, width: self.frame.width - xInset*2, height: getButtonHeight()))
		self.addSubview(cancelButtion)
	}
	
	func initAddAddressButton() {
		addAddressButton = AddAddressButton(frame: CGRect(x: xInset, y: getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()))
		self.addSubview(addAddressButton)
	}
	
	func initAddGroupButton() {
		addGroupButton = AddGroupButton(frame: CGRect(x: xInset, y: 2*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()))
		self.addSubview(addGroupButton)
		
	}
	
	func initAddCordinateButton() {
		addCordButton = AddCordinateButton(frame: CGRect(x: xInset, y: 3*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()))
		self.addSubview(addCordButton)
	}
	
	func initDoneButton() {
		doneButton = DoneButton(frame: CGRect(x: xInset, y: 4*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()))
		self.addSubview(doneButton)
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
