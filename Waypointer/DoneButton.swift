//
//  DoneButton.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/14/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class DoneButton: UIButton {
	
	var superScreen: AddScreen!
	
	public init(frame: CGRect, superScreen: AddScreen) {
		self.superScreen = superScreen
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
		self.addTarget(self, action: #selector(CancelButton.pressed(_:)), for: .touchUpInside)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func draw(_ rect: CGRect) {
		self.drawTextWithBox(0, y: 0, width: self.frame.width, height: self.frame.height, toDraw: "Done", fontSize: 50)
	}
	
	func pressed(_ sender: UIButton!) {
		let result = superScreen.activeView?.submitWaypoints()
		if(result)! {
			if (superScreen.activeView as? AddAddressScreen) != nil {
				superScreen.slideDownDone()
			}
			if (superScreen.activeView as? AddCordinateScreen) != nil {
				superScreen.slideDownDone()
			}
			superScreen.transitionAwayFromActiveView()
			superScreen.slideSelfUp()
		}
	}
	
	
}
