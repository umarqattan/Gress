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
    
    var wholePounds:String!
    var decimalPounds:String!
    
    var rawKilograms:String!
    var wholeKilograms:String!
    var decimalKilograms:String!
    
    
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
                
                wholePounds = getWholePoundsFromText(aWeight)
                decimalPounds = getDecimalPoundsFromText(aWeight)
                weightSI = formatWeightSIString(wholePounds, decimalPounds: decimalPounds)
                var kilogramsArray = SIToMetricWeight(wholePounds, decimalPounds: decimalPounds)
                wholeKilograms = kilogramsArray[0]
                decimalKilograms = kilogramsArray[1]
                weightMetric = formatWeightMetricString(wholeKilograms, decimalKilograms: decimalKilograms)
                
            
            case METRIC:
                
                println("initializing from Metric Units")
                wholeKilograms = getWholeKilogramsFromText(aWeight)
                decimalKilograms = getDecimalKilogramsFromText(aWeight)
                weightMetric = formatWeightMetricString(wholeKilograms, decimalKilograms: decimalKilograms)
                var poundsArray = metricToSIWeight(wholeKilograms, decimalKilograms: decimalKilograms)
                wholePounds = poundsArray[0]
                decimalPounds = poundsArray[1]
                weightSI = formatWeightSIString(wholePounds, decimalPounds: decimalPounds)
                
            default : return
            }

            
            
        }
        
    }
    
    
    /**
        TODO:
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
    
    func metricToSIWeight(wholeKilograms: String, decimalKilograms: String) -> [String] {
        var pounds = ((wholeKilograms as NSString).floatValue + (decimalKilograms as NSString).floatValue) * KILOGRAMS_TO_POUNDS
        var wholePounds = Int(pounds)
        var decimalPounds = pounds % 1
        
        return ["\(wholePounds)", ".\(decimalPounds)"]
    }
    
    func SIToMetricWeight(wholePounds : String, decimalPounds : String) -> [String] {
        var kilograms = ((wholePounds as NSString).floatValue + (decimalPounds as NSString).floatValue) * POUNDS_TO_KILOGRAMS
        var wholeKilograms = Int(kilograms)
        var decimalKilograms = kilograms % 1
    
        return ["\(wholeKilograms)", ".\(decimalKilograms)"]
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
    
    func getWholePoundsFromText(text: String) -> String {
        var startIndex:String.Index
        var endIndex:String.Index
        var length = text.length

        
        if length == 7 {
            startIndex = advance(text.startIndex,2)
            endIndex = advance(text.startIndex,4)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            return text.substringWithRange(range)
        } else if length == 8 {
            startIndex = advance(text.startIndex,3)
            endIndex = advance(text.startIndex,5)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            return text.substringWithRange(range)
        } else {
            return ""
        }
    }
    
    func getDecimalPoundsFromText(text: String) -> String {
        var startIndex:String.Index
        var endIndex:String.Index
        var length = text.length
        if length == 7 {
            startIndex = advance(text.startIndex,2)
            endIndex = advance(text.startIndex,4)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            return text.substringWithRange(range)
        } else if length == 8 {
            startIndex = advance(text.startIndex,3)
            endIndex = advance(text.startIndex,5)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            return text.substringWithRange(range)
        } else {
            return ""
        }
    }
    
    func getWholeKilogramsFromText(text: String) -> String {
        var startIndex:String.Index
        var endIndex:String.Index
        var length = text.length
        
        if length == 7 {
            startIndex = text.startIndex
            endIndex = advance(text.startIndex,2)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            return text.substringWithRange(range)
        }
        
        else if length == 8 {
            startIndex = text.startIndex
            endIndex = advance(startIndex,3)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            return text.substringWithRange(range)
        } else {
            return ""
        }
        
    }
    
    func getDecimalKilogramsFromText(text: String) -> String {
        var startIndex:String.Index
        var endIndex:String.Index
        var length = text.length
        if length == 7 {
            startIndex = advance(text.startIndex,2)
            endIndex = advance(text.startIndex,4)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            return text.substringWithRange(range)
        } else if length == 8 {
            startIndex = advance(text.startIndex,3)
            endIndex = advance(text.startIndex,5)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
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
    
    func formatWeightMetricString(wholeKilograms: String, decimalKilograms: String) -> String {
        return wholeKilograms + decimalKilograms + " kg"
    }
    
    func formatWeightSIString(wholePounds: String, decimalPounds: String) -> String {
        return wholePounds + decimalPounds + " lb"
    }
    
    
    
    
    

}