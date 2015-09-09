//
//  NewGressProfileActivityViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse

enum Time:Int {
    case HOURS = 0, HR, MINUTES, MIN
}

enum Day:Int {
    case DAY = 0, PERWEEK
}

let exerciseDuration = PickerViewConstants.Activity.Exercise.Duration.exerciseDuration
let trainingDays = PickerViewConstants.Activity.Exercise.Frequency.trainingDays
let SEDENTARY = "sedentary"
let ACTIVE = "active"
let ATHLETE = "athlete"
let NONE = ""


class NewGressProfileActivityViewController : UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var activitySlider: UISlider!
    @IBOutlet weak var sedentaryButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var athleteButton: UIButton!
    

    
    let noneString = "Tap on any of the slider level markers to learn more about your activity level"
    let sedentaryString = "A sedentary lifestyle is a type of lifestyle with no or irregular physical activity. A person who lives a sedentary lifestyle may colloquially be known as a slob or couch potato. It is commonly found in both the developed and developing world. Sedentary activities include sitting, reading, watching television, playing video games, and computer use for much of the day with little or no vigorous physical exercise. A sedentary lifestyle can contribute to many preventable causes of death."
    let activeString = "An active lifestyle is a type of lifestyle with regular physical activity. A person who lives an active lifestyle may be anyone who normally walks everywhere, stands most of the time, and is busy. Examples of active lifestyles include being a student, salesperson, teacher, researcher, scientist, doctor, or nurse."
    let athleteString = "An athlete or sportsperson, sportsman or sportswoman (British English) is a person who competes in one or more sports that involve physical strength, speed and/or endurance. Athletes may be professionals or amateurs. Most professional athletes have particularly well-developed physiques obtained by extensive physical training and strict exercise accompanied by a strict dietary regimen."
    
    
    @IBOutlet weak var exerciseDurationField: UITextField!
    @IBOutlet weak var trainingDaysField: UITextField!
    
    
    
    var backButton:UIBarButtonItem!
    var forwardButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    
    var activeTextField:UITextField?
    var pickerView:UIPickerView!
    var body:BodyInformation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureNavigationItem()
        configureNewProfileProgressBar(NOT_FINISHED)
        configureActivitySlider()
        configureTextView(NONE)
        configureUserInputView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func updateSharedBodyObjectWithActivity() {
        body = getSharedBodyObject()
        body.exerciseDuration = exerciseDurationField.text
        body.trainingDays = trainingDaysField.text
        body.activityLevel = activitySlider.value
        updateSharedBodyObject(body)
    }
    
    func setDelegates() {
        
        scrollView.delegate = self
        exerciseDurationField.delegate = self
        trainingDaysField.delegate = self
    }
    
    /**
        MARK: configureTextView is a method that takes a 
              string that is related to an activityLevel
              UIButton underneath the activityLevelSlider.
              When a button is pressed, the UITextView on
              the bottom of the userInputView is updated 
              with attributedText that describes the act-
              itivty level and a clear UIButton appears 
              at the bottom of the UITextView, which rev-
              erts the UITextView to its original state.
        FIX:  make sure that the touchUpInside, touchUpOu-
              side, etc. change the way the button is high-
              lighted.
    **/
    
    func configureUserInputView() {
        userInputView.layer.cornerRadius = 12
    }
    
    func configureTextView(activityLevel: String) {
        
        let activityLevelTextView = UITextView(frame: CGRectMake(8, 174, 314, 230))
        userInputView.addSubview(activityLevelTextView)
        activityLevelTextView.hidden = false
        activityLevelTextView.backgroundColor = UIColor(red: 99.0/255.0, green: 185.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        activityLevelTextView.layer.cornerRadius = 12
        
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let coordX = activityLevelTextView.frame.size.width/2.0 - 25
        let coordY = activityLevelTextView.frame.size.height - 55.0
        
        let OkImage = UIImage(named: "Ok-50")!
        let OkImageFilled = UIImage(named: "Ok Filled-50")!
        let clearButtonSize = OkImage.size
        let clearButton = UIButton(frame: CGRectMake(coordX, coordY, clearButtonSize.width, clearButtonSize.height))
        
        clearButton.addTarget(self, action: Selector("changeTextInView:"), forControlEvents: UIControlEvents.TouchUpInside)
        clearButton.setImage(UIImage(named: "Ok-50"), forState: UIControlState.Normal)
        clearButton.setImage(UIImage(named: "Ok Filled-50"), forState: UIControlState.Selected)
        clearButton.setImage(UIImage(named: "Ok Filled-50"), forState: UIControlState.Highlighted)
        
        switch activityLevel {
            case NONE :
                var attributedText = NSMutableAttributedString(string: noneString)
                attributedText.addAttributes([NSForegroundColorAttributeName : UIColor(red: 60.0/255.0, green: 228.0/255.0, blue: 255.0/255.0, alpha: 1.0), NSParagraphStyleAttributeName: paragraphStyle], range: NSRange(location: 0, length: noneString.length))
                activityLevelTextView.attributedText = attributedText
            case SEDENTARY :
                var attributedText = NSMutableAttributedString(string: sedentaryString)
                attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(14)], range: NSRange(location: 2, length: 9))
                attributedText.addAttributes([NSForegroundColorAttributeName : UIColor(red: 60.0/255.0, green: 228.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSRange(location: 0, length: sedentaryString.length))
                activityLevelTextView.attributedText = attributedText
                activityLevelTextView.addSubview(clearButton)
            case ACTIVE :
                var attributedText = NSMutableAttributedString(string: activeString)
                attributedText.addAttributes([NSFontAttributeName : UIFont.boldSystemFontOfSize(14)], range: NSRange(location: 3, length: 6))
                attributedText.addAttributes([NSForegroundColorAttributeName : UIColor(red: 60.0/255.0, green: 228.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSRange(location: 0, length: activeString.length))
                activityLevelTextView.attributedText = attributedText
                activityLevelTextView.addSubview(clearButton)
            case ATHLETE :
                var attributedText = NSMutableAttributedString(string: athleteString)
                attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(14)], range: NSRange(location: 3, length: 7))
                attributedText.addAttributes([NSForegroundColorAttributeName : UIColor(red: 60.0/255.0, green: 228.0/255.0, blue: 255.0/255.0, alpha: 1.0)], range: NSRange(location: 0, length: athleteString.length))
                activityLevelTextView.attributedText = attributedText
                activityLevelTextView.addSubview(clearButton)
            default : return
        }
    }
    
    func configureDefaultPickerViewValues() {
        switch activeTextField! {
            case trainingDaysField :
                pickerView.selectRow(4, inComponent: 0, animated: true)
            case exerciseDurationField :
                pickerView.selectRow(1, inComponent: 0, animated: true)
                pickerView.selectRow(30, inComponent: 2, animated: true)
            default : return
        }
    }
    
    func changeTextInView(sender: UIButton) {
    
        sender.selected = !sender.selected;
        configureTextView(NONE)
    }
    
    func configureActivitySlider() {
        activitySlider.value = (activitySlider.maximumValue - activitySlider.minimumValue)/2.0
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
                self.forwardButton.enabled = true
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.50
                self.forwardButton.enabled = false
            })
        }
    }
    
    
    /**
        MARK: NavigationItem's rightBarButtonItems' actions
    **/
    
    func goForward(sender: UIBarButtonItem) {
        
        updateSharedBodyObjectWithActivity()
        
        let newGressProfileGoalsViewController = storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileGoalsViewController") as! NewGressProfileGoalsViewController
        navigationController?.pushViewController(newGressProfileGoalsViewController, animated: true)
    }
    
    func goBack(sender: UIBarButtonItem) {
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func cancel(sender: UIBarButtonItem) {
        var user:PFUser = PFUser.currentUser()!
        user.delete()
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    /**
        MARK: Activity level button actions (explanation)
              that present textViews of what the words 
              sedentary, metropolitan, and athlete mean.
    **/
    
    @IBAction func sedentaryButtonAction(sender: UIButton) {
        configureTextView(SEDENTARY)
    }
   
    @IBAction func activeButtonAction(sender: UIButton) {
        configureTextView(ACTIVE)
    }
    @IBAction func athleteButtonAction(sender: UIButton) {
        configureTextView(ATHLETE)
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
            case trainingDaysField :
                if component == Day.DAY.rawValue {
                    return 8
                }
                else if component == Day.PERWEEK.rawValue {
                    return 1
                } else {
                    return 0
            }
            default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    
        switch activeTextField! {
            case exerciseDurationField :
                return exerciseDuration[component][row]
            case trainingDaysField :
                return trainingDays[component][row]
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
            case trainingDaysField :
                var days = trainingDays[Day.DAY.rawValue][pickerView.selectedRowInComponent(Day.DAY.rawValue)]
                var perWeek = trainingDays[Day.PERWEEK.rawValue][pickerView.selectedRowInComponent(Day.PERWEEK.rawValue)]
                getTrainingDaysFromPickerView(days, perWeek: perWeek)
            default : return
        }
    }
    
    func getExerciseDurationFromPickerView(hours: String, hr: String, minutes: String, min: String) {
        if activeTextField! == exerciseDurationField {
            exerciseDurationField.text = hours + " " + hr + " " + minutes + " " + min
        }
    }
    
    func getTrainingDaysFromPickerView(days: String, perWeek: String) {
        if activeTextField! == trainingDaysField {
            trainingDaysField.text = days + " " + perWeek
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
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        addDoneButtonToActiveTextField()
        configureDefaultPickerViewValues()
        
        
        switch textField {
            case exerciseDurationField :
                exerciseDurationField.inputView = pickerView
            case trainingDaysField :
                trainingDaysField.inputView = pickerView
            default : return
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        pickerView = UIPickerView()
        
        if !exerciseDurationField.text.isEmpty && !trainingDaysField.text.isEmpty {
            configureNewProfileProgressBar(FINISHED)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}