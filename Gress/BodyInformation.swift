//
//  BodyInformation.swift
//  Gress
//
//  Created by Umar Qattan on 8/15/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse
/**
    MARK: methods that convert from SI to Metric
          and vice versa
**/





struct BodyInformation {
    
    let CENTIMETERS_TO_INCHES = 0.393701 as Float
    let INCHES_TO_CENTIMETERS = 2.54 as Float
    let FEET_TO_INCHES = 12 as Float
    let POUNDS_TO_KILOGRAMS = 0.453592 as Float
    let KILOGRAMS_TO_POUNDS = 2.20462 as Float
    let SI = 0
    let METRIC = 1
    let MALE = 0
    let FEMALE = 1
    
    let MALE_BMR_CONSTANT = 88.362 as Float
    let FEMALE_BMR_CONSTANT = 447.593 as Float
    
    let MALE_BMR_WEIGHT_MULTIPLIER = 13.397 as Float
    let FEMALE_BMR_WEIGHT_MULTIPLIER = 9.247 as Float
    
    let MALE_BMR_HEIGHT_MULTIPLIER = 4.799 as Float
    let FEMALE_BMR_HEIGHT_MULTIPLIER = 3.098 as Float
    
    let MALE_BMR_AGE_MULTIPLIER = 5.677 as Float
    let FEMALE_BMR_AGE_MULTIPLIER = 4.330 as Float
    

    
    // init method

    
    
    
    /**
        MARK: string formatting methods to convert from Metric
              to SI and from SI to Metric
    **/
    
    }
