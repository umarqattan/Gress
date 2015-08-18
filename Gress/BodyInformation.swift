//
//  BodyInformation.swift
//  Gress
//
//  Created by Umar Qattan on 8/15/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation


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
    
    struct PickerView {
        
        struct Age {
            static let numberOfComponents = 1
            static let numberOfRowsInComponent = BodyInformation().age.count
            static let age = BodyInformation().age
        }
        
        struct Height {
            struct Metric {
                static let numberOfComponents = BodyInformation().heightMetric.count
                static let heightMetric = BodyInformation().heightMetric
            }
            
            struct SI {
                static let numberOfComponents = BodyInformation().heightSI.count
                static let heightSI = BodyInformation().heightSI
            }
        }
        
        struct Weight {
            struct Metric {
                static let numberOfComponents = BodyInformation().weightMetric.count
                static let weightMetric = BodyInformation().weightMetric
            }
            
            struct SI {
                static let numberOfComponents = BodyInformation().weightSI.count
                static let weightSI = BodyInformation().weightSI
            }
        }
    }
    
    lazy var age:[Int] = {
        var array:[Int] = []
        for (var i = 18; i<150; i++) {
            array.append(i)
        }
        return array
        }()
    
    lazy var heightSI:[[String]] = {
        var feet:[String] = []
        var unitFeet:[String] = ["ft"]
        var inches:[String] = []
        var unitInches:[String] = ["in"]
        for (var i = 4; i < 8; i++) {
            feet.append("\(i)")
        }
        for (var i = 0; i < 12; i++) {
            inches.append("\(i)")
        }
        
        return [feet,unitFeet, inches, unitInches]
    }()
    
    lazy var heightMetric:[[String]] = {
        var centimeters:[String] = []
        var cm:[String] = ["cm"]
        for (var i = 122; i < 241; i++) {
            centimeters.append("\(i)")
        }
        return [centimeters, cm]
    }()
    
    lazy var weightSI:[[String]] = {
        var wholePounds:[String] = []
        var decimalPounds:[String] = []
        var lbs = ["lbs"]
        for (var i = 60; i < 998; i++) {
            wholePounds.append("\(i)")
        }
        for (var i = 0; i < 10; i++) {
            decimalPounds.append(".\(i)")
        }
        return [wholePounds, decimalPounds, lbs]
    }()
    
    lazy var weightMetric:[[String]] = {
        var wholeKilograms:[String] = []
        var decimalKilograms:[String] = []
        var kg = ["kg"]
        
        for (var i = 27; i < 453; i++) {
            wholeKilograms.append("\(i)")
        }
        for (var i = 0; i < 10; i++) {
            decimalKilograms.append(".\(i)")
        }
        return [wholeKilograms, decimalKilograms, kg]
    }()
    
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
    
    func metricToSIWeight(kilograms : String) -> [String] {
        var pounds = (kilograms as NSString).floatValue * KILOGRAMS_TO_POUNDS
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
        println()
        /**
        if inches == 12 {
            inches = 0
            feet++
        }
**/
        
        return "\(feet) ft, \(inches) in"
    }
    
    

}