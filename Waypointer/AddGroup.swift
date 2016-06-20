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
    
    var viewController: ViewController?
    var showGroupScreen = false
    
    init(viewController: ViewController) {
        self.viewController = viewController
        super.init(myLetter: "G", orderNum: 2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pressed(sender: UIButton!) {
        viewController?.showGroupScreen()
    }
}
