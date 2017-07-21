//
//  AddGroupButton.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/14/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class AddGroupButton: UIButton {
	
	var superScreen: AddScreen!
	
	public init(frame: CGRect, superScreen: AddScreen) {
		self.superScreen = superScreen
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.5)
		self.addTarget(self, action: #selector(AddGroupButton.pressed(_:)), for: .touchUpInside)
	}
	
	func pressed(_ sender: UIButton!) {
		superScreen.activeView = superScreen.addGroupScreen
		superScreen.transitionToMain()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func draw(_ rect: CGRect) {
		self.drawTextWithBox(0, y: 0, width: self.frame.width, height: self.frame.height, toDraw: "Add Group", fontSize: 35)
	}
	
	
}
