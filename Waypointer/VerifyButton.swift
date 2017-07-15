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
        drawMessage("Hold the Device Vertically Then Tap The Screen", X: CGFloat(classes.screenWidth / 2 - 150.0), Y: CGFloat(classes.screenHeight / 2.0) + 10)
        //drawMessage("Key : ", X: 0, Y: CGFloat(classes.screenHeight / 2.0) - 190.0)
        drawMessage("G = Add A Group", X: CGFloat(classes.screenWidth / 2 - 150.0), Y: CGFloat(classes.screenHeight / 2.0) + 160.0)
        drawMessage("A = Add An Address", X: CGFloat(classes.screenWidth / 2 - 150.0), Y: CGFloat(classes.screenHeight / 2.0) + 130.0)
        drawMessage("C = Add A Coordinate", X: CGFloat(classes.screenWidth / 2 - 150.0), Y: CGFloat(classes.screenHeight / 2.0) + 100.0)
        drawMessage("For Best Results, Spin the Phone Around A Bit", X: CGFloat(classes.screenWidth / 2 - 150.0), Y: CGFloat(classes.screenHeight / 2.0) + 200.0)
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
