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
        
        /**
            TODO: insert code from dictionary with keys
        **/
        userName = dictionary[Keys.USER_NAME] as! String
        //firstName = dictionary[Keys.FIRST_NAME] as! String
        //lastName = dictionary[Keys.LAST_NAME] as! String
        //fullName = dictionary[Keys.FULL_NAME] as! String
        //email = dictionary[Keys.EMAIL] as! String
        //sex = dictionary[Keys.SEX] as! Int
        //age = dictionary[Keys.AGE] as! String
        //heightMetric = dictionary[Keys.HEIGHT_METRIC] as! String
        //heightSI = dictionary[Keys.HEIGHT_SI] as! String
        //weightMetric = dictionary[Keys.WEIGHT_METRIC] as! String
        //weightSI = dictionary[Keys.WEIGHT_SI] as! String
        //activityLevel = dictionary[Keys.ACTIVITY_LEVEL] as! Float
        //exerciseDuration = dictionary[Keys.EXERCISE_DURATION] as! String
        //trainingDays = dictionary[Keys.TRAINING_DAYS] as! String
        //nutrition = dictionary[Keys.NUTRITION] as! String
        //fatPercent = dictionary[Keys.FAT_PERCENT] as! Float
        //carbohydratePercent = dictionary[Keys.CARBOHYDRATE_PERCENT] as! Float
        //proteinPercent = dictionary[Keys.PROTEIN_PERCENT] as! Float
        //goalLevel = dictionary[Keys.GOAL_LEVEL] as! Float
        //goalCalories = dictionary[Keys.GOAL_CALORIES] as! Int
        //didCompleteNewProfile = dictionary[Keys.COMPLETE_PROFILE] as! Bool
        //unit = dictionary[Keys.UNIT] as! Int
    
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
        var dictionary = [
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
        
        println("Name\n First Name: \(firstName)\n Last Name: \(lastName)\n Email: \(email)\n")
        
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
