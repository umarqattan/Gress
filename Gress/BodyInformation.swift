//
//  BodyInformation.swift
//  Gress
//
//  Created by Umar Qattan on 8/15/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit

/**
    MARK: methods that convert from SI to Metric
          and vice versa
**/

let CENTIMETERS_TO_INCHES = 0.393701 as Float
let INCHES_TO_CENTIMETERS = 2.54 as Float
let FEET_TO_INCHES = 12 as Float
let POUNDS_TO_KILOGRAMS = 0.453592 as Float
let KILOGRAMS_TO_POUNDS = 2.20462 as Float
let SI = 0
let METRIC = 1

class BodyInformation {
    
    var age: String!
    
    var heightMetric:String!
    var heightSI:String!
    var weightMetric:String!
    var weightSI:String!
    
    
    var rawCentimeters:String!
    var rawFeet:String!
    var rawInches:String!
    
    var rawPounds:String!
    var rawKilograms:String!
    
    
    
    init(age: String?, height:String?, weight: String?, unit:Int) {
        
        if let anAge = age {
            self.age = anAge
        }
        
        if let aHeight = height {
        
            switch unit {
            case SI:
                println("initializing from SI units")
                var feet = getFeetFromText(aHeight)
                var inches = getInchesFromText(aHeight)
                var metricHeightArray = SIToMetricHeight(feet, inches: inches)
                rawCentimeters = metricHeightArray[1]
                rawFeet = feet
                rawInches = inches
                heightSI = formatHeightSIString(rawFeet, inches: rawInches)
                heightMetric = formatHeightMetricString(rawCentimeters)
                
                
            case METRIC:
                
                println("initializing from Metric Units")
                var centimeters = getCentimetersFromText(aHeight)
                var SIHeightArray = metricToSIHeight(centimeters)
                rawFeet = SIHeightArray[2]
                rawInches = SIHeightArray[3]
                rawCentimeters = centimeters
                heightMetric = formatHeightMetricString(centimeters)
                heightSI = formatHeightSIString(rawFeet, inches: rawInches)
                
            default : return
            }
        }
        
        if let aWeight = weight {
            
            switch unit {
            case SI:
                println("initializing from SI units")
                
                rawPounds = getPoundsFromText(aWeight)
                weightSI = formatWeightSIString(rawPounds)
                rawKilograms = SIToMetricWeight(rawPounds)
                weightMetric = formatWeightMetricString(rawKilograms)
                
            
            case METRIC:
                
                println("initializing from Metric Units")
                rawKilograms = getKilogramsFromText(aWeight)
                weightMetric = formatWeightMetricString(rawKilograms)
                rawPounds = metricToSIWeight(rawKilograms)
                weightSI = formatWeightSIString(rawPounds)
                
            default : return
            }

            
            
        }
        
    }
    
    
    /**
        TODO: Fix metricToSIWeight and SIToMetricWeight
        FIX:  Modify current MetricToSI and MetricToSI
              methods in BodyInformation.swift
    **/
    
    func metricToSIHeight(centimeters: String) -> [String] {
        var centimetersToInches:Float = (centimeters as NSString).floatValue * CENTIMETERS_TO_INCHES
        var ft = Int(floor((centimetersToInches/12.0)))
        var inches = Int(floor(centimetersToInches%12.0))
        
        
        return ["\(ft)", "\(inches)", "\(centimetersToInches/12.0-(centimetersToInches%12.0)/12)", "\(centimetersToInches%12.0)"]
    }
    
    func SIToMetricHeight(feet: String, inches: String) -> [String] {
        var centimetersFromInches:Float = (inches as NSString).floatValue * INCHES_TO_CENTIMETERS
        var centimetersFromFeet:Float =  (feet as NSString).floatValue * FEET_TO_INCHES * INCHES_TO_CENTIMETERS
        var centimeters = Int(round((centimetersFromFeet + centimetersFromInches)))
        return ["\(centimeters)", "\(centimetersFromFeet+centimetersFromInches)"]
    }
    
    func metricToSIWeight(kilograms:String) -> String {
        var pounds = ((kilograms as NSString).floatValue) * KILOGRAMS_TO_POUNDS
        var formattedPounds = floor(pounds * 10)/10

        return "\(formattedPounds)"
    }
    
    func SIToMetricWeight(pounds: String) -> String {
        
        var kilograms = ((pounds as NSString).floatValue) * POUNDS_TO_KILOGRAMS
        var formattedKilograms = floor(kilograms * 10)/10
        
        return "\(formattedKilograms)"
    
    }
    
    func getCentimetersFromText(text : String) -> String {
        var startIndex = text.startIndex
        var endIndex = advance(startIndex, 3)
        var range = Range<String.Index>(start: startIndex, end: endIndex)
        return text.substringWithRange(range)
    }
    
    func getFeetFromText(text : String) -> String {
        var startIndex = text.startIndex
        var endIndex = advance(startIndex, 1)
        var range = Range<String.Index>(start: startIndex, end: endIndex)

        return text.substringWithRange(range)
    }
    
    func getInchesFromText(text : String) -> String {
        var startIndex = advance(text.startIndex, 6)
        var endIndex = startIndex
        var length = text.length
        
        if length == 10 { // if there is there is one digit in inches
            endIndex = advance(text.startIndex, 8)
        }
        if length == 11 { // if there is there are two digits in inches
            endIndex = advance(text.startIndex, 9)
        }
        var range = Range<String.Index>(start: startIndex, end: endIndex)
        
        return text.substringWithRange(range)
    }
    
    func getPoundsFromText(text: String) -> String {
        var startIndex = text.startIndex
        var endIndex:String.Index
        var length = text.length

        
        if length == 7 {
            endIndex = advance(text.startIndex,4)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            println("wholePounds = \(text.substringWithRange(range))")
            return text.substringWithRange(range)
        } else if length == 8 {
            endIndex = advance(text.startIndex,5)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            println("wholePounds = \(text.substringWithRange(range))")
            return text.substringWithRange(range)
        } else {
            return ""
        }
    }
    
    
    func getKilogramsFromText(text: String) -> String {
        var startIndex = text.startIndex
        var endIndex:String.Index
        var length = text.length
        
        if length == 7 {
            endIndex = advance(text.startIndex,4)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            println("wholeKilograms = \(text.substringWithRange(range))")

            return text.substringWithRange(range)
        }
        
        else if length == 8 {
            endIndex = advance(startIndex,5)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            println("wholeKilograms = \(text.substringWithRange(range))")

            return text.substringWithRange(range)
        } else {
            return ""
        }
        
    }
    
    /**
        MARK: formatting body information for textField
    **/
    
    func formatHeightMetricString(centimeters : String) -> String {
        var rawCentimeters = (centimeters as NSString).floatValue
        var centimeters = Int(roundf(rawCentimeters))
        
        return "\(centimeters) cm"
    }
    
    func formatHeightSIString(feet: String, inches: String) -> String {
        var feetRawValue = (feet as NSString).floatValue
        var inchesRawValue = (inches as NSString).floatValue
        
        var feet = Int(floor(feetRawValue))
        var inches = Int(round(inchesRawValue))
        
        return "\(feet) ft, \(inches) in"
    }
    
    func formatWeightMetricString(kilograms: String) -> String {
        return kilograms + " kg"
    }
    
    func formatWeightSIString(pounds : String) -> String {
        return pounds + " lb"
    }
    
    
    
    
    

}