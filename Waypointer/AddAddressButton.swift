//
//  AddAddressScreen.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/14/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class AddAddressButton: UIButton {
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 1, green: 0.66, blue: 0, alpha: 0.5)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func draw(_ rect: CGRect) {
		self.drawTextWithBox(0, y: 0, width: self.frame.width, height: self.frame.height, toDraw: "Add Address", fontSize: 40)
	}
	
}
