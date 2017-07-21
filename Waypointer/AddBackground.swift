//
//  BlurBackground.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/15/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class AddBackground: UIView {
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		initBlur()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
