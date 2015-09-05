//
//  PickerViewConstants.swift
//  Gress
//
//  Created by Umar Qattan on 8/17/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation

class PickerViewConstants {

    struct Age {
        
        static let numberOfComponents = 1
        static let numberOfRowsInComponent = PickerViewConstants().age.count
        static let age = PickerViewConstants().age
    }
    
    struct Height {
        struct Metric {
            static let numberOfComponents = PickerViewConstants().heightMetric.count
            static let heightMetric = PickerViewConstants().heightMetric
        }
        
        struct SI {
            static let numberOfComponents = PickerViewConstants().heightSI.count
            static let heightSI = PickerViewConstants().heightSI
        }
    }
    
    struct Weight {
        struct Metric {
            static let numberOfComponents = PickerViewConstants().weightMetric.count
            static let weightMetric = PickerViewConstants().weightMetric
        }
        
        struct SI {
            static let numberOfComponents = PickerViewConstants().weightSI.count
            static let weightSI = PickerViewConstants().weightSI
        }
    }
    
    struct Activity {
        
        struct Exercise {
            
            struct Duration {
                
                static let numberOfComponents = PickerViewConstants().exerciseDuration.count
                static let exerciseDuration = PickerViewConstants().exerciseDuration
                
            }
            
            struct Frequency {
                static let numberOfComponents = PickerViewConstants().trainingDays.count
                static let trainingDays = PickerViewConstants().trainingDays
            }
        }
        
    }
    
    struct Nutrition {
        
        static let numberOfComponents = PickerViewConstants().macroNutrients.count
        static let macroNutrients = PickerViewConstants().macroNutrients
    }
    
    
    lazy var age:[Int] = {
        var array:[Int] = []
        for (var i = 18; i<150; i++) {
            array.append(i)
        }
        return array
        }()
    
    lazy var heightSI:[[String]] = {
        var feet:[String] = []
        var unitFeet:[String] = ["ft"]
        var inches:[String] = []
        var unitInches:[String] = ["in"]
        for (var i = 4; i < 8; i++) {
            feet.append("\(i)")
        }
        for (var i = 0; i < 12; i++) {
            inches.append("\(i)")
        }
        
        return [feet,unitFeet, inches, unitInches]
        }()
    
    lazy var heightMetric:[[String]] = {
        var centimeters:[String] = []
        var cm:[String] = ["cm"]
        for (var i = 122; i < 241; i++) {
            centimeters.append("\(i)")
        }
        return [centimeters, cm]
        }()
    
    lazy var weightSI:[[String]] = {
        var wholePounds:[String] = []
        var decimalPounds:[String] = []
        var lbs = ["lbs"]
        for (var i = 60; i < 998; i++) {
            wholePounds.append("\(i)")
        }
        for (var i = 0; i < 10; i++) {
            decimalPounds.append(".\(i)")
        }
        return [wholePounds, decimalPounds, lbs]
        }()
    
    lazy var weightMetric:[[String]] = {
        var wholeKilograms:[String] = []
        var decimalKilograms:[String] = []
        var kg = ["kg"]
        
        for (var i = 27; i < 453; i++) {
            wholeKilograms.append("\(i)")
        }
        for (var i = 0; i < 10; i++) {
            decimalKilograms.append(".\(i)")
        }
        return [wholeKilograms, decimalKilograms, kg]
        }()
    
    
    lazy var exerciseDuration:[[String]] = {
        var hours:[String] = []
        var minutes:[String] = []
        var hr = ["hr"]
        var min = ["min"]
        
        for (var i = 0; i < 24; i++) {
            hours.append("\(i)")
        }
        for (var i = 0; i < 60; i++) {
            minutes.append("\(i)")
        }
        
        return [hours, hr, minutes, min]
        
    }()
    
    lazy var trainingDays:[[String]] = {
        var days:[String] = []
        var perWeek = ["days"]
        for (var i = 0; i < 8; i++) {
            days.append("\(i)")
        }
        return [days, perWeek]
    }()
    
    lazy var macroNutrients:[[String]] = {
        var fat:[String] = []
        var carbohydrate:[String] = []
        var protein:[String] = []
        var percent:[String] = ["%"]
        for (var i = 0; i < 101; i++) {
            fat.append("\(i)")
            carbohydrate.append("\(i)")
            protein.append("\(i)")
        }
        
        return [fat, percent, carbohydrate, percent, protein, percent]
    }()
    
    class func getRowFromMacronutrient(text : String) -> Int {
        var startIndex = text.startIndex
        var endIndex = startIndex
        var length = text.length
        if length == 3 {
            endIndex = advance(text.startIndex, 1)
        }
        if length == 4 {
            endIndex = advance(text.startIndex, 2)
        }
        var range = Range<String.Index>(start: startIndex, end: endIndex)
        var rowString = text.substringWithRange(range) as NSString
        var row = rowString.integerValue
        return row
    }
    
    class func getRowFromAge(text : String) -> Int {
        var ageString = text as NSString
        var age = ageString.integerValue
        for ( var i = 18; i < 150; i++) {
            if i == age {
                return i - 18
            }
        }
        return -1
    }
    
    class func getRowFromHeight(text : String) -> [Int] {
        var unit = BodyInformation.determineUnitFromString(text)
        switch unit {
            case SI:
                var feet = (BodyInformation.getFeetFromText(text) as NSString).integerValue
                var inches = (BodyInformation.getInchesFromText(text) as NSString).integerValue
                var feetRow:Int!
                var inchesRow:Int!
                for (var i = 4; i < 8; i++) {
                    if i == feet {
                        feetRow = i - 4
                    }
                }
                for (var i = 0; i < 12; i++) {
                    if i == inches {
                        inchesRow = i
                    }
                }
                return [feetRow, inchesRow]
            case METRIC:
                var centimeters = (BodyInformation.getCentimetersFromText(text) as NSString).integerValue
                var centimetersRow:Int!
                for (var i = 122; i < 241; i++) {
                    if i == centimeters {
                        centimetersRow = i - 122
                    }
                }
                return [centimetersRow, 0]
            default: return []
        }
    }
    
    class func getRowFromWeight(text : String) -> [Int] {
        var unit = BodyInformation.determineUnitFromString(text)
        switch unit {
        case SI:
            var pounds = (BodyInformation.getPoundsFromText(text) as NSString).integerValue
            var poundsRow:Int!
            for (var i = 60; i < 998; i++) {
                if i == pounds {
                    poundsRow = i - 60
                }
            }
            return [poundsRow]
        case METRIC:
            var kilograms = (BodyInformation.getKilogramsFromText(text) as NSString).integerValue
            var kilogramsRow:Int!
            for (var i = 27; i < 453; i++) {
                if i == kilograms {
                    kilogramsRow = i - 27
                }
            }
            return [kilogramsRow]
        default: return []
        }
    }
    
    
    
    

}