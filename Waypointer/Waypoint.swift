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
        self.line = Line(startingXPos: 1.0, startingYPos: 1.0, startingZPos: 1.0, endingXPos: 1.0, endingYPos: 1.0, endingZPos: 1.0)
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
        var yShift = 40/scaler
        if(x > classes.screenWidth && y - yShift > classes.screenHeight) {
            //Draw Down Left Arrow
            return
        } else if(x > classes.screenWidth && y - yShift < 0) {
            //Draw Up Left Arrow
            return
        } else if(x < 0 && y - yShift < 0) {
            //Draw Up Right Arrow
            return
        } else if(x < 0 && y - yShift > classes.screenHeight) {
            //Draw Down Right Arrow
            return
        } else if(x > classes.screenWidth) {
            //Draw Left Arrow
            return
        } else if(x < 0) {
            //Draw Right Arrow
            return
        } else if(y - yShift > classes.screenHeight) {
            drawDownArrow()
            return
        } else if(y - yShift < 0) {
            //Draw Up Arrow
            return
        }
        addPolygon()
        addOuterOval()
        addInnerOval()
        stringDraw = UILabel(frame: CGRect(x: CGFloat(xWidth - Double(count(name)) * 2.0), y: CGFloat(-10), width: 50, height: 20))
        stringDraw.text = name
        stringDraw.font = UIFont(name: "Times New Roman", size: CGFloat(6))
        self.addSubview(stringDraw)
        self.frame = CGRect(x: x  - xWidth / 2, y: y - circleDiameter - yShift, width: 50, height: 50)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
    }
    
    public func updatePersonPossition() {
        self.line = Line(startingXPos: classes.manage.personX, startingYPos: classes.manage.personY, startingZPos: classes.manage.personZ, endingXPos: line.end.xPos, endingYPos: line.end.yPos, endingZPos: line.end.zPos)
        drawRect(CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    public func updateDistance() {
        line = Line(startingXPos: classes.manage.personX, startingYPos: classes.manage.personY, startingZPos: classes.manage.personZ, endingXPos: line.end.xPos, endingYPos: line.end.yPos, endingZPos: line.end.zPos)
    }
    
    public func getScreenX() -> Double {
        var x = CGFloat(classes.startFromNorth)
        if let attitude = classes.motionManager.deviceMotion?.attitude {
            x = CGFloat(-attitude.pitch - classes.startFromNorth)
        }
        var horAngle = MyMath.getLineHorizontalAngle(line)
        horAngle = (horAngle + Double(x))
        horAngle = MyMath.findSmallestAngle(horAngle)
        var perInstanceIncrease = Double(classes.cameraAngle) * (classes.screenHeight / classes.screenWidth) / classes.screenWidth
        return (horAngle + classes.cameraAngle) * (classes.screenHeight / classes.screenWidth) / (perInstanceIncrease * 2)
    }
    
    public func getScreenY() -> Double {
        var y = CGFloat(0)
        if let attitude = classes.motionManager.deviceMotion?.attitude {
            y = CGFloat(-attitude.yaw)
        }
        var angles = classes.manage.screenXAngles
        var vertAngle = MyMath.getLineVerticalAngle(line)
        vertAngle = vertAngle + Double(y)
        vertAngle = MyMath.findSmallestAngle(vertAngle)
        var perInstanceIncrease = Double(classes.cameraAngle) / classes.screenHeight
        return classes.screenHeight - (vertAngle + classes.cameraAngle) / (perInstanceIncrease * 2)
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
        
        //for v in self.subviews {
        //    v.removeFromSuperview()
        //}
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
    
    func drawDownArrow() {
        var arrowHeight = 40 * scaler
        y = classes.screenHeight
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 1
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(0)))
        path.addLineToPoint(CGPointMake(CGFloat(-xWidth), CGFloat(-arrowHeight/3.0)))
        path.addLineToPoint(CGPointMake(CGFloat(-xWidth/2), CGFloat(-arrowHeight/3.0)))
        path.addLineToPoint(CGPointMake(CGFloat(-xWidth/2), CGFloat(-arrowHeight)))
        path.addLineToPoint(CGPointMake(CGFloat(xWidth/2), CGFloat(-arrowHeight)))
        path.addLineToPoint(CGPointMake(CGFloat(xWidth/2), CGFloat(-arrowHeight/3.0)))
        path.addLineToPoint(CGPointMake(CGFloat(-xWidth), CGFloat(-arrowHeight/3.0)))
        path.closePath()
        shape.path = path.CGPath
    }

    
    
}
