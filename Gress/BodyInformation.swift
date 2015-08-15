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

let CENTIMETERS_TO_INCHES = 0.39 as Float
let INCHES_TO_CENTIMETERS = 2.54 as Float
let FEET_TO_INCHES = 12 as Float
let POUNDS_TO_KILOGRAMS = 0.45 as Float
let KILOGRAMS_TO_POUNDS = 2.2 as Float



class BodyInformation {
    
    
    lazy var age:[Int] = {
        var array:[Int] = []
        for (var i = 18; i<150; i++) {
            array.append(i)
        }
        return array
        }()
    
    lazy var heightSI:[[String]] = {
        var feet:[String] = []
        var inches:[String] = []
        for (var i = 4; i < 8; i++) {
            feet.append("\(i) ft")
        }
        for (var i = 0; i < 12; i++) {
            inches.append("\(i) in")
        }
        
        return [feet, inches]
    }()
    
    lazy var heightMetric:[[String]] = {
        var centimeters:[String] = []
        var cm = ["cm"]
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
    
    func metricToSIHeight(centimeters: String) -> [String] {
        var centimetersToInches:Float = (centimeters as NSString).floatValue * CENTIMETERS_TO_INCHES
        var ft:Int = Int(centimetersToInches/12)
        var inches:Int = Int(centimetersToInches%12)
        
        return ["\(ft)", "\(inches)"]
    }
    
    func SIToMetricHeight(inches: String, feet: String) -> [String] {
        var centimetersFromInches:Float = (inches as NSString).floatValue * INCHES_TO_CENTIMETERS
        var centimetersFromFeet:Float =  (feet as NSString).floatValue * FEET_TO_INCHES
        var centimeters = Int(centimetersFromFeet + centimetersFromInches)
        return ["\(centimeters)"]
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
    
    

}