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
    
    //xWidth = xSize * 10/4
    //yWidth = ySize * 34/24
    
    public var line  = Line(startingXPos: 1.0, startingYPos: 1.0, startingZPos: 1.0, endingXPos: 1.0, endingYPos: 1.0, endingZPos: 1.0)
    public var red = 0, blue = 0, green = 0
    public var name = ""
    public var added = false
    var stringDraw = UILabel()
    var xSize : Double = 0.0
    var ySize : Double = 0.0
    public var x : Double = 0.0
    public var y : Double = 0.0
    var scaler : Double = 0.0
    var circleDiameter : Double = 0.0
    public var orderNum = 0
    var background = CAShapeLayer()
    var circle = CAShapeLayer()
    var rightArrowShape = CAShapeLayer()
    var leftArrowShape = CAShapeLayer()
    public var yShift = 0.0
    var myID = random()
    var cameraAngle : Double
    var myMath : MyMath
    var manage : WaypointManager
    
    public init(xPos : Double, yPos : Double, zPos : Double, red : Int, green : Int, blue : Int, name : String, cameraAngle : Double, manage : WaypointManager) {
        self.manage = manage
        self.red = red
        self.name = name
        self.blue = blue
        self.green = green
        self.line = Line(startingXPos: self.manage.personX, startingYPos: self.manage.personY, startingZPos: self.manage.personZ, endingXPos: xPos, endingYPos: yPos, endingZPos: zPos)
        self.cameraAngle = cameraAngle
        myMath = MyMath(cameraAngle: cameraAngle)
        super.init(frame : CGRect(x: 0, y: 0, width: 20, height: 20))
        self.drawText()
        self.initGraphics()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.cameraAngle = 1.0
        myMath = MyMath(cameraAngle: cameraAngle)
        manage = WaypointManager(x: 0.0, y: 0.0, z: 0.0, cameraAngle: 1.0, groups: Array<WaypointGroup>(), startFromNorth: 0.0)
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        if(x > classes.screenWidth) {
            stringDraw.removeFromSuperview()
            drawRightArrow(yShift)
            return
        } else if(x < 0) {
            stringDraw.removeFromSuperview()
            drawLeftArrow(yShift)
            return
        }
        drawBackground()
        drawCircle()
        self.addSubview(stringDraw)
        updateText()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.frame = CGRect(x: x, y: y - yShift, width: 50, height: 50)
    }
    
    public func updatePersonPossition() {
        self.line.start.xPos = self.manage.personX
        self.line.start.yPos = self.manage.personY
        self.line.start.zPos = self.manage.personZ
        //drawRect(CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    public func updateDistance() {
        line = Line(startingXPos: self.manage.personX, startingYPos: self.manage.personY, startingZPos: self.manage.personZ, endingXPos: line.end.xPos, endingYPos: line.end.yPos, endingZPos: line.end.zPos)
    }
    
    public func getScreenX() -> Double {
        let x1 = CGFloat(self.manage.horAngle - myMath.findSmallestAngle(manage.startFromNorth))
        let realFOV = cameraAngle * (classes.screenWidth / classes.screenHeight)
        var horAngle = line.getLineHorizontalAngle()
        horAngle = (horAngle + Double(x1))
        horAngle = myMath.findSmallestAngle(horAngle)
        let perInstanceIncrease = Double(cameraAngle) * (classes.screenWidth / classes.screenHeight) / classes.screenWidth
        return (horAngle + realFOV) / (perInstanceIncrease)
    }
    
    public func getScreenY() -> Double {
        let y1 = CGFloat(-self.manage.vertAngle)
        var vertAngle = line.getLineVerticalAngle()
        vertAngle = vertAngle + Double(y1)
        vertAngle = myMath.findSmallestAngle(vertAngle)
        let perInstanceIncrease = Double(cameraAngle) / classes.screenHeight
        return (-vertAngle + cameraAngle) / (perInstanceIncrease)
    }
    
    public func getScreenScaller() -> Double {
        let length = line.length
        let multiplier = 0.000005
        var scaler : Double
        scaler = 1 - (length * multiplier)
        if(scaler < 0.2) {
            scaler = 0.2
        }
        return scaler
    }
    
    //Different Graphic Stuff From Here Down
    
    public func generateVars() {
        x = getScreenX()
        y = getScreenY()
        scaler = getScreenScaller()
        xSize = (20 * scaler)
        ySize = (70 * scaler)
        circleDiameter = ((xSize / 2.5))
    }
    
    func drawText() {
        stringDraw = UILabel(frame: CGRect(x: CGFloat(-Double(name.characters.count) * 2.0), y: CGFloat(-ySize - 17), width: 50, height: 20))
        stringDraw.text = name
        stringDraw.textColor = UIColor.greenColor()
        stringDraw.font = UIFont(name: "Times New Roman", size: CGFloat(9))
        self.addSubview(stringDraw)
    }
    
    func updateText() {
        stringDraw.frame = CGRect(x: CGFloat(-Double(name.characters.count) * 2.0), y: CGFloat(-ySize - 17), width: 50, height: 20)
    }
    
    func initGraphics() {
        leftArrowShape = CAShapeLayer()
        leftArrowShape.opacity = 1
        leftArrowShape.lineWidth = 2
        leftArrowShape.lineJoin = kCALineJoinMiter
        leftArrowShape.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        rightArrowShape = CAShapeLayer()
        rightArrowShape.opacity = 1
        rightArrowShape.lineWidth = 2
        rightArrowShape.lineJoin = kCALineJoinMiter
        rightArrowShape.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        background = CAShapeLayer()
        background.opacity = 1
        background.lineJoin = kCALineJoinMiter
        background.strokeColor = UIColor.blackColor().CGColor
        background.lineWidth = 1
        background.fillColor = UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(classes.waypointTransparency)).CGColor
        circle = CAShapeLayer()
        circle.opacity = 1
        circle.lineWidth = 1
        circle.strokeColor = UIColor.blackColor().CGColor
        circle.lineJoin = kCALineJoinMiter
        circle.fillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(classes.waypointTransparency)).CGColor
    }
    
    func drawLeftArrow(yShift : Double) {
        x = 0
        let arrowWidth = 80 * scaler
        let arrowHeight = ySize/3
        let middleWidth = 10.0
        self.layer.addSublayer(leftArrowShape)
        rightArrowShape.removeFromSuperlayer()
        background.removeFromSuperlayer()
        circle.removeFromSuperlayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(0)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(arrowHeight)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-arrowHeight)))
        path.closePath()
        leftArrowShape.path = path.CGPath
        self.frame = CGRect(x: x, y: y - yShift, width: 50, height: 50)
    }
    
    func drawRightArrow(yShift : Double) {
        x = classes.screenWidth
        let arrowWidth = -80 * scaler
        let arrowHeight = ySize/3
        let middleWidth = 10.0
        self.layer.addSublayer(rightArrowShape)
        leftArrowShape.removeFromSuperlayer()
        background.removeFromSuperlayer()
        circle.removeFromSuperlayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(0)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(arrowHeight)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-middleWidth * scaler)))
        path.addLineToPoint(CGPointMake(CGFloat(arrowWidth/3), CGFloat(-arrowHeight)))
        path.closePath()
        rightArrowShape.path = path.CGPath
        self.frame = CGRect(x: x, y: y - yShift, width: 50, height: 50)
    }
    
    public func drawBackground() {
        self.layer.addSublayer(background)
        rightArrowShape.removeFromSuperlayer()
        leftArrowShape.removeFromSuperlayer()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGFloat(0), CGFloat(0)))
        path.addLineToPoint(CGPointMake(CGFloat(xSize/2), CGFloat(-ySize * 13/24)))
        path.addLineToPoint(CGPointMake(CGFloat(xSize * 5 / 4), CGFloat(-ySize * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(xSize/2), CGFloat(-ySize * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(0), CGFloat(-ySize)))
        path.addLineToPoint(CGPointMake(CGFloat(-xSize/2), CGFloat(-ySize * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(-xSize * 5 / 4), CGFloat(-ySize * 17/24)))
        path.addLineToPoint(CGPointMake(CGFloat(-xSize/2), CGFloat(-ySize * 13/24)))
        path.closePath()
        background.path = path.CGPath
    }
    
    func drawCircle() {
        self.layer.addSublayer(circle)
        rightArrowShape.removeFromSuperlayer()
        leftArrowShape.removeFromSuperlayer()
        let one = CGFloat(-circleDiameter/2)
        let twoFirst = CGFloat(-ySize * 16/24)
        let twoSecond = CGFloat(-circleDiameter/2)
        let two = twoFirst + twoSecond
        let box = CGRectMake(one, two, CGFloat(circleDiameter), CGFloat(circleDiameter))
        let ovalPath = UIBezierPath(ovalInRect : box)
        ovalPath.closePath()
        circle.path = ovalPath.CGPath
    }
    
}
