//
//  VerifyButton.swift
//  Sidus
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit

public class CannotRunScreen : UIView {
    
    var redVal = 1.0
    var blueVal = 0.0
    var alphaVal = 0.6
    
    public init() { //TO STUDY
        super.init(frame: CGRectMake(0, 0, CGFloat(classes.screenWidth), CGFloat(classes.screenHeight)))
        self.backgroundColor = UIColor(red: CGFloat(redVal), green: 0.0, blue: CGFloat(blueVal), alpha: CGFloat(alphaVal))
    }
    
    override public func drawRect(rect: CGRect) {
        drawMessage("The Application Could Not Launch", X: 0, Y: CGFloat(classes.screenHeight / 2.0) - 30.0)
        
    }
    
    func drawMessage(message : String, X : CGFloat, Y : CGFloat) {
        
        drawTextWithNoBox(X, y: Y, width: CGFloat(classes.screenWidth), toDraw: message, fontSize: 25)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawTextWithNoBox(x: CGFloat, y: CGFloat, width: CGFloat, toDraw: String, fontSize: CGFloat) -> CGFloat {
        let message: NSMutableAttributedString = NSMutableAttributedString(string: toDraw)
        
        let fieldColor: UIColor = UIColor.blackColor()
        let fieldFont = UIFont(name: "Helvetica Neue", size: CGFloat(fontSize))
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.Center
        
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSFontAttributeName: fieldFont!
        ]
        let countString = (message.length)
        message.addAttributes(attributes as! [String : AnyObject], range: NSRange(location: 0, length: countString) )
        let textHeight = self.heightWithConstrainedWidth(self.frame.width, font: UIFont.boldSystemFontOfSize(25), toGet: toDraw)
        message.drawInRect(CGRectMake(x, y, width, textHeight))
        return textHeight
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont, toGet: String) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = toGet.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
}
