//
//  BodyInformation.swift
//  Gress
//
//  Created by Umar Qattan on 8/15/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse
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

let MALE_BMR_CONSTANT = 88.362 as Float
let FEMALE_BMR_CONSTANT = 447.593 as Float

let MALE_BMR_WEIGHT_MULTIPLIER = 13.397 as Float
let FEMALE_BMR_WEIGHT_MULTIPLIER = 9.247 as Float

let MALE_BMR_HEIGHT_MULTIPLIER = 4.799 as Float
let FEMALE_BMR_HEIGHT_MULTIPLIER = 3.098 as Float

let MALE_BMR_AGE_MULTIPLIER = 5.677 as Float
let FEMALE_BMR_AGE_MULTIPLIER = 4.330 as Float

class BodyInformation {
    
    // Personal
    var firstName = "First"
    var lastName = "Last"
    var fullName = "First Last"
    var email = "username@email.com"
    var profilePicture = UIImage(named: "Profile Male-100")
    
    // Body
    var sex = MALE
    var age:String = ""
    var heightMetric = ""
    var heightSI:String! = ""
    var weightMetric:String! = ""
    var weightSI:String! = ""
    var rawCentimeters:String! = ""
    var rawFeet:String! = ""
    var rawInches:String! = ""
    var rawPounds:String! = ""
    var rawKilograms:String! = ""
    
    // Activity
    var activityLevel:Float! = 0.00
    var exerciseDuration:String! = ""
    var trainingDays:String! = ""
    
    // Goals and Nutrition
    var nutrition:String! = ""
    var fatPercent:Float! = 0.00
    var carbohydratePercent:Float! = 0.00
    var proteinPercent:Float! = 0.00
    
    var goalLevel:Float! = 0.00
    var goalCalories:Int! = 0
    
    // Completed New Profile
    var didCompleteNewProfile:Bool = false
    var unit:Int = SI
    
    
    // init method
    
    init(firstName: String, lastName: String, email: String, profilePicture: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.email = email
        self.profilePicture = profilePicture
        
    }
    
    
    func setBodyInformationFromDictionary(dictionary : PFUser) {
        firstName = dictionary["first_name"] as! String
        lastName = dictionary["last_name"] as! String
        fullName = dictionary["full_name"] as! String
        email = dictionary["email"] as! String
        sex = dictionary["sex"] as! Int
        age = dictionary["age"] as! String
        heightMetric = dictionary["height_metric"] as! String
        heightSI = dictionary["height_SI"] as! String
        weightMetric = dictionary["weight_metric"] as! String
        weightSI = dictionary["weight_SI"] as! String
        activityLevel = dictionary["activity_level"] as! Float
        exerciseDuration = dictionary["exercise_duration"] as! String
        trainingDays = dictionary["training_days"] as! String
        nutrition = dictionary["nutrition"] as! String
        fatPercent = dictionary["fat_percent"] as! Float
        carbohydratePercent = dictionary["carbohydrate_percent"] as! Float
        proteinPercent = dictionary["protein_percent"] as! Float
        goalLevel = dictionary["goal_level"] as! Float
        goalCalories = dictionary["goal_calories"] as! Int
        didCompleteNewProfile = dictionary["complete_profile"] as! Bool
        unit = dictionary["unit"] as! Int
        
    }
    
    func savePFUserBodyInformation(user : PFUser) -> PFUser {
        
        if !firstName.isEmpty {
            user["first_name"] = firstName
        }
        if !lastName.isEmpty {
            user["last_name"] = lastName
        }
        if !fullName.isEmpty {
            user["full_name"] = fullName
        }
        
        if !email.isEmpty {
            user["email"] = email
        }
        if sex >= 0 {
            user["sex"] = sex
        }
        if !age.isEmpty {
            user["age"] = age
        }
        
        if !heightMetric.isEmpty {
            user["height_metric"] = heightMetric
        }
        if !weightMetric.isEmpty {
            user["weight_metric"] = weightMetric
        }
        if !heightSI.isEmpty {
            user["height_SI"] = heightSI
        }
        if !weightSI.isEmpty {
            user["weight_SI"] = weightSI
        }
        if activityLevel >= 0.00 {
            user["activity_level"] = activityLevel
        }
        if !exerciseDuration.isEmpty {
            user["exercise_duration"] = exerciseDuration
        }
        if !trainingDays.isEmpty {
            user["training_days"] = trainingDays
        }
        if !nutrition.isEmpty {
            user["nutrition"] = nutrition
        }
        if fatPercent >= 0.00 {
            user["fat_percent"] = fatPercent
        }
        if carbohydratePercent >= 0.00 {
            user["carbohydrate_percent"] = carbohydratePercent
        }
        if proteinPercent >= 0.00 {
             user["protein_percent"] = proteinPercent
        }
        if goalLevel >= 0.00 {
            user["goal_level"] = goalLevel
        }
        if goalCalories >= 0 {
            user["goal_calories"] = goalCalories
        }
        if unit >= 0 {
            user["unit"] = unit
        }
        if didCompleteNewProfile {
            user["complete_profile"] = didCompleteNewProfile
        }
        return user
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
        
        println("Nutrition\n Macronutrient Ratio: \(nutrition)\n Goal Level: \(goalLevel)\n Goal Calories: \(goalCalories)")
        
    }
    
    func sexString(sex: Int) -> String {
        switch sex {
            case MALE: return "Male"
            case FEMALE: return "Female"
            default: return ""
        }
    }
    
    func sexInt(sex : String) -> Int {
        switch sex {
        case "Male" : return MALE
        case "Female" : return FEMALE
        default: return 0
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
    
    func setWeightFromText(text : String, unit: Int) {
        
        switch unit {
            case SI :
                rawPounds = "\((text as NSString).floatValue)"
                weightSI = formatWeightSIString(rawPounds)
                rawKilograms = SIToMetricWeight(rawPounds)
                weightMetric = formatWeightMetricString(rawKilograms)
            case METRIC:
                rawKilograms = "\((text as NSString).floatValue)"
                weightMetric = formatWeightMetricString(rawKilograms)
                rawPounds = metricToSIWeight(rawKilograms)
                weightSI = formatWeightSIString(rawPounds)
            default: return
        }
        
    }
    
    func getWeightFromText(text : String, unit: Int) -> [String] {
        
        switch unit {
        case SI :
            rawPounds = "\((text as NSString).floatValue)"
            weightSI = formatWeightSIString(rawPounds)
            rawKilograms = SIToMetricWeight(rawPounds)
            weightMetric = formatWeightMetricString(rawKilograms)
        case METRIC:
            rawKilograms = "\((text as NSString).floatValue)"
            weightMetric = formatWeightMetricString(rawKilograms)
            rawPounds = metricToSIWeight(rawKilograms)
            weightSI = formatWeightSIString(rawPounds)
        default: return []
        }
        
        return [weightSI, weightMetric]
        
        
    }
    
    func setHeightFromText(text : String, unit: Int) {
        
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
    
    func getHeightFromText(text : String, unit: Int) -> [String] {
        
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
            
            var centimeters = BodyInformation.getCentimetersFromText(text)
            var SIHeightArray = metricToSIHeight(centimeters)
            rawFeet = SIHeightArray[2]
            rawInches = SIHeightArray[3]
            rawCentimeters = centimeters
            heightMetric = formatHeightMetricString(centimeters)
            heightSI = formatHeightSIString(rawFeet, inches: rawInches)
        default: return []
        }
        
        return [heightSI, heightMetric]
    }
    
    
    func setAgeFromText(text : String) {
        self.age = text
    }
    
    /**
        MARK: Use the Revised Harris-Benedict Equation to calculate BMR (Basal Metabolic Rate) ->
              
                Men: BMR = 88.362 + (13.397 x weight in kg) + (4.799 x height in cm) - (5.677 x age in years)
    
                Women: BMR = 447.593 + (9.247 x weight in kg) + (3.098 x height in cm) - (4.330 x age in years)
    
                TDEE: 1.2*BMR <= TDEE <= 2.1*BMR or body.activityLevel*BMR
                Deficit = TDEE - 300
                Maintenance = TDEE
                Surplus = TDEE + 300
                return [Deficit, Maintenance, Surplus]:[Calories]
    **/
    
    func getBMR() -> Float {
        var sex = self.sex
        var age = (self.age as NSString).integerValue
        var weightKg = (self.weightMetric as NSString).floatValue
        var heightCm = (self.heightMetric as NSString).floatValue
        var activityLevel = self.activityLevel
        var BMR:Float!
        
        var weightPart:Float!, heightPart:Float!, agePart:Float!
        
        switch sex {
            case MALE:
                weightPart = MALE_BMR_WEIGHT_MULTIPLIER * weightKg
                heightPart = MALE_BMR_HEIGHT_MULTIPLIER * heightCm
                agePart = MALE_BMR_AGE_MULTIPLIER * Float(age)
                BMR = MALE_BMR_CONSTANT + weightPart + heightPart - agePart
            
            case FEMALE:
                weightPart = FEMALE_BMR_WEIGHT_MULTIPLIER * weightKg
                heightPart = FEMALE_BMR_HEIGHT_MULTIPLIER * heightCm
                agePart = FEMALE_BMR_AGE_MULTIPLIER * Float(age)
                BMR = FEMALE_BMR_CONSTANT + weightPart + heightPart - agePart
            default : BMR = 0
        }
        return BMR
    }
    
    func getTDEE() -> Float {
        var BMR = getBMR()
        var activityLevelMult = self.activityLevel
        
        return activityLevelMult * BMR

    }
    
    func getCalorieRange() -> [Int] {
        var TDEE = getTDEE()
        var calorieDeficit = 0.9 * TDEE
        var calorieMaintenance = TDEE
        var calorieSurplus = 1.1 * TDEE
        
        return [Int(calorieDeficit), Int(calorieMaintenance), Int(calorieSurplus)]
    }
    
    func getMacronutrientsFromCalories(calories : Float) -> [Int] {
        
        var fatGrams = Int(calories * fatPercent/100)/9
        var carbohydrateGrams = Int(calories * carbohydratePercent/100)/4
        var proteinGrams = Int(calories * proteinPercent/100)/4
        
        return [fatGrams, carbohydrateGrams, proteinGrams]
    }
    
    
    

}