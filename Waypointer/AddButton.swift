//
//  AddButton.swift
//  waypointr
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//


import Foundation
import UIKit

open class AddButton : UIButton {
    
    var myMath = MyMath()
    var manage : WaypointManager?
	var viewController: ViewController!
    
	init(manager : WaypointManager, frame: CGRect, viewController: ViewController) {
        self.manage = manager
		self.viewController = viewController
		super.init(frame: frame)
		//self.backgroundColor = UIColor.red
        myMath = MyMath()
		self.addTarget(self, action: #selector(AddButton.pressed(_:)), for: .touchUpInside)
		//initBlur()
    }
	
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
	
	func pressed(_ sender: UIButton!) {
		let newFrame = CGRect(x: viewController.view.frame.origin.x, y: -viewController.view.frame.height, width: viewController.view.frame.width, height: viewController.view.frame.height)
		if(viewController.addScreen == nil) {
			viewController.addScreen = AddScreen(frame: newFrame, manager: manage!, viewController: viewController)
		}
		viewController.view.addSubview(viewController.addScreen)
		UIView.animate(withDuration: 0.2, animations: {
			self.frame.origin.y += 15
		}, completion: {
			(value: Bool) in
			UIView.animate(withDuration: 0.2, animations: {
				self.frame.origin.y -= 15
			}, completion: {
				(value: Bool) in

				UIView.animate(withDuration: 0.5, animations: {
					
					self.viewController.addScreen.frame = self.viewController.view.frame
				})
			})
		})

	}
	
	override open func draw(_ rect: CGRect) {
		let scaleFactor = CGFloat(1.0/4.0)
		let graphicWidth = self.frame.width*scaleFactor
		let graphicHeight = self.frame.height*scaleFactor
		let centerXShift = (self.frame.width - graphicWidth)/2
		let centerYShift = CGFloat(25)
		let lineWidth = CGFloat(3)
		let linePath1 = UIBezierPath()
		linePath1.move(to: CGPoint(x: centerXShift, y: centerYShift+lineWidth))
		linePath1.addLine(to: CGPoint(x: centerXShift+graphicWidth/2, y: centerYShift+graphicHeight-lineWidth))
		linePath1.addLine(to: CGPoint(x: centerXShift+graphicWidth, y: centerYShift+lineWidth))
		linePath1.lineJoinStyle = CGLineJoin.round
		linePath1.lineWidth = lineWidth
		
		let linePath2 = UIBezierPath()
		linePath2.move(to: CGPoint(x: centerXShift+graphicWidth/4, y: centerYShift+lineWidth))
		linePath2.addLine(to: CGPoint(x: centerXShift+graphicWidth/2, y: centerYShift+(graphicHeight-lineWidth)/2))
		linePath2.addLine(to: CGPoint(x: centerXShift+3*graphicWidth/4, y: centerYShift+lineWidth))
		linePath2.lineJoinStyle = CGLineJoin.round
		linePath2.lineWidth = lineWidth
		
		UIColor.white.set()
		linePath1.stroke()
		linePath2.stroke()
	}
}
