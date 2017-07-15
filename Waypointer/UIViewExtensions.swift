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
		let fieldFont = UIFont(name: "Symbol", size: CGFloat(25))
		let paraStyle = NSMutableParagraphStyle()
		paraStyle.alignment = NSTextAlignment.center
		paraStyle.lineSpacing = 6.0
		let skew = 0.1
		message.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 25)], range: NSRange(location: 5, length: 2))
		
		let attributes: NSDictionary = [
			NSForegroundColorAttributeName: fieldColor,
			NSParagraphStyleAttributeName: paraStyle,
			NSObliquenessAttributeName: skew,
			NSFontAttributeName: fieldFont!
		]
		let countString = (message.length)
		message.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 25)], range: NSRange(location: 0, length: countString))
		message.addAttributes(attributes as! [AnyHashable: Any] as! [String : AnyObject], range: NSRange(location: 0, length: countString) )
		//let toSubtract = CGFloat(countString / 2 * 7)
		//classes.screenWidth / 2) - toSubtract) + 10
		message.draw(in: CGRect(x: X, y: Y, width: 300.0, height: 60.0))
	}
	
	func drawTextWithNoBox(_ x: CGFloat, y: CGFloat, width: CGFloat, toDraw: String, fontSize: CGFloat) -> CGFloat {
		let message: NSMutableAttributedString = NSMutableAttributedString(string: toDraw)
		
		let fieldColor: UIColor = UIColor.black
		let fieldFont = UIFont(name: "Symbol", size: CGFloat(fontSize))
		let paraStyle = NSMutableParagraphStyle()
		paraStyle.alignment = NSTextAlignment.center
		
		let attributes: NSDictionary = [
			NSForegroundColorAttributeName: fieldColor,
			NSParagraphStyleAttributeName: paraStyle,
			NSFontAttributeName: fieldFont!
		]
		let countString = (message.length)
		message.addAttributes(attributes as! [String : AnyObject], range: NSRange(location: 0, length: countString) )
		let textHeight = self.heightWithConstrainedWidth(self.frame.width, font: fieldFont!, toGet: toDraw)
		message.draw(in: CGRect(x: x, y: y, width: width, height: textHeight))
		return textHeight
	}
	
	func drawTextWithBox(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, toDraw: String, fontSize: CGFloat) {
		let fieldFont = UIFont(name: "Symbol", size: CGFloat(fontSize))
		let textHeight = self.heightWithConstrainedWidth(self.frame.width, font: fieldFont!, toGet: toDraw)
		drawTextWithNoBox(0, y: (height - textHeight)/2, width: width, toDraw: toDraw, fontSize: fontSize)
	}
	
	func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, toGet: String) -> CGFloat {
		let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		
		let boundingBox = toGet.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
		
		return boundingBox.height
	}
	
}

