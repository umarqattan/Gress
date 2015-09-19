//
//  FoodLogEntry.swift
//  Gress
//
//  Created by Umar Qattan on 9/16/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import CoreData

@objc(FoodLogEntry)


class FoodLogEntry: NSManagedObject {

    
    struct Keys {
        static let FOOD_ITEM_NAME = "item_name"
        static let CALORIES = "nf_calories"
        static let SERVING_SIZE_UNIT = "nf_serving_size_unit"
        static let SERVING_WEIGHT_GRAMS = "nf_serving_weight_grams"
        static let SERVINGS_PER_CONTAINER = "nf_servings_per_container"
        static let SERVING_SIZE_QUANTITY = "nf_serving_size_quantity"
        static let FAT_GRAMS = "nf_total_fat"
        static let CARBOHYDRATE_GRAMS = "nf_total_carbohydrate"
        static let PROTEIN_GRAMS = "nf_protein"
    }
    
    
    
    @NSManaged var foodItemName: String
    @NSManaged var calories: Int
    @NSManaged var servingSizeUnit: String
    @NSManaged var servingWeightGrams: Int
    @NSManaged var servingsPerContainer: Int
    @NSManaged var servingSizeQuantity: Int
    @NSManaged var fatGrams: Int
    @NSManaged var carbohydrateGrams: Int
    @NSManaged var proteinGrams: Int
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

        if let someFoodItemName = dictionary[Keys.FOOD_ITEM_NAME] as? String {
            foodItemName = someFoodItemName
        } else {
            foodItemName = ""
        }
        if let someCalories = dictionary[Keys.CALORIES] as? Int {
            calories = someCalories
        } else {
            calories = 0
        }
        if let someServingSizeUnit = dictionary[Keys.SERVING_SIZE_UNIT] as? String {
            servingSizeUnit = someServingSizeUnit
        } else {
            servingSizeUnit = ""
        }
        if let someServingWeightGrams = dictionary[Keys.SERVING_WEIGHT_GRAMS] as? Int {
            servingWeightGrams = someServingWeightGrams
        } else {
            servingWeightGrams = 0
        }
        if let someServingsPerContainer = dictionary[Keys.SERVINGS_PER_CONTAINER] as? Int {
            servingsPerContainer = someServingsPerContainer
        } else {
            servingsPerContainer = 0
        }
        if let someServingSizeQuantity =  dictionary[Keys.SERVING_SIZE_QUANTITY] as? Int {
            servingSizeQuantity = someServingSizeQuantity
        } else {
            servingSizeQuantity = 0
        }
        if let someFatGrams = dictionary[Keys.FAT_GRAMS] as? Int {
            fatGrams = someFatGrams
        } else {
            fatGrams = 0
        }
        if let someCarbohydrateGrams = dictionary[Keys.CARBOHYDRATE_GRAMS] as? Int {
            carbohydrateGrams = someCarbohydrateGrams
        } else {
            carbohydrateGrams = 0
        }
        if let someProteinGrams = dictionary[Keys.PROTEIN_GRAMS] as? Int {
            proteinGrams = someProteinGrams
        } else {
            proteinGrams = 0
        }
        
    }

    
}
