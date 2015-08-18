//
//  NewGressProfileBodyViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/14/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse


class NewGressProfileBodyViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    
    var activeTextField: UITextField?
    var pickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureNewProfileProgressBar(NOT_FINISHED)
        
        
    }
    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.50
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.28
            })
        }
    }
    
    /**
        MARK: UI[]Delegate methods
    **/
    
    func setDelegates() {
        
        ageField.delegate = self
        heightField.delegate = self
        weightField.delegate = self
    
        scrollView.delegate = self
        unitSegmentedControl.selectedSegmentIndex = 1
    }
    
    /**
        TODO: Write method to parse string and convert
              from SI to Metric and vice versa
        FIX:  Fix the current MetricToSI and Metric-
              ToSI methods in BodyInformation.swift
    **/
    
    
    
    var tmpDictionary:[String : AnyObject] = [:]
    @IBAction func unitSegmentedControlChanged(sender: UISegmentedControl) {
        
        if heightField.text.isEmpty {
            return
        } else {
            
            var SIArray = tmpDictionary["SI"] as! [String]
            
            
            var rawFeet = SIArray[0]
            var rawInches = SIArray[1]
            
            var rawMetricHeight = BodyInformation().SIToMetricHeight(rawFeet, inches: rawInches)
            var centimeters = rawMetricHeight[1]
            tmpDictionary["METRIC"] = [centimeters]
            
            var metricArray = tmpDictionary["METRIC"] as! [String]
            var rawSIHeight = BodyInformation().metricToSIHeight(centimeters)
            var feet = rawSIHeight[2]
            var inches = rawSIHeight[3]
            tmpDictionary["SI"] = [feet, inches]
            
            
            switch sender.selectedSegmentIndex {
                case SI :
                    
                    println("switched from METRIC TO SI")
                    println("rawFeet = \(rawFeet) and rawInches = \(rawInches) from rawCentimeters = \(centimeters)")
                    heightField.text = BodyInformation().formatHeightSIString(feet, inches: rawInches)
                
                case METRIC:
                    
                    println("switched from SI TO METRIC")
                    println("rawCentimeters = \(centimeters) from rawFeet = \(rawFeet) and rawInches = \(rawInches)")
                    heightField.text = BodyInformation().formatHeightMetricString(centimeters)
                
                default : return
            }

        }

    }

    
    /**
        MARK: UIPickerView delegate methods
    **/

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch activeTextField! {
            case ageField :
                return BodyInformation.PickerView.Age.numberOfComponents
            case heightField :
                if unitSegmentedControl.selectedSegmentIndex == 0 {
                    return BodyInformation.PickerView.Height.SI.numberOfComponents
                } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                    return BodyInformation.PickerView.Height.Metric.numberOfComponents
                } else { return 0 }
            case weightField :
                if unitSegmentedControl.selectedSegmentIndex == 0 {
                    return BodyInformation.PickerView.Weight.SI.numberOfComponents
                } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                    return BodyInformation.PickerView.Weight.Metric.numberOfComponents
                    
                } else {return 0 }
            default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField! {
        case ageField :
            return BodyInformation.PickerView.Age.numberOfRowsInComponent
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                
                return BodyInformation.PickerView.Height.SI.heightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return BodyInformation.PickerView.Height.Metric.heightMetric[component].count
            } else { return 0 }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                return BodyInformation.PickerView.Weight.SI.weightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return BodyInformation.PickerView.Weight.Metric.weightMetric[component].count
            } else {return 0 }
        default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch activeTextField! {
        case ageField :
            return "\(BodyInformation.PickerView.Age.age[row])"
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                return BodyInformation.PickerView.Height.SI.heightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return BodyInformation.PickerView.Height.Metric.heightMetric[component][row]
            } else { return "" }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                return BodyInformation.PickerView.Weight.SI.weightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return BodyInformation.PickerView.Weight.Metric.weightMetric[component][row]
                
            } else {return "" }
        default : return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField! {
        case ageField :
            getAgeInfoFromPickerView(BodyInformation.PickerView.Age.age[row])
            
        case heightField :
            
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                var feet:String!
                var inches:String!
                feet = BodyInformation.PickerView.Height.SI.heightSI[0][pickerView.selectedRowInComponent(0)]
                inches = BodyInformation.PickerView.Height.SI.heightSI[2][pickerView.selectedRowInComponent(2)]
                getHeightFromPickerView(feet, inches: inches)
                
                
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                var centimeters:String!
                centimeters = BodyInformation.PickerView.Height.Metric.heightMetric[0][pickerView.selectedRowInComponent(0)]
                getHeightFromPickerView(centimeters)

            }
        case weightField :
            
            var wholeWeight:String!
            var decimalWeight:String!
            var unit:String!
            
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                wholeWeight = BodyInformation.PickerView.Weight.SI.weightSI[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = BodyInformation.PickerView.Weight.SI.weightSI[1][pickerView.selectedRowInComponent(1)]
                unit = BodyInformation.PickerView.Weight.SI.weightSI[2][pickerView.selectedRowInComponent(2)]
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                wholeWeight = BodyInformation.PickerView.Weight.Metric.weightMetric[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = BodyInformation.PickerView.Weight.Metric.weightMetric[1][pickerView.selectedRowInComponent(1)]
                unit = BodyInformation.PickerView.Weight.Metric.weightMetric[2][pickerView.selectedRowInComponent(2)]
            }
            getWeightFromPickerView(wholeWeight, decimalWeight: decimalWeight, unit: unit)
        default : return
        }
    }
    /**
        MARK: UITextFieldDelegate methods
    **/
    
    
    func addDoneButtonToActiveTextField() {
        var keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: view, action: Selector("endEditing:"))
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel,
            target: view, action: Selector("endEditing:"))
        keyboardToolbar.tintColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        
        keyboardToolbar.items = [cancelBarButton, flexBarButton, doneBarButton]
        activeTextField!.inputAccessoryView = keyboardToolbar
    }
    
    /**
        
    **/
    
    func endEditing(sender : UIBarButtonItem) {
        activeTextField!.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {

        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        activeTextField = textField
        addDoneButtonToActiveTextField()
        textField.inputView = pickerView
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        pickerView = UIPickerView()
        
        if textField == heightField {
            
            
            
            switch unitSegmentedControl.selectedSegmentIndex {
                case SI :
                    if tmpDictionary.isEmpty {
                    var feet = BodyInformation().getFeetFromText(heightField.text)
                    var inches = BodyInformation().getInchesFromText(heightField.text)
                    var rawMetricHeight = BodyInformation().SIToMetricHeight(feet, inches: inches)
                    var centimeters = rawMetricHeight[1]
                        println("centimeters in TEXTFIELD = \(centimeters)")
                    tmpDictionary["METRIC"] = [centimeters]
                }
                case METRIC:
                    if tmpDictionary.isEmpty{
                    var centimeters = BodyInformation().getCentimetersFromText(heightField.text)
                    var rawSIHeight = BodyInformation().metricToSIHeight(centimeters)
                    var feet = rawSIHeight[2]
                    var inches = rawSIHeight[3]
                        println("centimeters in TEXTFIELD = \(centimeters)")
                    tmpDictionary["SI"] = [feet, inches]
                }
                default : return
            }
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
        MARK: Methods that set the textField.text values
              for selected pickerView values
    **/
    
    func getAgeInfoFromPickerView(age : Int?) {
        
        if activeTextField! == ageField {
            ageField.text = "\(age!)"
        }
    }
    
    func getWeightFromPickerView(wholeWeight : String, decimalWeight: String, unit: String) {
        
        if activeTextField! == weightField {
            weightField.text = wholeWeight + decimalWeight + " " + unit
        }
    }
    
    func getHeightFromPickerView(feet : String, inches : String) {
        if activeTextField! == heightField {
            heightField.text = feet + " ft, " + inches + " in"
        }
    }
    
    func getHeightFromPickerView(centimeters : String) {
        if activeTextField! == heightField {
            heightField.text = centimeters + " cm"
        }
    }
    
    
    
    
    
    
    
    
}