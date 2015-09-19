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
        
        for (var i = 0; i < 8; i++) {
            days.append("\(i)")
        }
        return [days]
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
        
        return (text as NSString).integerValue
    }
    
    class func getRowFromAge(text : String) -> Int {
        var ageString = text as NSString
        var age = ageString.integerValue - 18
        
        return age
    }
    
    class func getRowFromHeight(text : String, unit: Int) -> [Int] {
        
        switch unit {
            case Body.Constants.SI:
                var feet = (Body.getFeetFromText(text) as NSString).integerValue
                var inches = (Body.getInchesFromText(text) as NSString).integerValue
                var feetRow = feet - 4
                var inchesRow = inches
                println("\(feetRow), \(inchesRow)")
                return [feetRow, inchesRow]
            case Body.Constants.METRIC:
                var centimeters = (Body.getCentimetersFromText(text) as NSString).integerValue
                println("\(text.length)")
                var centimetersRow = centimeters - 122
                return [centimetersRow, 0]
            default: return []
        }
    }
    
    
    
    class func getRowFromWeight(text : String, unit : Int) -> [Int] {
        
        switch unit {
        case Body.Constants.SI:
        
            var pounds = (text as NSString).floatValue
            var poundsRow = Int(floor(pounds))
            var decPoundsRow = Int((pounds % 1) * 10)
            
            poundsRow = poundsRow - 60
            println("poundsRow : \(poundsRow) \ndecPounds : \(decPoundsRow)")
            return [poundsRow, decPoundsRow]
        case Body.Constants.METRIC:
            
            var kilograms = (text as NSString).floatValue
            var grams = Int((kilograms % 1) * 10)
            var kilogramsRow = Int(floor(kilograms)) - 27
            var gramsRow = grams
            
            return [kilogramsRow, gramsRow]
        default: return []
        }
    }
    
    class func getRowFromTrainingDays(text : String) -> Int {
        var startIndex = text.startIndex
        var endIndex = advance(text.startIndex, 1)
        var range = Range<String.Index>(start: startIndex, end: endIndex)
        var trainingDaysString = text.substringWithRange(range)
        var trainingDaysRow = (trainingDaysString as NSString).integerValue
        println(trainingDaysRow)
        return trainingDaysRow
    }
    
    class func getRowFromExerciseDuration(text: String) -> [Int] {
        
        var exerciseDurationArray = getHoursAndMinutesFromText(text)
        var hours = (exerciseDurationArray[0] as NSString).integerValue
        var minutes = (exerciseDurationArray[1] as NSString).integerValue
        
        return [hours, minutes]
    }
    
    class func getHoursAndMinutesFromText(text : String) -> [String] {
        
        var startIndex = text.startIndex
        var endIndex = startIndex
        var length = text.length
        var sublength:Int!
        var hours:String!
        var minutes:String!
        
        
        if length == 10 {
            endIndex = advance(text.startIndex, 1)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            hours = text.substringWithRange(range)
            
            startIndex = advance(text.startIndex, 5)
            endIndex = advance(text.startIndex, 6)
            range = Range<String.Index>(start: startIndex, end: endIndex)
            minutes = text.substringWithRange(range)
        }
        if length == 11 {
            
            endIndex = advance(text.startIndex, 2)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            var hoursInt = (text.substringWithRange(range) as NSString).integerValue
            
            if hoursInt < 10 {
                endIndex = advance(text.startIndex, 1)
                range = Range<String.Index>(start: startIndex, end: endIndex)
                hours = text.substringWithRange(range)
                
                startIndex = advance(text.startIndex, 5)
                endIndex = advance(text.startIndex, 7)
                
                range = Range<String.Index>(start: startIndex, end: endIndex)
                minutes = text.substringWithRange(range)
            } else {
                endIndex = advance(text.startIndex, 2)
                range = Range<String.Index>(start: startIndex, end: endIndex)
                hours = text.substringWithRange(range)
                
                startIndex = advance(text.startIndex, 6)
                endIndex = advance(text.startIndex, 7)
                
                range = Range<String.Index>(start: startIndex, end: endIndex)
                minutes = text.substringWithRange(range)
            }
        }
        if length == 12 {
            endIndex = advance(text.startIndex, 2)
            var range = Range<String.Index>(start: startIndex, end: endIndex)
            hours = text.substringWithRange(range)
            
            startIndex = advance(text.startIndex, 6)
            endIndex = advance(text.startIndex, 8)
            range = Range<String.Index>(start: startIndex, end: endIndex)
            minutes = text.substringWithRange(range)
        }
        
        return [hours, minutes]
        
    }

}