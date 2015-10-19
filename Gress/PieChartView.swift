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
let font = UIFont(name: "HelveticaNeue-Light", size: 10.0)!

class PieChartView : UIView {

    var fatEndArc:CGFloat = 0.0
    
    var carbohydrateEndArc:CGFloat = 0.0
    
    var proteinEndArc:CGFloat = 0.0
    var fatStart:CGFloat!
    var fatEnd:CGFloat!
    var fatLabel = UILabel(frame: CGRectZero)
    var fatPercent:CGFloat = 15.0
    
    var carbohydrateStart:CGFloat!
    var carbohydrateEnd:CGFloat!
    var carbohydrateLabel = UILabel(frame: CGRectZero)
    var carbohydratePercent:CGFloat = 65.0
    
    var proteinStart:CGFloat!
    var proteinEnd:CGFloat!
    var proteinLabel = UILabel(frame: CGRectZero)
    var proteinPercent:CGFloat = 20.0
    
    override func drawRect(rect: CGRect) {
    
        
        
        let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        let radius:CGFloat = {
            let width = CGRectGetWidth(rect)
            let height = CGRectGetHeight(rect)
            if width > height {
                return height/2.0
            } else {
                return width/2.0
            }
        }()
        let arcWidth:CGFloat = 10.0
        let fatArcColor = UIColor.redColor()
        let carbohydrateArcColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let proteinArcColor = UIColor.greenColor()
        
        fatStart = 0.25 * fullCircle
        fatEnd = fatStart + fatEndArc
        
        carbohydrateStart = fatEnd
        carbohydrateEnd = carbohydrateStart + carbohydrateEndArc
        proteinStart = carbohydrateEnd
        proteinEnd = proteinStart + proteinEndArc
        
        /**
            MARK:   Core Graphics Context
            TODO:   Fix sector angles so that labels are centered in pie chart
            SOLVED: Use dispatch_async(dispatch_get_main_queue) { update }
        **/
        
        let context = UIGraphicsGetCurrentContext()
        //let colorspace = CGColorSpaceCreateDeviceRGB()
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        
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