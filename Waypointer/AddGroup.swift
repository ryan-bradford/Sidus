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
    
    var showGroupScreen = false
    
    public init() {
        super.init(myLetter: "G", orderNum: 2)
        self.addTarget(self, action: #selector(AddGroup.pressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        showGroupScreen = false
        super.init(coder: aDecoder)
    }
    
    func pressed(sender: UIButton!) {
        self.showGroupScreen = true
    }
}
