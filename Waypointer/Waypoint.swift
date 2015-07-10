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
        super.init(frame : CGRect(x: 0, y: 0, width: 20, height: 20))
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        generateVars()
        removeAllGraphics()
        var yShift = 20/scaler
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
        drawBackground()
        drawCircle()
        //addPolygon()
        //addOuterOval()
        //addInnerOval()
        drawText()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.frame = CGRect(x: x, y: y, width: 50, height: 50)
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
        circleDiameter = ((xWidth / 2.5))
    }
    
    func drawText() {
        stringDraw = UILabel(frame: CGRect(x: CGFloat(-Double(count(name)) * 1.7), y: CGFloat(-yWidth - 17), width: 50, height: 20))
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
    
    func drawBackground() {
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor.blackColor().CGColor
        shape.lineWidth = 1
        shape.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(0)))
        path.addLineToPoint(CGPointMake(CGFloat(xWidth/2), CGFloat(-yWidth * 13/24)))
        path.addLineToPoint(CGPointMake(CGFloat(xWidth * 5 / 4), CGFloat(-yWidth * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(xWidth/2), CGFloat(-yWidth * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(0), CGFloat(-yWidth)))
        path.addLineToPoint(CGPointMake(CGFloat(-xWidth/2), CGFloat(-yWidth * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(-xWidth * 5 / 4), CGFloat(-yWidth * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(-xWidth/2), CGFloat(-yWidth * 13/24)))
        path.closePath()
        shape.path = path.CGPath
    }
    
    func drawCircle() {
        let circle = CAShapeLayer() //Draw Outer Oval
        self.layer.addSublayer(circle)
        circle.opacity = 1
        circle.lineWidth = 1
        circle.strokeColor = UIColor.blackColor().CGColor
        circle.lineJoin = kCALineJoinMiter
        circle.fillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(classes.waypointTransparency)).CGColor
        var ovalPath = UIBezierPath(ovalInRect: CGRectMake(CGFloat(-circleDiameter/2), CGFloat(-yWidth * 16/24 - circleDiameter/2), CGFloat(circleDiameter), CGFloat(circleDiameter)))
        ovalPath.closePath()
        circle.path = ovalPath.CGPath
    }
    
}
