//
//  GressSettingsViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/9/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse



class GressSettingsViewController : UITableViewController, UITableViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var activityLevelField: UITextField!
    @IBOutlet weak var exerciseDurationField: UITextField!
    @IBOutlet weak var trainingDaysField: UITextField!
    @IBOutlet weak var goalCaloriesField: UITextField!
    
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var carbohydrateField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var goalLevelField: UITextField!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    var activeTextField:UITextField?
    var pickerView = UIPickerView()
    var body:BodyInformation!
    
    var customView:UIView!
    var fatLabel:UILabel!
    var carbohydrateLabel:UILabel!
    var proteinLabel:UILabel!
    var totalPercentageLabel:UILabel!
    var totalPercentageInt = 100
    var totalPercentage = "100"
    var checkmarkButton:UIButton!
    var cancelPickerButton:UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setBodyObject()
        configureSettings(body.unit)
        configureTableView()
        configureNavigationBar()
        unitSegmentedControl.selectedSegmentIndex = SI
    }
    
    func setBodyObject() {
        body = BodyInformation(firstName: "Umar", lastName: "Qattan", email: "u.qattan@gmail.com", profilePicture: UIImage(named: "Male Profile-100"))
        body.age = "20"
        body.sex = MALE
        body.heightMetric = "183.0 cm"
        body.heightSI = "6 ft, 0 in"
        body.weightMetric = "78.5 kg"
        body.weightSI = "173.1 lb"
        body.goalLevel = 0.87
        body.activityLevel = 2.000
        body.exerciseDuration = "3 hr 30 min"
        body.trainingDays = "5 days"
        body.nutrition = "15f/60c/20p"
        body.fatPercent = 15.00
        body.carbohydratePercent = 65.00
        body.proteinPercent = 20.00
        body.goalCalories = 3400
        body.unit = SI
    }
    
    func setDelegates() {
        
        
        tableView.delegate = self
        navigationController?.delegate = self
        emailField.delegate = self
        ageField.delegate = self
        sexField.delegate = self
        heightField.delegate = self
        weightField.delegate = self
        activityLevelField.delegate = self
        exerciseDurationField.delegate = self
        trainingDaysField.delegate = self
        goalCaloriesField.delegate = self
        fatField.delegate = self
        carbohydrateField.delegate = self
        proteinField.delegate = self
        goalLevelField.delegate = self
        
    }
    
    func configureTableView() {
        
        var inset = UIEdgeInsetsMake(66, 0, 0, 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)

        
    }
    
    func configureNavigationBar() {
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editSettings:")
        tabBarController?.navigationItem.rightBarButtonItem = editButton
    }
    
    func editSettings(sender: UIBarButtonItem) {
        
    }
    
    
    func addDoneButtonToActiveTextField() {
        var keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        
        let checkmarkImage = UIImage(named: "Checkmark-25")!
        let checkmarkFilledImage = UIImage(named: "Checkmark Filled-25")!
        let checkmarkImageSize = checkmarkImage.size
        let checkmarkImageFrame = CGRectMake(0, 0, checkmarkImageSize.width, checkmarkImageSize.height)
        
        let cancelImage = UIImage(named: "Cancel-25")!
        let cancelFilledImage = UIImage(named: "Cancel Filled-25")!
        let cancelImageSize = cancelImage.size
        let cancelImageFrame = CGRectMake(0, 0, cancelImageSize.width, cancelImageSize.height)
        
        
        checkmarkButton = UIButton(frame: checkmarkImageFrame)
        cancelPickerButton = UIButton(frame: cancelImageFrame)
        
        checkmarkButton.setBackgroundImage(checkmarkImage, forState: UIControlState.Normal)
        checkmarkButton.setBackgroundImage(checkmarkFilledImage, forState: UIControlState.Selected)
        checkmarkButton.setBackgroundImage(checkmarkFilledImage, forState: UIControlState.Highlighted)
        checkmarkButton.addTarget(self, action: Selector("endEditing:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelPickerButton.setBackgroundImage(cancelImage, forState: UIControlState.Normal)
        cancelPickerButton.setBackgroundImage(cancelFilledImage, forState: UIControlState.Selected)
        cancelPickerButton.setBackgroundImage(cancelFilledImage, forState: UIControlState.Highlighted)
        cancelPickerButton.addTarget(self, action: Selector("endEditing:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        var checkmarkBarButton = UIBarButtonItem(customView: checkmarkButton)
        var cancelBarButton = UIBarButtonItem(customView: cancelPickerButton)
        
        keyboardToolbar.barTintColor = UIColor(red: 60.0/255.0, green: 208.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        keyboardToolbar.items = [cancelBarButton, flexBarButton, checkmarkBarButton]
        activeTextField!.inputAccessoryView = keyboardToolbar
    }
    
    
    func addCustomViewToTextFieldInputView() {
        
        let customViewFrame = CGRectMake(0, 0, view.frame.width, view.frame.height*0.40)
        
        customView = UIView(frame: customViewFrame)
        customView.backgroundColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        
        fatLabel = UILabel(frame: CGRectMake(65, 0, 50, 50))
        fatLabel.text = "Fat"
        fatLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        carbohydrateLabel = UILabel(frame: CGRectMake(120, 0, 150, 50))
        carbohydrateLabel.text = "Carbohydrate"
        carbohydrateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        proteinLabel = UILabel(frame: CGRectMake(230, 0, 75, 50))
        proteinLabel.text = "Protein"
        proteinLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        totalPercentageLabel = UILabel(frame: CGRectMake(20, customView.frame.height*0.8, 200, 50))
        var attributedText = NSMutableAttributedString(string: "Total Percentage = \(totalPercentage) %")
        attributedText.addAttributes([NSForegroundColorAttributeName : UIColor.greenColor()], range: NSRange(location: 19, length: totalPercentage.length))
        totalPercentageLabel.attributedText = attributedText
        totalPercentageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        pickerView = UIPickerView(frame: CGRectMake(50, 50, customView.frame.size.width*0.75, customView.frame.size.height*0.50))
        pickerView.layer.cornerRadius = 12
        pickerView.backgroundColor = UIColor(red: 99.0/255.0, green: 185.0/255.0, blue: 239.0/255.0, alpha: 1)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        customView.addSubview(fatLabel)
        customView.addSubview(carbohydrateLabel)
        customView.addSubview(proteinLabel)
        customView.addSubview(totalPercentageLabel)
        customView.addSubview(pickerView)
    }

    
    
    /**
        MARK: UIPickerViewDataSource Protocol
    **/
    
    /**
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as? UILabel;
        
        switch activeTextField! {
        case fatField, carbohydrateField, proteinField :
            if (pickerLabel == nil) {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "HelvetiaNeue-Light", size: 15)
                pickerLabel?.textAlignment = NSTextAlignment.Center
            }
            
            pickerLabel?.text = macroNutrients[component][row]
            
            return pickerLabel!
        default: return pickerLabel!
        }
        
    }
**/
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch activeTextField! {
        case ageField :
            return PickerViewConstants.Age.numberOfComponents
        case sexField :
            return 1
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == SI {
                return PickerViewConstants.Height.SI.numberOfComponents
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                return PickerViewConstants.Height.Metric.numberOfComponents
            } else { return 0 }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == SI {
                return PickerViewConstants.Weight.SI.numberOfComponents
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                return PickerViewConstants.Weight.Metric.numberOfComponents
                
            } else {return 0 }
        case exerciseDurationField :
            return PickerViewConstants.Activity.Exercise.Duration.numberOfComponents
        case trainingDaysField :
            return PickerViewConstants.Activity.Exercise.Frequency.numberOfComponents
        case fatField, carbohydrateField, proteinField:
            return PickerViewConstants.Nutrition.numberOfComponents
        default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField! {
        case ageField :
            return PickerViewConstants.Age.numberOfRowsInComponent
        case sexField :
            return 2
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == SI {
                
                return PickerViewConstants.Height.SI.heightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                return PickerViewConstants.Height.Metric.heightMetric[component].count
            } else { return 0 }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == SI {
                return PickerViewConstants.Weight.SI.weightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                return PickerViewConstants.Weight.Metric.weightMetric[component].count
            } else {return 0 }
        
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
        case fatField, carbohydrateField, proteinField :
            if component == Macronutrients.FAT_PERCENT.rawValue || component == Macronutrients.CARBOHYDRATE_PERCENT.rawValue || component == Macronutrients.PROTEIN_PERCENT.rawValue {
                return 1
            } else {
                return macroNutrients[Macronutrients.PROTEIN.rawValue].count
            }
        default :
            return 0
        
        }
    
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch activeTextField! {
        case ageField :
            return "\(PickerViewConstants.Age.age[row])"
        case sexField :
            return "\(body.sexString(row))"
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == SI {
                return PickerViewConstants.Height.SI.heightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                return PickerViewConstants.Height.Metric.heightMetric[component][row]
            } else { return "" }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == SI {
                return PickerViewConstants.Weight.SI.weightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                return PickerViewConstants.Weight.Metric.weightMetric[component][row]
                
            } else {return "" }
        case exerciseDurationField :
            return exerciseDuration[component][row]
        case trainingDaysField :
            return trainingDays[component][row]
        case fatField, carbohydrateField, proteinField :
            return macroNutrients[component][row]
        
        default : return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField! {
        case ageField :
            getAgeInfoFromPickerView(PickerViewConstants.Age.age[row])
            
        case sexField :
            getSexFromPickerView(body.sexString(row))
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
            
            if unitSegmentedControl.selectedSegmentIndex == SI {
                wholeWeight = PickerViewConstants.Weight.SI.weightSI[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = PickerViewConstants.Weight.SI.weightSI[1][pickerView.selectedRowInComponent(1)]
                unit = PickerViewConstants.Weight.SI.weightSI[2][pickerView.selectedRowInComponent(2)]
            } else if unitSegmentedControl.selectedSegmentIndex == METRIC {
                wholeWeight = PickerViewConstants.Weight.Metric.weightMetric[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = PickerViewConstants.Weight.Metric.weightMetric[1][pickerView.selectedRowInComponent(1)]
                unit = PickerViewConstants.Weight.Metric.weightMetric[2][pickerView.selectedRowInComponent(2)]
            }
            getWeightFromPickerView(wholeWeight, decimalWeight: decimalWeight, unit: unit)
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
        case fatField, carbohydrateField, proteinField :
            var fat = macroNutrients[Macronutrients.FAT.rawValue][pickerView.selectedRowInComponent(Macronutrients.FAT.rawValue)]
            var carbohydrate = macroNutrients[Macronutrients.CARBOHYDRATE.rawValue][pickerView.selectedRowInComponent(Macronutrients.CARBOHYDRATE.rawValue)]
            var protein = macroNutrients[Macronutrients.PROTEIN.rawValue][pickerView.selectedRowInComponent(Macronutrients.PROTEIN.rawValue)]
            
            getPercentagesFromPickerView(fat, carbohydrate: carbohydrate, protein: protein)
            toggleCheckmarkButton()
        default : return
        }
    }

    func getPercentagesFromPickerView(fat: String, carbohydrate: String, protein: String) {
        
        fatField.text = fat + " %"
        carbohydrateField.text = carbohydrate + " %"
        proteinField.text = protein + " %"
    }

    
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
    
    func getSexFromPickerView(sex : String) {
        if activeTextField! == sexField {
            sexField.text = sex
        }
    }
    
    func configureDefaultPickerViewValues() {
        
        switch activeTextField! {
        case ageField :
            var ageRow = PickerViewConstants.getRowFromAge(ageField.text)
            pickerView.selectRow(ageRow, inComponent: 0, animated: true)
        case sexField :
            pickerView.selectRow(body.sexInt(sexField.text), inComponent: 0, animated: true)
        
        case heightField :
            var height = PickerViewConstants.getRowFromHeight(heightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
            switch unitSegmentedControl.selectedSegmentIndex {
            case SI:
                pickerView.selectRow(height[0], inComponent: 0, animated: true)
                pickerView.selectRow(height[1], inComponent: 2, animated: true)
            case METRIC:
                pickerView.selectRow(height[0], inComponent: 0, animated: true)
                pickerView.selectRow(height[1], inComponent: 1, animated: true)
            default: return
            }
            
        case weightField :
            
            var weight = PickerViewConstants.getRowFromWeight(weightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
            
            pickerView.selectRow(weight[0], inComponent: 0, animated: true)
            pickerView.selectRow(weight[1], inComponent: 1, animated: true)
        case exerciseDurationField :
            var exerciseDurationArray = PickerViewConstants.getRowFromExerciseDuration(exerciseDurationField.text)
            pickerView.selectRow(exerciseDurationArray[0], inComponent: 0, animated: true)
            pickerView.selectRow(exerciseDurationArray[1], inComponent: 2, animated: true)
        case trainingDaysField :
            var trainingDays = PickerViewConstants.getRowFromTrainingDays(trainingDaysField.text)
            pickerView.selectRow(trainingDays, inComponent: 0, animated: true)
        case fatField, carbohydrateField, proteinField:
            var fatRow = PickerViewConstants.getRowFromMacronutrient(fatField.text)
            var fatComponent = Macronutrients.FAT.rawValue
            
            var carbohydrateRow = PickerViewConstants.getRowFromMacronutrient(carbohydrateField.text)
            var carbohydrateComponent = Macronutrients.CARBOHYDRATE.rawValue
            
            var proteinRow = PickerViewConstants.getRowFromMacronutrient(proteinField.text)
            var proteinComponent = Macronutrients.PROTEIN.rawValue
            
            pickerView.selectRow(fatRow, inComponent: fatComponent, animated: true)
            pickerView.selectRow(carbohydrateRow, inComponent: carbohydrateComponent, animated: true)
            pickerView.selectRow(proteinRow, inComponent: proteinComponent, animated: true)
            println("fat = \(fatRow) carb = \(carbohydrateRow) protein = \(proteinRow)")
        default: return
        }
    }
    
    /**
        MARK: UITextfield Delegate Protocol
    **/
    func toggleCheckmarkButton() {
        var fatPercentage = PickerViewConstants.getRowFromMacronutrient(fatField.text)
        var carbohydratePercentage = PickerViewConstants.getRowFromMacronutrient(carbohydrateField.text)
        var proteinPercentage = PickerViewConstants.getRowFromMacronutrient(proteinField.text)
        totalPercentageInt = fatPercentage + carbohydratePercentage + proteinPercentage
        totalPercentage = "\(totalPercentageInt)"
        
        var text = "Total Percentage = \(totalPercentageInt) %"
        var attributedText = NSMutableAttributedString(string: text)
        if totalPercentageInt == 100 {
            attributedText.addAttributes([NSForegroundColorAttributeName : UIColor.greenColor()], range: NSRange(location: 19, length: totalPercentage.length))
            totalPercentageLabel.attributedText = NSAttributedString(attributedString: attributedText)
            
            checkmarkButton.enabled = true
        } else {
            
            attributedText.addAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSRange(location: 19, length: totalPercentage.length))
            totalPercentageLabel.attributedText = NSAttributedString(attributedString: attributedText)
            checkmarkButton.enabled = false
        }
    }

    
    /**
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
    **/
    
    func endEditing(sender : UIBarButtonItem) {
        switch sender {
        case checkmarkButton:
            activeTextField!.resignFirstResponder()
        case cancelPickerButton :
            fatField.text = "15 %"
            carbohydrateField.text = "65 %"
            proteinField.text = "20 %"
            
            activeTextField!.resignFirstResponder()
        default : return
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
       
        
        addCustomViewToTextFieldInputView()
        addDoneButtonToActiveTextField()
        configureDefaultPickerViewValues()
        switch textField {
            
        case ageField, sexField, heightField, weightField, exerciseDurationField, trainingDaysField :
            addDoneButtonToActiveTextField()
            textField.inputView = pickerView
        case activityLevelField :
            println()
        case goalCaloriesField :
            println()
        case fatField, carbohydrateField, proteinField :
            
            activeTextField!.inputView = customView
            println()
        case goalLevelField :
            println()
        default : return
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        customView = nil
        pickerView = UIPickerView()
        saveSettings()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func unitSegmentedControlChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case SI:
                heightField.text = body.heightSI
                weightField.text = body.weightSI
            case METRIC:
                heightField.text = body.heightMetric
                weightField.text = body.weightMetric
            default : return
        }
    }
    
    /**
        MARK: save settings to parse
    **/
    
    func saveSettings() {
        body.email = emailField.text
        body.age = ageField.text
        body.sex = body.sexInt(sexField.text)
        
        var height = body.getHeightFromText(heightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
        var weight = body.getWeightFromText(weightField.text, unit: unitSegmentedControl.selectedSegmentIndex)
        
        body.heightSI = height[0]
        body.heightMetric = height[1]
        
        body.weightSI = weight[0]
        body.weightMetric = weight[1]
        
    
        body.activityLevel = (activityLevelField.text as NSString).floatValue
        body.exerciseDuration = exerciseDurationField.text
        body.trainingDays = trainingDaysField.text
        
        body.goalCalories = (goalCaloriesField.text as NSString).integerValue
        
        body.goalLevel = (goalLevelField.text as NSString).floatValue
        body.unit = unitSegmentedControl.selectedSegmentIndex
    
    }
    
    func configureSettings(unit: Int) {
        
        emailField.text = body.email
        ageField.text = body.age
        sexField.text = body.sexString(body.sex)
        
        
        switch unit {
            case SI:
                heightField.text = body.heightSI
                weightField.text = body.weightSI
            case METRIC:
                heightField.text = body.heightMetric
                weightField.text = body.weightMetric
            default : return
        }
        
        activityLevelField.text = "\(body.activityLevel)"
        exerciseDurationField.text = body.exerciseDuration
        trainingDaysField.text = body.trainingDays
        
        goalCaloriesField.text = "\(body.goalCalories)"
        fatField.text = "\(body.fatPercent) %"
        carbohydrateField.text = "\(body.carbohydratePercent) %"
        proteinField.text = "\(body.proteinPercent) %"
        goalLevelField.text = "\(body.goalLevel)"
        
        
    }

    
    func saveGoalCaloriesToParse() {
        var user:PFUser = PFUser.currentUser()!
        //user.setValue(goalCalories, forKey: "goal_calories")
        //user.setValue(goal, forKey: "goal_level")
        //user.setValue(true, forKey: "complete_profile")
        user.saveInBackgroundWithBlock() { (success:Bool, downloadError:NSError?) in
            if let error = downloadError {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showAlertView(success, buttonTitle: "Error", message: error.localizedDescription) { UIAlertAction in
                        
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    println("Goal Calories have been updated")
                }
            }
        }
    }
    
    
    
}