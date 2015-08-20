//
//  NewGressProfileActivityViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit

enum Time:Int {
    case HOURS = 0, HR, MINUTES, MIN
}

let exerciseDuration = PickerViewConstants.Activity.Exercise.Duration.exerciseDuration

class NewGressProfileActivityViewController : UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var activitySlider: UISlider!
    @IBOutlet weak var sedentaryButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var athleteButton: UIButton!
    
    
    @IBOutlet weak var exerciseDurationField: UITextField!
    
    var backButton:UIBarButtonItem!
    var forwardButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    
    var activeTextField:UITextField?
    var pickerView:UIPickerView!
    var body:BodyInformation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureNewProfileProgressBar(NOT_FINISHED)
        configureNavigationItem()
        configureActivitySlider()
        
    }
    
    func setDelegates() {
        
        scrollView.delegate = self
        exerciseDurationField.delegate = self
    }

    func configureActivitySlider() {
        activitySlider.value = 0.50
    }
    
    func configureNavigationItem() {
        backButton = UIBarButtonItem(image: UIImage(named: "Left-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack:"))
        forwardButton = UIBarButtonItem(image: UIImage(named: "Right-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goForward:"))
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancel:"))
        
        navigationItem.rightBarButtonItems = [forwardButton, backButton]
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.74
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.50
            })
        }
    }
    
    /**
        MARK: NavigationItem's rightBarButtonItems' actions
    **/
    
    func goForward(sender: UIBarButtonItem) {
        return
    }
    
    func goBack(sender: UIBarButtonItem) {
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func cancel(sender : UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        MARK: Activity level button actions (explanation)
              that present textViews of what the words 
              sedentary, metropolitan, and athlete mean.
    **/
    
    @IBAction func showSedentaryView(sender: UIButton) {
    }
    
    @IBAction func showActiveView(sender: UIButton) {
    }
    
    @IBAction func showAthleteView(sender: UIButton) {
    }
    /**
        MARK: UIPickerViewDataSource required protocol methods
    **/
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return PickerViewConstants.Activity.Exercise.Duration.numberOfComponents
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField! {
            case exerciseDurationField :
                return exerciseDuration[component].count
            default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    
        
        switch activeTextField! {
            case exerciseDurationField :
                return exerciseDuration[component][row]
            default : return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField! {
            case exerciseDurationField :
                var hours = exerciseDuration[Time.HOURS.rawValue][pickerView.selectedRowInComponent(Time.HOURS.rawValue)]
                var hr = exerciseDuration[Time.HR.rawValue][pickerView.selectedRowInComponent(Time.HR.rawValue)]
                var minutes = exerciseDuration[Time.MINUTES.rawValue][pickerView.selectedRowInComponent(Time.MINUTES.rawValue)]
                var min = exerciseDuration[Time.MIN.rawValue][pickerView.selectedRowInComponent(Time.MIN.rawValue)]
                getExerciseDurationFromPickerView(hours, hr: hr, minutes: minutes, min: min)
            default : return
        }
    }
    
    func getExerciseDurationFromPickerView(hours: String, hr: String, minutes: String, min: String) {
        if activeTextField! == exerciseDurationField {
            exerciseDurationField.text = hours + " " + hr + " " + minutes + " " + min
        }
    }
    
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


    /**
        MARK: UITextFieldDelegate protocol methods
    **/
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        if textField == exerciseDurationField {
            pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
            addDoneButtonToActiveTextField()
            exerciseDurationField.inputView = pickerView
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        pickerView = UIPickerView()
        
        if !exerciseDurationField.text.isEmpty {
            configureNewProfileProgressBar(FINISHED)
            forwardButton.enabled = true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    
    
}