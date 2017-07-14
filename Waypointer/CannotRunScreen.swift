//
//  VerifyButton.swift
//  waypointr
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

open class CannotRunScreen : UIView {
    
    var redVal = 1.0
    var blueVal = 0.0
    var alphaVal = 0.6
    var message: String?
    
    public init(message: String) { //TO STUDY
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat(classes.screenWidth), height: CGFloat(classes.screenHeight)))
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: 0.0, blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
        self.message = message
    }
    
    override open func draw(_ rect: CGRect) {
        drawMessage("The Application Could Not Launch" + "\n" + message!, X: 0, Y: CGFloat(classes.screenHeight / 2.0) - 30.0)
        
    }
    
    func drawMessage(_ message : String, X : CGFloat, Y : CGFloat) {
        
        let _ = drawTextWithNoBox(X, y: Y, width: CGFloat(classes.screenWidth), toDraw: message, fontSize: 25)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawTextWithNoBox(_ x: CGFloat, y: CGFloat, width: CGFloat, toDraw: String, fontSize: CGFloat) -> CGFloat {
        let message: NSMutableAttributedString = NSMutableAttributedString(string: toDraw)
        
        let fieldColor: UIColor = UIColor.black
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(fontSize))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.center
        
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSFontAttributeName: fieldFont!
        ]
        let countString = (message.length)
        message.addAttributes(attributes as! [String : AnyObject], range: NSRange(location: 0, length: countString) )
        let textHeight = self.heightWithConstrainedWidth(self.frame.width, font: UIFont.boldSystemFont(ofSize: 25), toGet: toDraw)
        message.draw(in: CGRect(x: x, y: y, width: width, height: textHeight))
        return textHeight
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, toGet: String) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = toGet.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
}
