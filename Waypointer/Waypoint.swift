//
//  Waypoint.swift
//  Waypointer
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

public class Waypoint : UIView {
    
    public var line  = Line(startingXPos: 1.0, startingYPos: 1.0, startingZPos: 1.0, endingXPos: 1.0, endingYPos: 1.0, endingZPos: 1.0)
    public var red = 0, blue = 0, green = 0
    public var name = ""
    public var added = false
    var stringDraw = UILabel()
    var xWidth : Double = 0.0
    var yWidth : Double = 0.0
    var x : Double = 0.0
    var y : Double = 0.0
    var scaler : Double = 0.0
    var circleDiameter : Double = 0.0
    
    required public init(xPos : Double, yPos : Double, zPos : Double, red : Int, green : Int, blue : Int, name : String) {
        self.red = red
        self.name = name
        self.blue = blue
        self.green = green
        stringDraw = UILabel()
        self.line = Line(startingXPos: classes.manage.personX, startingYPos: classes.manage.personY, startingZPos: classes.manage.personZ, endingXPos: xPos, endingYPos: yPos, endingZPos: zPos)
        println(self.line.getXLength())
        println(self.line.getYLength())
        super.init(frame : CGRect(x: 0, y: 0, width: 20, height: 20))
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        generateVars()
        removeAllGraphics()
        var yShift = 40/scaler
        if(x > classes.screenWidth && y - yShift > classes.screenHeight) {
            return
        } else if(x > classes.screenWidth && y - yShift < 0) {
            return
        } else if(x < 0 && y - yShift < 0) {
            return
        } else if(x < 0 && y - yShift > classes.screenHeight) {
            return
        } else if(x > classes.screenWidth) {
            removeAllGraphics()
            drawRightArrow(yShift)
            return
        } else if(x < 0) {
            removeAllGraphics()
            drawLeftArrow(yShift)
            return
        } else if(y - yShift > classes.screenHeight) {
            return
        } else if(y - yShift < 0) {
            return
        }
        addPolygon()
        addOuterOval()
        addInnerOval()
        drawText()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.frame = CGRect(x: x  - xWidth / 2, y: y - circleDiameter - yShift, width: 50, height: 50)
    }
    
    public func updatePersonPossition() {
        self.line = Line(startingXPos: classes.manage.personX, startingYPos: classes.manage.personY, startingZPos: classes.manage.personZ, endingXPos: line.end.xPos, endingYPos: line.end.yPos, endingZPos: line.end.zPos)
        drawRect(CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    public func updateDistance() {
        line = Line(startingXPos: classes.manage.personX, startingYPos: classes.manage.personY, startingZPos: classes.manage.personZ, endingXPos: line.end.xPos, endingYPos: line.end.yPos, endingZPos: line.end.zPos)
    }
    
    public func getScreenX() -> Double {
        var x1 = CGFloat(classes.manage.horAngle - MyMath.findSmallestAngle(classes.startFromNorth))
        var realAngle = classes.cameraAngle * (classes.screenWidth / classes.screenHeight)
        var horAngle = line.getLineHorizontalAngle()
        horAngle = (horAngle + Double(x1))
        horAngle = MyMath.findSmallestAngle(horAngle)
        var perInstanceIncrease = Double(classes.cameraAngle) * (classes.screenWidth / classes.screenHeight) / classes.screenWidth
        return (horAngle + realAngle) / (perInstanceIncrease)
    }
    
    public func getScreenY() -> Double {
        var y1 = CGFloat(-classes.manage.vertAngle)
        var vertAngle = line.getLineVerticalAngle()
        vertAngle = vertAngle + Double(y1)
        vertAngle = MyMath.findSmallestAngle(vertAngle)
        var perInstanceIncrease = Double(classes.cameraAngle) / classes.screenHeight
        return (-vertAngle + classes.cameraAngle) / (perInstanceIncrease)
    }
    
    public func getScreenScaller() -> Double {
        var length = line.length
        var multiplier = 0.0005
        var scaler : Double
        scaler = 1 - (length * multiplier)
        if(scaler < 0.3) {
            scaler = 1 - (length * 0.0001) - 0.24
        }
        if(scaler < 0.1) {
            scaler = 0.1
        }
        return scaler / 1.5
    }
    
    //Different Graphic Stuff From Here Down
    
    func removeAllGraphics() {
        if(self.layer.sublayers != nil) {
            for v in self.layer.sublayers {
                v.removeFromSuperlayer()
            }
        }
    }
    
    func generateVars() {
        x = getScreenX()
        y = getScreenY()
        scaler = getScreenScaller()
        xWidth = (20 * scaler)
        yWidth = (70 * scaler)
        circleDiameter = ((xWidth * 2))
    }
    
    func addPolygon() {
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(circleDiameter)))
        path.addLineToPoint(CGPointMake(CGFloat(xWidth), CGFloat(circleDiameter + yWidth)))
        path.addLineToPoint(CGPointMake(CGFloat(xWidth * 2), CGFloat(circleDiameter)))
        path.closePath()
        shape.path = path.CGPath
    }
    
    func addOuterOval() {
        let circle = CAShapeLayer() //Draw Outer Oval
        self.layer.addSublayer(circle)
        circle.opacity = 1
        circle.lineWidth = 2
        circle.lineJoin = kCALineJoinMiter
        circle.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        var ovalPath = UIBezierPath(ovalInRect: CGRectMake(CGFloat(0), CGFloat((((circleDiameter / 2)))), CGFloat(circleDiameter), CGFloat(circleDiameter)))
        ovalPath.closePath()
        circle.path = ovalPath.CGPath
    }
    
    func addInnerOval() {
        let frontCircle = CAShapeLayer() //Draw Inner Oval
        self.layer.addSublayer(frontCircle)
        frontCircle.opacity = 1
        frontCircle.lineWidth = 2
        frontCircle.lineJoin = kCALineJoinMiter
        frontCircle.fillColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0)).CGColor
        var newOvalPath = UIBezierPath(ovalInRect: CGRectMake(CGFloat(circleDiameter / 4), CGFloat(circleDiameter * 3 / 4), CGFloat(circleDiameter / 2), CGFloat(circleDiameter / 2)))
        newOvalPath.closePath()
        frontCircle.path = newOvalPath.CGPath
    }
    
    func drawText() {
        //let text = name as NSString
        /*
        var toAdd = UILabel()
        let font = UIFont(name: "Times New Roman", size: CGFloat(6))
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        if let actualFont = font {
            let textFontAttributes = [
                NSFontAttributeName: actualFont,
                NSParagraphStyleAttributeName: textStyle
            ]
            
            text.drawAtPoint(CGPoint(x: CGFloat(xWidth - Double(count(name)) * 1.7) + 2, y: CGFloat(4.0 * scaler)), withAttributes: textFontAttributes)
        }
        */
        stringDraw = UILabel(frame: CGRect(x: CGFloat(xWidth - Double(count(name)) * 2.0), y: CGFloat(-10), width: 50, height: 20))
        stringDraw.text = name
        stringDraw.font = UIFont(name: "Times New Roman", size: CGFloat(6))
        self.addSubview(stringDraw)
    }
    
    func drawLeftArrow(yShift : Double) {
        x = 0
        var arrowWidth = 80 * scaler
        var arrowHeight = yWidth/3
        var middleWidth = 10.0
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(0)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(arrowHeight)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-arrowHeight)))
        path.closePath()
        shape.path = path.CGPath
        self.frame = CGRect(x: x, y: y - yShift, width: 50, height: 50)
    }
    
    func drawRightArrow(yShift : Double) {
        x = classes.screenWidth
        var arrowWidth = -80 * scaler
        var arrowHeight = yWidth/3
        var middleWidth = 10.0
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(0)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(arrowHeight)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-arrowHeight)))
        path.closePath()
        shape.path = path.CGPath
        self.frame = CGRect(x: x, y: y - yShift, width: 50, height: 50)
    }
    
}
