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
	var yInset = CGFloat(40.0)
	var manager: WaypointManager!
	var viewController: ViewController!
	
	init(frame: CGRect, manager: WaypointManager, viewController: ViewController) {
		self.manager = manager
		self.viewController = viewController
		super.init(frame: frame)
		initBlur()
		initAddGroupButton()
		initAddAddressButton()
		initAddCordinateButton()
		initGroupScreen()
		initAddressScreen()
		initCordScreen()
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
		cancelButtion = CancelButton(frame: CGRect(x: xInset, y: yInset, width: self.frame.width - xInset*2, height: getButtonHeight()), superScreen: self)
		self.addSubview(cancelButtion)
	}
	
	func initAddAddressButton() {
		addAddressButton = AddAddressButton(frame: CGRect(x: xInset, y: getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()), superScreen: self)
		self.addSubview(addAddressButton)
	}
	
	func initAddGroupButton() {
		addGroupButton = AddGroupButton(frame: CGRect(x: xInset, y: 2*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()), superScreen: self)
		self.addSubview(addGroupButton)
		
	}
	
	func initAddCordinateButton() {
		addCordButton = AddCordinateButton(frame: CGRect(x: xInset, y: 3*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()), superScreen: self)
		self.addSubview(addCordButton)
	}
	
	func initDoneButton() {
		doneButton = DoneButton(frame: CGRect(x: xInset + self.frame.width, y: 4*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: getButtonHeight()), superScreen: self)
		self.addSubview(doneButton)
	}
	
	func initGroupScreen() {
		addGroupScreen = AddGroupScreen(manage: manager, viewController: viewController, frame: CGRect(x: xInset + self.frame.width, y: 1*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: 3*getButtonHeight()))
		self.addSubview(addGroupScreen)
	}
	
	func initAddressScreen() {
		addAddressScreen = AddAddressScreen(manage: manager, viewController: viewController, frame: CGRect(x: xInset + self.frame.width, y: 1*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: 3*getButtonHeight()), superScreen: self)
		self.addSubview(addAddressScreen)
	}
	
	func initCordScreen() {
		addCordScreen = AddCordinateScreen(manage: manager, viewController: viewController, frame: CGRect(x: xInset + self.frame.width, y: 1*getButtonHeight()+yInset, width: self.frame.width - 2*xInset, height: 3*getButtonHeight()), superScreen: self)
		self.addSubview(addCordScreen )
	}

	
	func transitionToCordinate() {
		
	}
	
	func transitionToAddress() {
		
	}
	
	func transitionAwayFromActiveView() {
		slideMiddleThree(leftOrRight: false)
		slideDone(leftOrRight: false)
		UIView.animate(withDuration: 0.5, animations: {
			self.activeView?.frame.origin.x += self.frame.width
		})
		self.activeView = nil
	}
	
	func transitionToMain() {
		slideMiddleThree(leftOrRight: true)
		slideDone(leftOrRight: true)
		UIView.animate(withDuration: 0.5, animations: {
			self.activeView?.frame.origin.x -= self.frame.width
			
		})
	}
	
	func slideDone(leftOrRight: Bool) {
		var sign = CGFloat(1)
		if(leftOrRight) {
			sign = CGFloat(-1)
		}
		UIView.animate(withDuration: 0.5, animations: {
			self.doneButton.frame.origin.x += self.frame.width*sign
		})
	}
	
	func slideMiddleThree(leftOrRight: Bool) {
		var sign = CGFloat(1)
		if(leftOrRight) {
			sign = CGFloat(-1)
		}
		UIView.animate(withDuration: 0.5, animations: {
			self.addAddressButton.frame.origin.x += self.frame.width*sign
			self.addGroupButton.frame.origin.x += self.frame.width*sign
			self.addCordButton.frame.origin.x += self.frame.width*sign
		})
	}
	
	func slideSelfUp() {
		UIView.animate(withDuration: 0.5, animations: {
			self.frame.origin.y -= self.frame.height
		})
	}
	
	func slideUpDone() {
		UIView.animate(withDuration: 0.5, animations: {
			self.doneButton.frame.origin.y -= (self.doneButton.frame.height + self.yInset + self.doneButton.frame.height/8)
		})
	}
	
	func slideDownDone() {
		UIView.animate(withDuration: 0.5, animations: {
			self.doneButton.frame.origin.y += (self.doneButton.frame.height + self.yInset + self.doneButton.frame.height/8)
		})
	}
}
