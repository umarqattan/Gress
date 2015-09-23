//
//  FoodLog.swift
//  Gress
//
//  Created by Umar Qattan on 9/16/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

/**
import Foundation
import CoreData

@objc(FoodLog)

class FoodLog: NSManagedObject {

    struct Keys {
        
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
    
    @NSManaged var day: NSDate
    @NSManaged var totalCalories: Int
    @NSManaged var remainingCalories: Int
    @NSManaged var totalFat: Int
    @NSManaged var totalCarbohydrate: Int
    @NSManaged var totalProtein: Int
    @NSManaged var remainingFat: Int
    @NSManaged var remainingCarbohydrate: Int
    @NSManaged var remainingProtein: Int
    @NSManaged var body: Body
    

    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary : [String : AnyObject], context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("FoodLogEntry", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        
        day = dictionary[Keys.DAY] as! NSDate
        totalCalories = dictionary[Keys.TOTAL_CALORIES] as! Int
        remainingCalories = dictionary[Keys.REMAINING_CALORIES] as! Int
        totalFat = dictionary[Keys.TOTAL_FAT] as! Int
        totalCarbohydrate = dictionary[Keys.TOTAL_CARBOHYDRATE] as! Int
        totalProtein = dictionary[Keys.TOTAL_PROTEIN] as! Int
        remainingCalories = dictionary[Keys.REMAINING_CALORIES] as! Int
        remainingFat = dictionary[Keys.REMAINING_FAT] as! Int
        remainingCarbohydrate = dictionary[Keys.REMAINING_CARBOHYDRATE] as! Int
        remainingProtein = dictionary[Keys.REMAINING_PROTEIN] as! Int
        
    }
    
    
    
    
    
}
**/