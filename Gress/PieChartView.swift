//
//  PieChartView.swift
//  Gress
//
//  Created by Umar Qattan on 9/2/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//


/**
    PROBLEM:  Needed to install several statistics frameworks to get
              a simple pie chart, but they continued to fail.
    SOLUTION: Created a Pie Chart using Core Graphics (CG) where each
              color on the pie chart corresponds to the distribution 
              of a particular macronutrient.
**/

import Foundation
import UIKit

let fullCircle = 2.0 * CGFloat(M_PI)

class PieChartView : UIView {

    var fatEndArc:CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var carbohydrateEndArc:CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var proteinEndArc:CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fatStart:CGFloat!
    var fatEnd:CGFloat!
    var fatLabel = UILabel(frame: CGRectZero)
    
    var carbohydrateStart:CGFloat!
    var carbohydrateEnd:CGFloat!
    var carbohydrateLabel = UILabel(frame: CGRectZero)
    
    var proteinStart:CGFloat!
    var proteinEnd:CGFloat!
    var proteinLabel = UILabel(frame: CGRectZero)
    
    override func drawRect(rect: CGRect) {
        
        var centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        var radius:CGFloat = {
            var width = CGRectGetWidth(rect)
            var height = CGRectGetHeight(rect)
            if width > height {
                return height/2.0
            } else {
                return width/2.0
            }
        }()
        var arcWidth:CGFloat = 10.0
        var fatArcColor = UIColor.redColor()
        var carbohydrateArcColor = UIColor.blueColor()
        var proteinArcColor = UIColor.greenColor()
        
        fatStart = 0.25 * fullCircle
        fatEnd = fatStart + fatEndArc
        carbohydrateStart = fatEnd
        carbohydrateEnd = carbohydrateStart + carbohydrateEndArc
        proteinStart = carbohydrateEnd
        proteinEnd = proteinStart + proteinEndArc
        

        /**
            Core Graphics Context
        **/
        
        /**
            TODO: Fix sector angles so that labels are centered in pie chart
        **/
        
        let context = UIGraphicsGetCurrentContext()
        let colorspace = CGColorSpaceCreateDeviceRGB()
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, kCGLineCapRound)
        
        /**
            Fat Sector
        **/
        
        
        CGContextSetFillColorWithColor(context, fatArcColor.CGColor)
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, fatStart, fatEnd, 0)
        CGContextFillPath(context)
        var fatHalfAngle:CGFloat = (fatEnd-fatStart)/2.0 + fatStart
        var fatX:CGFloat = radius * cos(fatHalfAngle * 180/CGFloat(M_PI) )
        var fatY:CGFloat = radius * sin(fatHalfAngle * 180/CGFloat(M_PI))
        var fatCenterPoint:CGPoint = CGPointMake(centerPoint.x + fatX, centerPoint.y + fatY/2)
        fatLabel = UILabel(frame: CGRectMake(fatCenterPoint.x, fatCenterPoint.y, 35, 35))
        
        addSubview(fatLabel)
        /**
            Carbohydrate Sector
        **/
        
        CGContextSetFillColorWithColor(context, carbohydrateArcColor.CGColor)
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, carbohydrateStart, carbohydrateEnd, 0)
        CGContextFillPath(context)
        
        var carbohydrateHalfAngle:CGFloat = (carbohydrateEnd-carbohydrateStart)/2.0 + carbohydrateStart
        println("fat Angle: \(fatEnd) \n carb angle: \(carbohydrateEnd)")
        var carbohydrateX:CGFloat = radius * cos(carbohydrateHalfAngle * 180/CGFloat(M_PI) )
        var carbohydrateY:CGFloat = radius * sin(carbohydrateHalfAngle * 180/CGFloat(M_PI))
        var carbohydrateCenterPoint:CGPoint = CGPointMake(centerPoint.x + carbohydrateX, centerPoint.y + carbohydrateY/2)

        carbohydrateLabel = UILabel(frame: CGRectMake(carbohydrateCenterPoint.x, carbohydrateCenterPoint.y, 35, 35))
        
        addSubview(carbohydrateLabel)
        
        
        /**
            Protein Sector
        **/
        
        CGContextSetFillColorWithColor(context, proteinArcColor.CGColor)
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, proteinStart, proteinEnd, 0)
        CGContextFillPath(context)
        
        var proteinHalfAngle:CGFloat = (proteinEnd-proteinStart)/2.0 + proteinStart
        var proteinX:CGFloat = radius * cos(proteinHalfAngle * 180/CGFloat(M_PI) )
        var proteinY:CGFloat = radius * sin(proteinHalfAngle * 180/CGFloat(M_PI))
        var proteinCenterPoint:CGPoint = CGPointMake(centerPoint.x + proteinX, centerPoint.y + proteinY/2)
        
        proteinLabel = UILabel(frame: CGRectMake(proteinCenterPoint.x, fatCenterPoint.y, 35, 35))
        
        addSubview(proteinLabel)
        
        
        
    }
}