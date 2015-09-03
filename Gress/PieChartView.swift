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
    
    var carbohydrateStart:CGFloat!
    var carbohydrateEnd:CGFloat!
    
    var proteinStart:CGFloat!
    var proteinEnd:CGFloat!

    override func drawRect(rect: CGRect) {
        
        
        var arcWidth:CGFloat = 10.0
        var fatArcColor = UIColor.redColor()
        var carbohydrateArcColor = UIColor.blueColor()
        var proteinArcColor = UIColor.greenColor()
        fatStart = -0.25 * fullCircle
        fatEnd = fatStart + fatEndArc
        carbohydrateStart = fatEnd
        carbohydrateEnd = carbohydrateStart + carbohydrateEndArc
        proteinStart = carbohydrateEnd
        proteinEnd = proteinStart + proteinEndArc
        
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
        
        /**
            Carbohydrate Sector
        **/
        
        CGContextSetFillColorWithColor(context, carbohydrateArcColor.CGColor)
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, carbohydrateStart, carbohydrateEnd, 0)
        CGContextFillPath(context)
        
        /**
            Protein Sector
        **/
        
        CGContextSetFillColorWithColor(context, proteinArcColor.CGColor)
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, proteinStart, proteinEnd, 0)
        CGContextFillPath(context)
        
    }
}