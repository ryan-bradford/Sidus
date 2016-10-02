//
//  AddButton.swift
//  Sidus
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

open class AddGroup : StandardAddButton {
    
    var viewController: ViewController?
    var showGroupScreen = false
    
    init(viewController: ViewController) {
        self.viewController = viewController
        super.init(myLetter: "G", orderNum: 2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pressed(_ sender: UIButton!) {
        viewController?.showGroupScreen()
    }
}
