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

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary : [String : AnyObject], context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Gress", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        /**
            TODO: insert code from dictionary with keys
        **/
        
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
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    
}
