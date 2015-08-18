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
    var body:BodyInformation!
    
    
    /**
        TODO: add selector for forwardButton
    **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureNewProfileProgressBar(NOT_FINISHED)
        let backButton = UIBarButtonItem(image: UIImage(named: "Left-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBackToNewProfile:"))
        let forwardButton = UIBarButtonItem(image: UIImage(named: "Right-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goForwardToActivity:"))
        navigationItem.rightBarButtonItems = [forwardButton, backButton]
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
    
    func goForwardToActivity(sender: UIBarButtonItem) {
        
    }
    
    func goBackToNewProfile(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
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
        unitSegmentedControl.enabled = false
    }
    
    /**
        TODO: Write method to parse string and convert
              from SI to Metric and vice versa
        FIX:  Fix the current MetricToSI and Metric-
              ToSI methods in BodyInformation.swift
    **/
    
    var tmpDictionary:[String : AnyObject] = [:]
    @IBAction func unitSegmentedControlChanged(sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
                case SI :
                    
                    println("switched from METRIC TO SI")
                    heightField.text = body.heightSI
                    weightField.text = body.weightSI
                
                case METRIC:
                    
                    println("switched from SI TO METRIC")
                    heightField.text = body.heightMetric
                    weightField.text = body.weightMetric

                default : return
            }
    }

    
    /**
        MARK: UIPickerView delegate methods
    **/

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch activeTextField! {
            case ageField :
                return PickerViewConstants.Age.numberOfComponents
            case heightField :
                if unitSegmentedControl.selectedSegmentIndex == 0 {
                    return PickerViewConstants.Height.SI.numberOfComponents
                } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                    return PickerViewConstants.Height.Metric.numberOfComponents
                } else { return 0 }
            case weightField :
                if unitSegmentedControl.selectedSegmentIndex == 0 {
                    return PickerViewConstants.Weight.SI.numberOfComponents
                } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                    return PickerViewConstants.Weight.Metric.numberOfComponents
                    
                } else {return 0 }
            default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField! {
        case ageField :
            return PickerViewConstants.Age.numberOfRowsInComponent
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                
                return PickerViewConstants.Height.SI.heightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return PickerViewConstants.Height.Metric.heightMetric[component].count
            } else { return 0 }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                return PickerViewConstants.Weight.SI.weightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return PickerViewConstants.Weight.Metric.weightMetric[component].count
            } else {return 0 }
        default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch activeTextField! {
        case ageField :
            return "\(PickerViewConstants.Age.age[row])"
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                return PickerViewConstants.Height.SI.heightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return PickerViewConstants.Height.Metric.heightMetric[component][row]
            } else { return "" }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                return PickerViewConstants.Weight.SI.weightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                return PickerViewConstants.Weight.Metric.weightMetric[component][row]
                
            } else {return "" }
        default : return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField! {
        case ageField :
            getAgeInfoFromPickerView(PickerViewConstants.Age.age[row])
            
        case heightField :
            
            if unitSegmentedControl.selectedSegmentIndex == SI {
                var feet:String!
                var inches:String!
                feet = PickerViewConstants.Height.SI.heightSI[0][pickerView.selectedRowInComponent(0)]
                inches = PickerViewConstants.Height.SI.heightSI[2][pickerView.selectedRowInComponent(2)]
                getHeightFromPickerView(feet, inches: inches)
                 println("feet = \(feet) and inches = \(inches)")
                
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                var centimeters:String!
                centimeters = PickerViewConstants.Height.Metric.heightMetric[0][pickerView.selectedRowInComponent(0)]
                getHeightFromPickerView(centimeters)
                println("cm = \(centimeters)")
            }
        case weightField :
            
            var wholeWeight:String!
            var decimalWeight:String!
            var unit:String!
            
            if unitSegmentedControl.selectedSegmentIndex == 0 {
                wholeWeight = PickerViewConstants.Weight.SI.weightSI[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = PickerViewConstants.Weight.SI.weightSI[1][pickerView.selectedRowInComponent(1)]
                unit = PickerViewConstants.Weight.SI.weightSI[2][pickerView.selectedRowInComponent(2)]
            } else if unitSegmentedControl.selectedSegmentIndex == 1 {
                wholeWeight = PickerViewConstants.Weight.Metric.weightMetric[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = PickerViewConstants.Weight.Metric.weightMetric[1][pickerView.selectedRowInComponent(1)]
                unit = PickerViewConstants.Weight.Metric.weightMetric[2][pickerView.selectedRowInComponent(2)]
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
        
        if !ageField.text.isEmpty && !heightField.text.isEmpty && !weightField.text.isEmpty {
            body = BodyInformation(age: ageField.text!, height: heightField.text!, weight: weightField.text!, unit: unitSegmentedControl.selectedSegmentIndex)
            unitSegmentedControl.enabled = true
            configureNewProfileProgressBar(FINISHED)
        } else {
            unitSegmentedControl.enabled = false
            configureNewProfileProgressBar(NOT_FINISHED)
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