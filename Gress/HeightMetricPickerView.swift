//
//  HeightMetricPickerView.swift
//  Gress
//
//  Created by Umar Qattan on 8/15/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit


class HeightMetricPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return BodyInformation().heightMetric.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BodyInformation().heightMetric[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\([BodyInformation().heightMetric][component][row])"
    }
    
    
    
    
}