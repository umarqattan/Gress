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
let MALE = 0
let FEMALE = 1
class BodyInformation {
    
    // Personal
    var firstName = "First"
    var lastName = "Last"
    var fullName = "First Last"
    var email = "username@email.com"
    var profilePicture = UIImage(named: "Profile Male-100")
    
    // Body
    var sex = MALE
    var age:String!
    var heightMetric:String!
    var heightSI:String!
    var weightMetric:String!
    var weightSI:String!
    var rawCentimeters:String!
    var rawFeet:String!
    var rawInches:String!
    var rawPounds:String!
    var rawKilograms:String!
    
    // Activity
    var activityLevel:Float!
    var exerciseDuration:String!
    var trainingDays:String!
    
    // Goals and Nutrition
    var nutrition:String!
    var fatPercent:Float!
    var carbohydratePercent:Float!
    var proteinPercent:Float!
    
    var goalLevel:Float!
    
    
    // Completed New Profile
    var didCompleteNewProfile:Bool = false
    
    
    // init method
    
    init(firstName: String, lastName: String, email: String, profilePicture: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.email = email
        self.profilePicture = profilePicture
        
    }
    
    /**
        MARK: Nutrition Information
    **/
    
    struct Nutrition {
        
        struct Macronutrients {
            
            static let Fat = "Fat"
            static let Carbohydrate = "Carbohydrate"
            static let Protein = "Protein"
    
        }
    }
    
    
    /**
        MARK: method to print out contents of a BodyInformation 
              object
    **/
    
    func printBodyInformation() {
        
        println("Name\n First Name: \(firstName)\n Last Name: \(lastName)\n Email: \(email)\n Profile Picture: \(profilePicture)")
        
        println("Body\n Sex: \(sexString(sex))\n Age: \(age)\n Height Metric: \(heightMetric)\n Height SI: \(heightSI)\n Weight Metric: \(weightMetric)\n Weight SI: \(weightSI)")
        
        println("Activity\n Activity Level: \(activityLevel)\n Exercise Duration: \(exerciseDuration)\n Number of Training Days: \(trainingDays)")
        
        println("Nutrition\n Macronutrient Ratio: \(nutrition)\n Goal Level: \(goalLevel)")
        
    }
    
    func sexString(sex: Int) -> String {
        switch sex {
            case 0: return "Male"
            case 1: return "Female"
            default: return ""
        }
    }
    
    /**
        MARK: string formatting methods to convert from Metric
              to SI and from SI to Metric
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
    
    class func getCentimetersFromText(text : String) -> String {
        var startIndex = text.startIndex
        var endIndex = advance(startIndex, 3)
        var range = Range<String.Index>(start: startIndex, end: endIndex)
        return text.substringWithRange(range)
    }
    
    class func getFeetFromText(text : String) -> String {
        var startIndex = text.startIndex
        var endIndex = advance(startIndex, 1)
        var range = Range<String.Index>(start: startIndex, end: endIndex)

        return text.substringWithRange(range)
    }
    
    class func getInchesFromText(text : String) -> String {
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
    
    class func getPoundsFromText(text: String) -> String {
        var startIndex = text.startIndex
        var endIndex:String.Index
        var length = text.length

        
        if length == 7 {
            endIndex = advance(text.startIndex,4)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            
            return text.substringWithRange(range)
        } else if length == 8 {
            endIndex = advance(text.startIndex,5)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            
            return text.substringWithRange(range)
        } else {
            return ""
        }
    }
    
    
    class func getKilogramsFromText(text: String) -> String {
        var startIndex = text.startIndex
        var endIndex:String.Index
        var length = text.length
        
        if length == 7 {
            endIndex = advance(text.startIndex,4)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            

            return text.substringWithRange(range)
        }
        
        else if length == 8 {
            endIndex = advance(startIndex,5)
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
    
    func formatWeightMetricString(kilograms: String) -> String {
        return kilograms + " kg"
    }
    
    func formatWeightSIString(pounds : String) -> String {
        return pounds + " lb"
    }
    
    class func determineUnitFromString(text : String) -> Int {
        var substring = text as NSString
        
        if substring.hasSuffix("cm") || substring.hasSuffix("kg") {
            return METRIC
        }
        else if substring.hasSuffix("in") || substring.hasSuffix("lb") {
            return SI
        } else {
            return -1
        }
        
    }
    
    func setWeightFromText(text : String) {
        var unit = BodyInformation.determineUnitFromString(text)
        switch unit {
            case SI :
                rawPounds = BodyInformation.getPoundsFromText(text)
                weightSI = formatWeightSIString(rawPounds)
                rawKilograms = SIToMetricWeight(rawPounds)
                weightMetric = formatWeightMetricString(rawKilograms)
            case METRIC:
                rawKilograms = BodyInformation.getKilogramsFromText(text)
                weightMetric = formatWeightMetricString(rawKilograms)
                rawPounds = metricToSIWeight(rawKilograms)
                weightSI = formatWeightSIString(rawPounds)
            default: return
        }
        
    }
    
    func setHeightFromText(text : String) {
        var unit = BodyInformation.determineUnitFromString(text)
        switch unit {
            case SI :
                var feet = BodyInformation.getFeetFromText(text)
                var inches = BodyInformation.getInchesFromText(text)
                var metricHeightArray = SIToMetricHeight(feet, inches: inches)
                rawCentimeters = metricHeightArray[1]
                rawFeet = feet
                rawInches = inches
                heightSI = formatHeightSIString(rawFeet, inches: rawInches)
                heightMetric = formatHeightMetricString(rawCentimeters)

            case METRIC:
                println("initializing from Metric Units")
                var centimeters = BodyInformation.getCentimetersFromText(text)
                var SIHeightArray = metricToSIHeight(centimeters)
                rawFeet = SIHeightArray[2]
                rawInches = SIHeightArray[3]
                rawCentimeters = centimeters
                heightMetric = formatHeightMetricString(centimeters)
                heightSI = formatHeightSIString(rawFeet, inches: rawInches)
            default: return
        }

    }
    
    func setAgeFromText(text : String) {
        self.age = text
    }
    
    /**
        TODO: Use the Revised Harris-Benedict Equation to calculate BMR ->
              
                Men: BMR = 88.362 + (13.397 x weight in kg) + (4.799 x height in cm) - (5.677 x age in years)
    
                Women: BMR = 447.593 + (9.247 x weight in kg) + (3.098 x height in cm) - (4.330 x age in years)
    
                TDEE: 1.2*BMR <= TDEE <= 2.1*BMR or body.activityLevel*BMR
                Deficit = TDEE - 300
                Maintenance = TDEE
                Surplus = TDEE + 300
                return [Deficit, Maintenance, Surplus]
    **/
    
    func calculateTDEEFromBodyInformation(body: BodyInformation) -> [Float] {
        return [2100.0, 2400.0, 2700.0]
    }
    
    
    

}