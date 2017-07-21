//
//  UIViewExtensions.swift
//  waypointr
//
//  Created by Ryan Bradford on 7/14/17.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
		
	func drawMessage(_ message2 : String, X : CGFloat, Y : CGFloat) {
		let message1  = message2
		let message: NSMutableAttributedString = NSMutableAttributedString(string: message1)
		
		let fieldColor: UIColor = UIColor.black
		let fieldFont = UIFont(name: classes.FONT_NAME, size: CGFloat(25))
		let paraStyle = NSMutableParagraphStyle()
		paraStyle.alignment = NSTextAlignment.center
		paraStyle.lineSpacing = 6.0
		let skew = 0.1
		
		let attributes: NSDictionary = [
			NSForegroundColorAttributeName: fieldColor,
			NSParagraphStyleAttributeName: paraStyle,
			NSObliquenessAttributeName: skew,
			NSFontAttributeName: fieldFont!
		]
		
		message.addAttributes(attributes as! [AnyHashable: Any] as! [String : AnyObject], range: NSRange(location: 0, length: message.length) )
		//let toSubtract = CGFloat(countString / 2 * 7)
		//classes.screenWidth / 2) - toSubtract) + 10
		message.draw(in: CGRect(x: X, y: Y, width: 300.0, height: 60.0))
	}
	
	func drawTextWithNoBox(_ x: CGFloat, y: CGFloat, width: CGFloat, toDraw: String, fontSize: CGFloat) -> CGFloat {
		
		let fieldColor: UIColor = UIColor.black
		let fieldFont = UIFont(name: classes.FONT_NAME, size: CGFloat(fontSize))
		let paraStyle = NSMutableParagraphStyle()
		paraStyle.alignment = NSTextAlignment.center
		
		let attributes: NSDictionary = [
			NSForegroundColorAttributeName: fieldColor,
			NSParagraphStyleAttributeName: paraStyle,
			NSFontAttributeName: fieldFont!
		]
		
		let attbrMessage = NSAttributedString(string: toDraw, attributes: attributes as? [String : Any])
		
		let textHeight = self.heightWithConstrainedWidth(self.frame.width, font: fieldFont!, toGet: toDraw)
		attbrMessage.draw(in: CGRect(x: x, y: y, width: width, height: textHeight))
		return textHeight
	}
	
	func drawTextWithBox(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, toDraw: String, fontSize: CGFloat) {
		let fieldFont = UIFont(name: "HelveticaNeue", size: CGFloat(fontSize))
		let textHeight = self.heightWithConstrainedWidth(self.frame.width, font: fieldFont!, toGet: toDraw)
		let _ = drawTextWithNoBox(0, y: (height - textHeight)/2, width: width, toDraw: toDraw, fontSize: fontSize)
	}
	
	func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, toGet: String) -> CGFloat {
		let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		
		let boundingBox = toGet.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
		
		return boundingBox.height
	}
	
	func initBlur() {
		var blurEffect: UIBlurEffect!
		if #available(iOS 10.0, *) {
			blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
		} else {
			blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
		}
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(blurEffectView)
	}
	
	func submitWaypoints() -> Bool {
		return true
	}
	
}

