//
//  NewGressProfileBodyViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/14/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse



class NewGressProfileBodyViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    var activeTextField: UITextField?
    var pickerView = UIPickerView()
    var backButton:UIBarButtonItem!
    var forwardButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    
    var body:Body!
    var email:String!
    var firstName:String!
    var lastName:String!
    var profilePicture:UIImage?
    /**
        MARK: update forward buttons for every viewController 
              pushed to the navigationController stack.
    
    **/
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func fetchBodies() -> [Body] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "Body")
        let result = sharedContext.executeFetchRequest(fetchRequest, error: error)
        if error != nil {
            println("Could not execute fetch request due to: \(error)")
        }
        return result as! [Body]
    }
    
    func findBodyWithCurrentUserName(username : String) -> Body? {
        let bodies = fetchBodies()
        for body in bodies {
            if body.userName == username {
                return body
            }
        }
        return nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureNavigationItem()
        configureNewProfileProgressBar(NOT_FINISHED)
        configureUserInputView()
        unitSegmentedControl.enabled = false
    }
    
    
    func configureUserInputView() {
        userInputView.layer.cornerRadius = 12
    }
    
    func configureNavigationItem() {
        backButton = UIBarButtonItem(image: UIImage(named: "Left-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack:"))
        forwardButton = UIBarButtonItem(image: UIImage(named: "Right-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goForward:"))
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancel:"))
        
        forwardButton.enabled = false
        
        navigationItem.rightBarButtonItems = [forwardButton, backButton]
        navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.50
                self.forwardButton.enabled = true
            })
            forwardButton.enabled = true
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.28
                self.forwardButton.enabled = false
                
            })
        }
    }
    
    func configureDefaultPickerViewValues() {
        
        switch activeTextField! {
            case ageField :
                var ageRow = PickerViewConstants.getRowFromAge(ageField.text)
                pickerView.selectRow(ageRow, inComponent: 0, animated: true)
            case heightField :
                var height = PickerViewConstants.getRowFromHeight(heightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
                pickerView.selectRow(height[0], inComponent: 0, animated: true)
                pickerView.selectRow(height[1], inComponent: 1, animated: true)

            case weightField :
                var weight = PickerViewConstants.getRowFromWeight(weightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
                pickerView.selectRow(weight[0], inComponent: 0, animated: true)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            default: return
        }
    }
    
    func updateSharedBodyObjectWithBody() {
        body.sex = sexSegmentedControl.selectedSegmentIndex
        body.setAgeFromText(ageField.text)
        body.setHeightFromText(heightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
        body.setWeightFromText(weightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
        
        CoreDataStackManager.sharedInstance().saveContext()

    }
    
    func goForward(sender: UIBarButtonItem) {
        
        updateSharedBodyObjectWithBody()
        let newGressProfileActivityViewController = storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileActivityViewController") as! NewGressProfileActivityViewController
        newGressProfileActivityViewController.body = body
        navigationController?.pushViewController(newGressProfileActivityViewController, animated: true)
    }
    
    func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func cancel(sender: UIBarButtonItem) {
        var user:PFUser = PFUser.currentUser()!
        
        /**
        Delete from CoreData first so that we can use Parse
        to get the currentUser.
        **/
        let username = user.valueForKey(Body.Keys.USER_NAME) as! String
        let currentBody = findBodyWithCurrentUserName(username)!
        sharedContext.deleteObject(currentBody)
        
        
        /**
        Delete user from Parse
        **/
        user.delete()
        
        /**
        Go back to the home screen
        **/
        dismissViewControllerAnimated(true, completion: nil)
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
                
                
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                var centimeters:String!
                centimeters = PickerViewConstants.Height.Metric.heightMetric[0][pickerView.selectedRowInComponent(0)]
                getHeightFromPickerView(centimeters)
                
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
        keyboardToolbar.tintColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        
        keyboardToolbar.items = [flexBarButton, doneBarButton]
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
        configureDefaultPickerViewValues()
        textField.inputView = pickerView
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        pickerView = UIPickerView()
        
        if !ageField.text.isEmpty && !heightField.text.isEmpty && !weightField.text.isEmpty {
            
            
            updateSharedBodyObjectWithBody()
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