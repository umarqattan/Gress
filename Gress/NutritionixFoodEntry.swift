//
//  NutritionixFoodEntry.swift
//  Gress
//
//  Created by Umar Qattan on 9/20/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit


struct NutritionixFoodEntry {
    
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
        static let NUMBER_OF_SERVINGS = "number_of_servings"
    }
    
    
    var foodItemName: String
    var calories: Int
    var servingSizeUnit: String
    var servingWeightGrams: Int
    var servingsPerContainer: Int
    var servingSizeQuantity: Int
    var fatGrams: Int
    var carbohydrateGrams: Int
    var proteinGrams: Int
        
    
    
    init (dictionary : [String : AnyObject]) {
        
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
    
    func dictionary() -> [String : AnyObject] {
        
        return [
            Keys.FOOD_ITEM_NAME : foodItemName,
            Keys.CALORIES : calories,
            Keys.SERVING_SIZE_UNIT : servingSizeUnit,
            Keys.SERVING_WEIGHT_GRAMS : servingWeightGrams,
            Keys.SERVINGS_PER_CONTAINER : servingsPerContainer,
            Keys.SERVING_SIZE_QUANTITY : servingSizeQuantity,
            Keys.FAT_GRAMS : fatGrams,
            Keys.CARBOHYDRATE_GRAMS : carbohydrateGrams,
            Keys.PROTEIN_GRAMS : proteinGrams
        ]
        
        
    }


    
    
}