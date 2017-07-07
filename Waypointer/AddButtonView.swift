//
//  AddButtonView.swift
//  Sidus
//
//  Created by Ryan Bradford on 10/8/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class AddButtonView: UIView {
 
    public init(x: Int, y: Int, width: Int, height: Int) {
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
