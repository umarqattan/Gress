//
//  Constants.swift
//  Gress
//
//  Created by Umar Qattan on 9/16/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation


let CALORIE_GOAL:Int = 0
let MACRONUTRIENT_GOAL:Int = 1
let ON:Int = 1
let OFF:Int = 0
let EDIT = "Edit"
let DONE = "Done"


enum ReuseIdentifier:String {
    case Calorie = "CalorieTableViewCell"
    case MacronutrientPieChart = "MacronutrientPieChartTableViewCell"
    case Fat = "FatTableViewCell"
    case Carbohydrate = "CarbohydrateTableViewCell"
    case Protein = "ProteinTableViewCell"
}

enum MacronutrientSection:Int {
    case PieChart = 0
    case Fat = 2
    case Carbohydrate = 3
    case Protein = 4
}

enum CalorieGoal:Int {
    case Deficit = 0
    case Maintenance = 1
    case Surplus = 2
}

enum MacronutrientGoal: Int {
    case Fat = 0
    case Carbohydrate = 1
    case Protein = 2
}

enum Section : Int {
    case FoodLogEntry = 0
    case Total = 1
    case Remaining = 2
}

enum FoodLogEntrySection : Int {
    case Quantity = 0
    case NutritionFacts = 1
}

enum QuantityRow : Int {
    case ServingSize = 0
    case NumberOfServings = 1
    
}

enum NutritionFactsRow : Int {
    case Calories = 0
    case Fat = 1
    case Carbohydrate = 2
    case Protein = 3
}