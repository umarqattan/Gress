//
//  Body.swift
//  Gress
//
//  Created by Umar Qattan on 9/14/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import CoreData
import Parse

@objc(Body)




class Body: NSManagedObject {

    struct Constants {
        static let CENTIMETERS_TO_INCHES = 0.393701 as Float
        static let INCHES_TO_CENTIMETERS = 2.54 as Float
        static let FEET_TO_INCHES = 12 as Float
        static let POUNDS_TO_KILOGRAMS = 0.453592 as Float
        static let KILOGRAMS_TO_POUNDS = 2.20462 as Float
        static let SI = 0
        static let METRIC = 1
        static let MALE = 0
        static let FEMALE = 1
        static let MALE_BMR_CONSTANT = 88.362 as Float
        static let FEMALE_BMR_CONSTANT = 447.593 as Float
        static let MALE_BMR_WEIGHT_MULTIPLIER = 13.397 as Float
        static let FEMALE_BMR_WEIGHT_MULTIPLIER = 9.247 as Float
        static let MALE_BMR_HEIGHT_MULTIPLIER = 4.799 as Float
        static let FEMALE_BMR_HEIGHT_MULTIPLIER = 3.098 as Float
        static let MALE_BMR_AGE_MULTIPLIER = 5.677 as Float
        static let FEMALE_BMR_AGE_MULTIPLIER = 4.330 as Float
    }

    struct Keys {
        
        static let USER_NAME = "username"
        static let FIRST_NAME = "first_name"
        static let LAST_NAME = "last_name"
        static let FULL_NAME = "full_name"
        static let EMAIL = "email"
        static let SEX = "sex"
        static let AGE = "age"
        static let HEIGHT_METRIC = "height_metric"
        static let HEIGHT_SI = "height_SI"
        static let WEIGHT_METRIC = "weight_metric"
        static let WEIGHT_SI = "weight_SI"
        static let RAW_CENTIMETERS = "raw_centimeters"
        static let RAW_POUNDS = "raw_pounds"
        static let RAW_KILOGRAMS = "raw_kilograms"
        static let RAW_INCHES = "raw_inches"
        static let RAW_FEET = "raw_feet"
        static let ACTIVITY_LEVEL = "activity_level"
        static let GOAL_LEVEL = "goal_level"
        static let EXERCISE_DURATION = "exercise_duration"
        static let TRAINING_DAYS = "training_days"
        static let NUTRITION = "nutrition"
        static let FAT_PERCENT = "fat_percent"
        static let CARBOHYDRATE_PERCENT = "carbohydrate_percent"
        static let PROTEIN_PERCENT = "protein_percent"
        static let GOAL_CALORIES = "goal_calories"
        static let COMPLETE_PROFILE = "complete_profile"
        static let UNIT = "unit"
        
        static let DAY = "day"
        static let TOTAL_CALORIES = "total_calories"
        static let REMAINING_CALORIES = "remaining_calories"
        static let TOTAL_FAT = "total_fat"
        static let TOTAL_CARBOHYDRATE = "total_carbohydrate"
        static let TOTAL_PROTEIN = "total_protein"
        static let REMAINING_FAT = "remaining_fat"
        static let REMAINING_CARBOHYDRATE = "remaining_carbohydrate"
        static let REMAINING_PROTEIN = "remaining_protein"
    }
    
    @NSManaged var userName: String
    @NSManaged var goalLevel: Float
    @NSManaged var unit: Int
    @NSManaged var didCompleteNewProfile: Bool
    @NSManaged var goalCalories: Int
    @NSManaged var proteinPercent: Float
    @NSManaged var carbohydratePercent: Float
    @NSManaged var fatPercent: Float
    @NSManaged var nutrition: String
    @NSManaged var trainingDays: String
    @NSManaged var exerciseDuration: String
    @NSManaged var activityLevel: Float
    @NSManaged var weightSI: String
    @NSManaged var weightMetric: String
    @NSManaged var heightSI: String
    @NSManaged var heightMetric: String
    @NSManaged var age: String
    @NSManaged var sex: Int
    @NSManaged var email: String
    @NSManaged var fullName: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var foodLogEntries:[FoodLogEntry]
    
    var rawCentimeters:String!
    var rawFeet:String!
    var rawInches:String!
    var rawPounds:String!
    var rawKilograms:String!

    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }()
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary : [String : AnyObject], context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Body", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
    
        
        userName = dictionary[Keys.USER_NAME] as! String
    
    }
    
    
    func setBodyInformationFromDictionary(dictionary : [String : AnyObject])  {
        userName = dictionary[Keys.USER_NAME] as! String
        firstName = dictionary[Keys.FIRST_NAME] as! String
        lastName = dictionary[Keys.LAST_NAME] as! String
        fullName = dictionary[Keys.FULL_NAME] as! String
        email = dictionary[Keys.EMAIL] as! String
        sex = dictionary[Keys.SEX] as! Int
        age = dictionary[Keys.AGE] as! String
        heightMetric = dictionary[Keys.HEIGHT_METRIC] as! String
        heightSI = dictionary[Keys.HEIGHT_SI] as! String
        weightMetric = dictionary[Keys.WEIGHT_METRIC] as! String
        weightSI = dictionary[Keys.WEIGHT_SI] as! String
        activityLevel = dictionary[Keys.ACTIVITY_LEVEL] as! Float
        exerciseDuration = dictionary[Keys.EXERCISE_DURATION] as! String
        trainingDays = dictionary[Keys.TRAINING_DAYS] as! String
        nutrition = dictionary[Keys.NUTRITION] as! String
        fatPercent = dictionary[Keys.FAT_PERCENT] as! Float
        carbohydratePercent = dictionary[Keys.CARBOHYDRATE_PERCENT] as! Float
        proteinPercent = dictionary[Keys.PROTEIN_PERCENT] as! Float
        goalLevel = dictionary[Keys.GOAL_LEVEL] as! Float
        goalCalories = dictionary[Keys.GOAL_CALORIES] as! Int
        didCompleteNewProfile = dictionary[Keys.COMPLETE_PROFILE] as! Bool
        unit = dictionary[Keys.UNIT] as! Int
        
    }
    
    class func getDictionaryFromUser(user : PFUser) -> [String : AnyObject] {
        let dictionary = [
            Keys.USER_NAME : user.valueForKey(Keys.USER_NAME),
            Keys.FIRST_NAME : user.valueForKey(Keys.FIRST_NAME),
            Keys.LAST_NAME : user.valueForKey(Keys.LAST_NAME),
            Keys.FULL_NAME : user.valueForKey(Keys.FULL_NAME),
            Keys.EMAIL : user.valueForKey(Keys.EMAIL),
            Keys.SEX : user.valueForKey(Keys.SEX),
            Keys.AGE : user.valueForKey(Keys.AGE),
            Keys.HEIGHT_METRIC : user.valueForKey(Keys.HEIGHT_METRIC),
            Keys.HEIGHT_SI : user.valueForKey(Keys.HEIGHT_SI),
            Keys.WEIGHT_METRIC : user.valueForKey(Keys.WEIGHT_METRIC),
            Keys.WEIGHT_SI : user.valueForKey(Keys.WEIGHT_SI),
            Keys.ACTIVITY_LEVEL : user.valueForKey(Keys.ACTIVITY_LEVEL),
            Keys.EXERCISE_DURATION : user.valueForKey(Keys.EXERCISE_DURATION),
            Keys.TRAINING_DAYS : user.valueForKey(Keys.TRAINING_DAYS),
            Keys.NUTRITION : user.valueForKey(Keys.NUTRITION),
            Keys.FAT_PERCENT : user.valueForKey(Keys.FAT_PERCENT),
            Keys.CARBOHYDRATE_PERCENT : user.valueForKey(Keys.CARBOHYDRATE_PERCENT),
            Keys.PROTEIN_PERCENT : user.valueForKey(Keys.PROTEIN_PERCENT),
            Keys.GOAL_LEVEL : user.valueForKey(Keys.GOAL_LEVEL),
            Keys.GOAL_CALORIES : user.valueForKey(Keys.GOAL_CALORIES),
            Keys.COMPLETE_PROFILE : user.valueForKey(Keys.COMPLETE_PROFILE),
            Keys.UNIT : user.valueForKey(Keys.UNIT)
        ]
        
        return dictionary as! [String : AnyObject]
        
    }

    
    func getUpdatedUser(user : PFUser) -> PFUser {
        
        if !userName.isEmpty {
            user["username"] = userName
        }
        
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
        MARK: Body Information Calculations
    **/

    func printBodyInformation() {
        
        print("Name\n First Name: \(firstName)\n Last Name: \(lastName)\n Email: \(email)\n")
        
        print("Body\n Sex: \(sexString(sex))\n Age: \(age)\n Height Metric: \(heightMetric)\n Height SI: \(heightSI)\n Weight Metric: \(weightMetric)\n Weight SI: \(weightSI)")
        
        print("Activity\n Activity Level: \(activityLevel)\n Exercise Duration: \(exerciseDuration)\n Number of Training Days: \(trainingDays)")
        
        print("Nutrition\n Macronutrient Ratio: \(nutrition)\n Goal Level: \(goalLevel)\n Goal Calories: \(goalCalories)")
        
    }
    
    func sexString(sex: Int) -> String {
        switch sex {
        case Body.Constants.MALE: return "Male"
        case Body.Constants.FEMALE: return "Female"
        default: return ""
        }
    }
    
    func sexInt(sex : String) -> Int {
        switch sex {
        case "Male" : return Body.Constants.MALE
        case "Female" : return Body.Constants.FEMALE
        default: return 0
        }
    }
    
    /**
    MARK: string formatting methods to convert from Metric
    to SI and from SI to Metric
    **/
    
    func metricToSIHeight(centimeters: String) -> [String] {
        let centimetersToInches:Float = (centimeters as NSString).floatValue * Body.Constants.CENTIMETERS_TO_INCHES
        let ft = Int(floor((centimetersToInches/12.0)))
        let inches = Int(floor(centimetersToInches%12.0))
        
        
        return ["\(ft)", "\(inches)", "\(centimetersToInches/12.0-(centimetersToInches%12.0)/12)", "\(centimetersToInches%12.0)"]
    }
    
    func SIToMetricHeight(feet: String, inches: String) -> [String] {
        let centimetersFromInches:Float = (inches as NSString).floatValue * Body.Constants.INCHES_TO_CENTIMETERS
        let centimetersFromFeet:Float =  (feet as NSString).floatValue * Body.Constants.FEET_TO_INCHES * Body.Constants.INCHES_TO_CENTIMETERS
        let centimeters = Int(round((centimetersFromFeet + centimetersFromInches)))
        return ["\(centimeters)", "\(centimetersFromFeet+centimetersFromInches)"]
    }
    
    func metricToSIWeight(kilograms:String) -> String {
        let pounds = ((kilograms as NSString).floatValue) * Body.Constants.KILOGRAMS_TO_POUNDS
        let formattedPounds = floor(pounds * 10)/10
        
        return "\(formattedPounds)"
    }
    
    func SIToMetricWeight(pounds: String) -> String {
        
        let kilograms = ((pounds as NSString).floatValue) * Body.Constants.POUNDS_TO_KILOGRAMS
        let formattedKilograms = floor(kilograms * 10)/10
        
        return "\(formattedKilograms)"
        
    }
    
    class func getCentimetersFromText(text : String) -> String {
        let startIndex = text.startIndex
        let endIndex = startIndex.advancedBy(3)
        let range = Range<String.Index>(start: startIndex, end: endIndex)
        return text.substringWithRange(range)
    }
    
    class func getFeetFromText(text : String) -> String {
        let startIndex = text.startIndex
        let endIndex = startIndex.advancedBy(1)
        let range = Range<String.Index>(start: startIndex, end: endIndex)
        
        return text.substringWithRange(range)
    }
    
    class func getInchesFromText(text : String) -> String {
        let startIndex = text.startIndex.advancedBy(6)
        var endIndex = startIndex
        let length = text.length
        
        if length == 10 { // if there is there is one digit in inches
            endIndex = text.startIndex.advancedBy(8)
        }
        if length == 11 { // if there is there are two digits in inches
            endIndex = text.startIndex.advancedBy(9)
        }
        let range = Range<String.Index>(start: startIndex, end: endIndex)
        
        return text.substringWithRange(range)
    }
    
    class func getPoundsFromText(text: String) -> String {
        let startIndex = text.startIndex
        var endIndex:String.Index
        let length = text.length
        
        
        if length == 7 {
            endIndex = text.startIndex.advancedBy(4)
            let range = Range<String.Index>(start: startIndex, end: endIndex)
            
            return text.substringWithRange(range)
        } else if length == 8 {
            endIndex = text.startIndex.advancedBy(5)
            let range = Range<String.Index>(start: startIndex, end: endIndex)
            
            return text.substringWithRange(range)
        } else {
            return ""
        }
    }
    
    
    class func getKilogramsFromText(text: String) -> String {
        let startIndex = text.startIndex
        var endIndex:String.Index
        let length = text.length
        
        if length == 7 {
            endIndex = text.startIndex.advancedBy(4)
            let range = Range<String.Index>(start: startIndex, end: endIndex)
            
            
            return text.substringWithRange(range)
        }
            
        else if length == 8 {
            endIndex = startIndex.advancedBy(5)
            let range = Range<String.Index>(start: startIndex, end: endIndex)
            
            
            return text.substringWithRange(range)
        } else {
            return ""
        }
    }
    
    /**
    MARK: formatting body information for textField
    **/
    
    func formatHeightMetricString(centimeters : String) -> String {
        let rawCentimeters = (centimeters as NSString).floatValue
        let centimeters = Int(roundf(rawCentimeters))
        
        return "\(centimeters) cm"
    }
    
    func formatHeightSIString(feet: String, inches: String) -> String {
        let feetRawValue = (feet as NSString).floatValue
        let inchesRawValue = (inches as NSString).floatValue
        
        let feet = Int(floor(feetRawValue))
        let inches = Int(round(inchesRawValue))
        
        return "\(feet) ft, \(inches) in"
    }
    
    func formatWeightMetricString(kilograms: String) -> String {
        return kilograms + " kg"
    }
    
    func formatWeightSIString(pounds : String) -> String {
        return pounds + " lb"
    }
    
    class func determineUnitFromString(text : String) -> Int {
        let substring = text as NSString
        
        if substring.hasSuffix("cm") || substring.hasSuffix("kg") {
            return Body.Constants.METRIC
        }
        else if substring.hasSuffix("in") || substring.hasSuffix("lb") {
            return Body.Constants.SI
        } else {
            return -1
        }
        
    }
    
    func setWeightFromText(text : String, unit: Int) {
        
        switch unit {
        case Body.Constants.SI :
            rawPounds = "\((text as NSString).floatValue)"
            weightSI = formatWeightSIString(rawPounds)
            rawKilograms = SIToMetricWeight(rawPounds)
            weightMetric = formatWeightMetricString(rawKilograms)
        case Body.Constants.METRIC:
            rawKilograms = "\((text as NSString).floatValue)"
            weightMetric = formatWeightMetricString(rawKilograms)
            rawPounds = metricToSIWeight(rawKilograms)
            weightSI = formatWeightSIString(rawPounds)
        default: return
        }
    }
    
    func getWeightFromText(text : String, unit: Int) -> [String] {
        
        switch unit {
        case Body.Constants.SI :
            rawPounds = "\((text as NSString).floatValue)"
            weightSI = formatWeightSIString(rawPounds)
            rawKilograms = SIToMetricWeight(rawPounds)
            weightMetric = formatWeightMetricString(rawKilograms)
        case Body.Constants.METRIC:
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
        case Body.Constants.SI :
            let feet = Body.getFeetFromText(text)
            let inches = Body.getInchesFromText(text)
            var metricHeightArray = SIToMetricHeight(feet, inches: inches)
            rawCentimeters = metricHeightArray[1]
            rawFeet = feet
            rawInches = inches
            heightSI = formatHeightSIString(rawFeet, inches: rawInches)
            heightMetric = formatHeightMetricString(rawCentimeters)
            
        case Body.Constants.METRIC:
            let centimeters = Body.getCentimetersFromText(text)
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
        case Body.Constants.SI :
            let feet = Body.getFeetFromText(text)
            let inches = Body.getInchesFromText(text)
            var metricHeightArray = SIToMetricHeight(feet, inches: inches)
            rawCentimeters = metricHeightArray[1]
            rawFeet = feet
            rawInches = inches
            heightSI = formatHeightSIString(rawFeet, inches: rawInches)
            heightMetric = formatHeightMetricString(rawCentimeters)
            
        case Body.Constants.METRIC:
            
            let centimeters = Body.getCentimetersFromText(text)
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
        MARK:Use the Revised Harris-Benedict Equation to calculate BMR (Basal Metabolic Rate) ->
    
            Men: BMR = 88.362 + (13.397 x weight in kg) + (4.799 x height in cm) - (5.677 x age in years)
            Women: BMR = 447.593 + (9.247 x weight in kg) + (3.098 x height in cm) - (4.330 x age in years)
            TDEE: 1.2*BMR <= TDEE <= 2.1*BMR or body.activityLevel*BMR
            Deficit = 90% * TDEE
            Maintenance = 100% * TDEE
            Surplus = 110% * TDEE
            return [Deficit, Maintenance, Surplus]:[Calories]
    **/
    
    func getBMR() -> Float {
        let sex = self.sex
        let age = (self.age as NSString).integerValue
        let weightKg = (self.weightMetric as NSString).floatValue
        let heightCm = (self.heightMetric as NSString).floatValue
        //var activityLevel = self.activityLevel
        var BMR:Float!
        
        var weightPart:Float!, heightPart:Float!, agePart:Float!
        
        switch sex {
        case Body.Constants.MALE:
            weightPart = Body.Constants.MALE_BMR_WEIGHT_MULTIPLIER * weightKg
            heightPart = Body.Constants.MALE_BMR_HEIGHT_MULTIPLIER * heightCm
            agePart = Body.Constants.MALE_BMR_AGE_MULTIPLIER * Float(age)
            BMR = Body.Constants.MALE_BMR_CONSTANT + weightPart + heightPart - agePart
            
        case Body.Constants.FEMALE:
            weightPart = Body.Constants.FEMALE_BMR_WEIGHT_MULTIPLIER * weightKg
            heightPart = Body.Constants.FEMALE_BMR_HEIGHT_MULTIPLIER * heightCm
            agePart = Body.Constants.FEMALE_BMR_AGE_MULTIPLIER * Float(age)
            BMR = Body.Constants.FEMALE_BMR_CONSTANT + weightPart + heightPart - agePart
        default : BMR = 0
        }
        return BMR
    }
    
    func getTDEE() -> Float {
        let BMR = getBMR()
        let activityLevelMult = self.activityLevel
        
        return activityLevelMult * BMR
        
    }
    
    func getCalorieRange() -> [Int] {
        let TDEE = getTDEE()
        let calorieDeficit = 0.9 * TDEE
        let calorieMaintenance = TDEE
        let calorieSurplus = 1.1 * TDEE
        
        return [Int(calorieDeficit), Int(calorieMaintenance), Int(calorieSurplus)]
    }
    
    func getMacronutrientsFromCalories(calories : Float) -> [Int] {
        
        let fatGrams = Int(calories * fatPercent/100)/9
        let carbohydrateGrams = Int(calories * carbohydratePercent/100)/4
        let proteinGrams = Int(calories * proteinPercent/100)/4
        
        return [fatGrams, carbohydrateGrams, proteinGrams]
    }
    
    
}
