//
//  Constants.swift
//  Gress
//
//  Created by Umar Qattan on 9/13/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse




    
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




