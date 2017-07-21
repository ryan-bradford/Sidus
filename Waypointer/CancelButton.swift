//
//  CancelButton.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/14/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class CancelButton: UIButton {
	
	var superScreen: AddScreen!
	var text: UITextView!
	
	public init(frame: CGRect, superScreen: AddScreen) {
		super.init(frame: frame)
		self.superScreen = superScreen
		self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		self.addTarget(self, action: #selector(CancelButton.pressed(_:)), for: .touchUpInside)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func draw(_ rect: CGRect) {
		self.drawTextWithBox(0, y: 0, width: self.frame.width, height: self.frame.height, toDraw: "Cancel", fontSize: 50)
	}
	
	func pressed(_ sender: UIButton!) {
		if (superScreen.activeView as? AddAddressScreen) != nil {
			superScreen.slideDownDone()
			self.superScreen.addAddressScreen.endEditing(true)
		}
		if (superScreen.activeView as? AddCordinateScreen) != nil {
			superScreen.slideDownDone()
			self.superScreen.addCordScreen.endEditing(true)
		}
		if(superScreen.activeView != nil) {
			superScreen.transitionAwayFromActiveView()
		}
		superScreen.slideSelfUp()
	}
	
	
}
