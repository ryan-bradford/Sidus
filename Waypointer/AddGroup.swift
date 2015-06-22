//
//  AddButton.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

public class AddGroup : StandardAddButton {
    
    public init() {
        super.init(myLetter: "G", orderNum: 2)
        self.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pressed(sender: UIButton!) {
        classes.showGroupScreen = true
    }
}
