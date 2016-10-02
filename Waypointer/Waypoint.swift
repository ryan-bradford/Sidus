//
//  Waypoint.swift
//  Sidus
//
//  Created by Ryan on 4/20/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class Waypoint : UIView {
    
    //xWidth = xSize * 10/4
    //yWidth = ySize * 34/24

    open var line: Line?
    open var red, blue, green : Int?
    open var displayName: String?
    open var idName: String?
    open var added = false
    var stringDraw:UILabel?
    var xSize : Double?
    var ySize : Double?
    open var x : Double?
    open var y : Double?
    var scaler : Double?
    var circleDiameter : Double?
    open var orderNum: Int?
    var background: CAShapeLayer?
    var circle = CAShapeLayer()
    var rightArrowShape: CAShapeLayer?
    var leftArrowShape: CAShapeLayer?
    open var yShift: Double?
    var myID = arc4random()
    var cameraAngleX : Double?
    var cameraAngleY : Double?
    var myMath: MyMath?
    var manage: WaypointManager??
    var drawn = false
    
    public init(xPos : Double, yPos : Double, zPos : Double, red : Int, green : Int, blue : Int, displayName : String, cameraAngleX : Double, cameraAngleY: Double, manage : WaypointManager) {
        self.manage = manage
        self.red = red
        self.displayName = displayName
        self.idName = displayName
        if(idName == "y651") {
            self.displayName = "North"
        } else if(idName == "y652") {
            self.displayName = "South"
        } else if(idName == "y653") {
            self.displayName = "East"
        } else if(idName == "y654") {
            self.displayName = "West"
        }
        self.blue = blue
        self.green = green
        self.line = Line(startingXPos: (self.manage!?.personX)!, startingYPos: (self.manage!?.personY)!, startingZPos: (self.manage!?.personZ)!, endingXPos: xPos, endingYPos: yPos, endingZPos: zPos)
        self.cameraAngleX = cameraAngleX
        self.cameraAngleY = cameraAngleY
        myMath = MyMath()
        super.init(frame : CGRect(x: 0, y: 0, width: 20, height: 20))
        self.generateVars()
        self.drawText()
        self.initGraphics()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        if((x!.isNaN || y!.isNaN)) {
            return
        }
        if(yShift == nil) {
            return
        }
        if(x > classes.screenWidth) {
            stringDraw!.removeFromSuperview()
            drawRightArrow(yShift!)
            return
        } else if(x < 0) {
            stringDraw!.removeFromSuperview()
            drawLeftArrow(yShift!)
            return
        }
        drawBackground()
        drawCircle()
        self.addSubview(stringDraw!)
        updateText()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.frame = CGRect(x: x!, y: y! - yShift!, width: 50, height: 50)
    }
    
    open func updatePersonPossition() {
        self.line!.start.xPos = (self.manage!?.personX)!
        self.line!.start.yPos = (self.manage!?.personY)!
        self.line!.start.zPos = (self.manage!?.personZ)!
        //drawRect(CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    open func updateDistance() {
        line! = Line(startingXPos: (self.manage!?.personX)!, startingYPos: (self.manage!?.personY)!, startingZPos: (self.manage!?.personZ)!, endingXPos: line!.end.xPos, endingYPos: line!.end.yPos, endingZPos: line!.end.zPos)
    }
    
    open func getScreenX() -> Double {
        let x1 = CGFloat((self.manage!?.horAngle)! - myMath!.findSmallestAngle((manage!?.startFromNorth)!, currentFOV: cameraAngleX!) - cameraAngleX! / 2)
        var horAngle = line!.getLineHorizontalAngle()
        horAngle = (horAngle + Double(x1))
        horAngle = myMath!.findSmallestAngle(horAngle, currentFOV: cameraAngleX!)
        let perInstanceIncrease = Double(cameraAngleX!) / classes.screenWidth
        return (horAngle + cameraAngleX!) / (perInstanceIncrease)
    }
    
    open func getScreenY() -> Double {
        let y1 = CGFloat(-(self.manage!?.vertAngle)!)
        var vertAngle = line!.getLineVerticalAngle()
        vertAngle = vertAngle + Double(y1)
        vertAngle = myMath!.findSmallestAngle(vertAngle, currentFOV: cameraAngleY!)
        let perInstanceIncrease = Double(cameraAngleY!) / classes.screenHeight
        return (-vertAngle + cameraAngleY!) / (perInstanceIncrease)
    }
    
    open func getScreenScaller() -> Double {
        let length = line!.length
        let multiplier = 0.000005
        var scaler : Double
        scaler = 1 - (length * multiplier)
        if(scaler < 0.2) {
            scaler = 0.2
        }
        return scaler
    }
    
    //Different Graphic Stuff From Here Down
    
    open func generateVars() {
        checkForSpecial()
        x = getScreenX()
        y = getScreenY()
        scaler = getScreenScaller()
        xSize = (20 * scaler!)
        ySize = (70 * scaler!)
        circleDiameter = ((xSize! / 2.5))
    }
    
    func drawText() {
        stringDraw = UILabel(frame: CGRect(x: CGFloat(-Double(displayName!.characters.count) * 2.0), y: CGFloat(-ySize! - 17), width: 50, height: 20))
        stringDraw!.text = displayName
        stringDraw!.textColor = UIColor.green
        stringDraw!.font = UIFont(name: "Times New Roman", size: CGFloat(9))
        self.addSubview(stringDraw!)
    }
    
    func updateText() {
        stringDraw!.frame = CGRect(x: CGFloat(-Double(displayName!.characters.count) * 2.0), y: CGFloat(-ySize! - 17), width: 50, height: 20)
    }
    
    func initGraphics() {
        leftArrowShape = CAShapeLayer()
        leftArrowShape!.opacity = 1
        leftArrowShape!.lineWidth = 2
        leftArrowShape!.lineJoin = kCALineJoinMiter
        leftArrowShape!.fillColor = UIColor(red: CGFloat(Double(red!)/255.0), green: CGFloat(Double(green!)/255.0), blue: CGFloat(Double(blue!)/255.0), alpha: CGFloat(classes.waypointTransparency)).cgColor
        rightArrowShape = CAShapeLayer()
        rightArrowShape!.opacity = 1
        rightArrowShape!.lineWidth = 2
        rightArrowShape!.lineJoin = kCALineJoinMiter
        rightArrowShape!.fillColor = UIColor(red: CGFloat(Double(red!)/255.0), green: CGFloat(Double(green!)/255.0), blue: CGFloat(Double(blue!)/255.0), alpha: CGFloat(classes.waypointTransparency)).cgColor
        background = CAShapeLayer()
        background!.opacity = 1
        background!.lineJoin = kCALineJoinMiter
        background!.strokeColor = UIColor.black.cgColor
        background!.lineWidth = 1
        background!.fillColor = UIColor(red: CGFloat(Double(red!)/255.0), green: CGFloat(Double(green!)/255.0), blue: CGFloat(Double(blue!)/255.0), alpha: CGFloat(classes.waypointTransparency)).cgColor
        circle = CAShapeLayer()
        circle.opacity = 1
        circle.lineWidth = 1
        circle.strokeColor = UIColor.black.cgColor
        circle.lineJoin = kCALineJoinMiter
        circle.fillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(classes.waypointTransparency)).cgColor
    }
    
    func drawLeftArrow(_ yShift : Double) {
        x = 0
        let arrowWidth = 80 * scaler!
        let arrowHeight = ySize!/3
        let middleWidth = 10.0
        self.layer.addSublayer(leftArrowShape!)
        rightArrowShape!.removeFromSuperlayer()
        background!.removeFromSuperlayer()
        circle.removeFromSuperlayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(0), y: CGFloat(0)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(arrowHeight)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth), y: CGFloat(middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth), y: CGFloat(-middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(-middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(-arrowHeight)))
        path.close()
        leftArrowShape!.path = path.cgPath
        self.frame = CGRect(x: x!, y: y! - yShift, width: 50, height: 50)
    }
    
    func drawRightArrow(_ yShift : Double) {
        x = classes.screenWidth
        let arrowWidth = -80 * scaler!
        let arrowHeight = ySize!/3
        let middleWidth = 10.0
        self.layer.addSublayer(rightArrowShape!)
        leftArrowShape!.removeFromSuperlayer()
        background!.removeFromSuperlayer()
        circle.removeFromSuperlayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(0), y: CGFloat(0)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(arrowHeight)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth), y: CGFloat(middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth), y: CGFloat(-middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(-middleWidth * scaler!)))
        path.addLine(to: CGPoint(x: CGFloat(arrowWidth/3), y: CGFloat(-arrowHeight)))
        path.close()
        rightArrowShape!.path = path.cgPath
        self.frame = CGRect(x: x!, y: y! - yShift, width: 50, height: 50)
    }
    
    open func drawBackground() {
        self.layer.addSublayer(background!)
        rightArrowShape!.removeFromSuperlayer()
        leftArrowShape!.removeFromSuperlayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(0), y: CGFloat(0)))
        path.addLine(to: CGPoint(x: CGFloat(xSize!/2), y: CGFloat(-ySize! * 13/24)))
        path.addLine(to: CGPoint(x: CGFloat(xSize! * 5 / 4), y: CGFloat(-ySize! * 15/24)))
        path.addLine(to: CGPoint(x: CGFloat(xSize!/2), y: CGFloat(-ySize! * 17/24)))
        path.addLine(to: CGPoint(x: CGFloat(0), y: CGFloat(-ySize!)))
        path.addLine(to: CGPoint(x: CGFloat(-xSize!/2), y: CGFloat(-ySize! * 17/24)))
        path.addLine(to: CGPoint(x: CGFloat(-xSize! * 5 / 4), y: CGFloat(-ySize! * 15/24)))
        path.addLine(to: CGPoint(x: CGFloat(-xSize!/2), y: CGFloat(-ySize! * 13/24)))
        path.close()
        background!.path = path.cgPath
    }
    
    func drawCircle() {
        self.layer.addSublayer(circle)
        rightArrowShape!.removeFromSuperlayer()
        leftArrowShape!.removeFromSuperlayer()
        let one = CGFloat(-circleDiameter!/2)
        let twoFirst = CGFloat(-ySize! * 16/24)
        let twoSecond = CGFloat(-circleDiameter!/2)
        let two = twoFirst + twoSecond
        let box = CGRect(x: one, y: two, width: CGFloat(circleDiameter!), height: CGFloat(circleDiameter!))
        let ovalPath = UIBezierPath(ovalIn : box)
        ovalPath.close()
        circle.path = ovalPath.cgPath
    }
    
    func checkForSpecial() {
        if(idName == "y651") {
            line!.end = Point3D(xPos1: (manage!?.personX)!, yPos1: (manage!?.personY)! + 0.00000001, zPos1: (manage!?.personZ)!)
        } else if(idName == "y652") {
            line!.end = Point3D(xPos1: (manage!?.personX)!, yPos1: (manage!?.personY)! - 0.00000001, zPos1: (manage!?.personZ)!)
        } else if(idName == "y653") {
            line!.end = Point3D(xPos1: (manage!?.personX)! + 0.00000001, yPos1: (manage!?.personY)!, zPos1: (manage!?.personZ)!)
        } else if(idName == "y654") {
            line!.end = Point3D(xPos1: (manage!?.personX)! - 0.00000001, yPos1: (manage!?.personY)!, zPos1: (manage!?.personZ)!)
        }
    }
    
}
