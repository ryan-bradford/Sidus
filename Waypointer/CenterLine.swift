//
//  CenterLine.swift
//  waypointr
//
//  Created by Ryan on 7/10/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

open class CenterLine : UIView{
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: classes.screenWidth, height: 5))
        self.backgroundColor = UIColor.green
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setY(_ Y  : Int) {
        self.frame = CGRect(x: 0.0, y: Double(Y), width: classes.screenWidth, height: 5)
    }
    
}
