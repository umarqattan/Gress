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
        }
        
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

}