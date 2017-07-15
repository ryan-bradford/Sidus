//
//  GreyTintScreen.swift
//  waypointr
//
//  Created by Ryan on 7/10/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit


open class GreyTintScreen : UIView {
    
    var redVal = 1.0
    var blueVal = 1.0
    var alphaVal = 0.3
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: classes.screenWidth, height: classes.screenHeight))
		initBlur()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
	
}
