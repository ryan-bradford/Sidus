//
//  VerifyButton.swift
//  waypointr
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

open class VerifyButton : UIButton {
    
    var redVal = 1.0
    var blueVal = 1.0
    var alphaVal = 0.3
    var canContinue = false
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(classes.screenWidth), height: CGFloat(classes.screenHeight)))
        self.addTarget(self, action: #selector(VerifyButton.pressed(_:)), for: .touchUpInside)
        self.backgroundColor = UIColor.clear
    }
    
    override open func draw(_ rect: CGRect) {
		let drawSpace = (300.0)
		var yToUse = CGFloat(classes.screenHeight / 2.0) + 10
        yToUse += drawTextWithNoBox(CGFloat(classes.screenWidth / 2 - drawSpace/2), y: CGFloat(yToUse), width: CGFloat(drawSpace), toDraw: "Hold the Device Vertically Then Tap The Screen", fontSize: 25)
		yToUse += CGFloat(100)
        //drawMessage("Key : ", X: 0, Y: CGFloat(classes.screenHeight / 2.0) - 190.0)
		yToUse += drawTextWithNoBox(CGFloat(classes.screenWidth / 2 - drawSpace/2), y: CGFloat(yToUse), width: CGFloat(drawSpace), toDraw: "For Best Results, Spin the Phone Around A Bit", fontSize: 25)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.canContinue = true
        super.init(coder: aDecoder)
    }
    
    func pressed(_ sender: UIButton!) {
            self.canContinue = true
            redVal = 0
            blueVal = 0.4
            self.backgroundColor = UIColor(red: CGFloat(redVal), green: 1, blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
	}
	
    
    
}
