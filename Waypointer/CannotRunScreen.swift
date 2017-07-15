//
//  VerifyButton.swift
//  waypointr
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

open class CannotRunScreen : UIView {
    
    var redVal = 1.0
    var blueVal = 0.0
    var alphaVal = 0.6
    var message: String?
    
    public init(message: String) { //TO STUDY
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(classes.screenWidth), height: CGFloat(classes.screenHeight)))
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: 0.0, blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.message = message
    }
    
    override open func draw(_ rect: CGRect) {
        drawMessage("The Application Could Not Launch" + "\n" + message!, X: 0, Y: CGFloat(classes.screenHeight / 2.0) - 30.0)
        
    }
    
    override func drawMessage(_ message : String, X : CGFloat, Y : CGFloat) {
        
        let _ = drawTextWithNoBox(X, y: Y, width: CGFloat(classes.screenWidth), toDraw: message, fontSize: 25)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
