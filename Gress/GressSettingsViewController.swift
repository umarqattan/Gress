//
//  GressSettingsViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/9/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse



class GressSettingsViewController : UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var exerciseDurationField: UITextField!
    @IBOutlet weak var trainingDaysField: UITextField!
    
    @IBOutlet weak var activityLevelSlider: UISlider!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var carbohydrateField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!

    
    @IBOutlet weak var calorieGoalLabel: UILabel!
    @IBOutlet weak var calorieGoalSlider: UISlider!
    @IBOutlet weak var surplusCaloriesLabel: UILabel!
    @IBOutlet weak var maintenanceCaloriesLabel: UILabel!
    @IBOutlet weak var deficitCaloriesLabel: UILabel!
    
    
    var activeTextField:UITextField?
    var pickerView = UIPickerView()
    
    
    var calorieGoalCustomView : UIView!
    var customView:UIView!
    var fatLabel:UILabel!
    var carbohydrateLabel:UILabel!
    var proteinLabel:UILabel!
    var totalPercentageLabel:UILabel!
    var totalPercentageInt = 100
    var totalPercentage = "100"
    var checkmarkButton:UIButton!
    var cancelPickerButton:UIButton!
    
    var body:Body!
    
    
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func fetchBodies() -> [Body] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "Body")
        let result: [AnyObject]?
        do {
            result = try sharedContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error.memory = error1
            result = nil
        }
        if error != nil {
            print("Could not execute fetch request due to: \(error)")
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
        configureTableView()
        configureNavigationItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        configureTableView()
        
        
        if let gressTabBarController = parentViewController as? GressTabBarController {
            body = gressTabBarController.body
            setCalorieVariablesAndLabels()
            
            configureSettings(body.unit)
            configureNavigationItem()
            configureSliders()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveGoalCaloriesToParse()
    }
    
    func setCalorieVariablesAndLabels() {
        
        if (presentingViewController?.isKindOfClass(NewGressProfileGoalsViewController.self) != nil) {
            setCalorieLabels()
            setSliderThumbImage(ON)
        }
        if (presentingViewController?.isKindOfClass(LoginViewController.self) != nil) {
            let user:PFUser = PFUser.currentUser()!
            let dictionary = Body.getDictionaryFromUser(user)
            body.setBodyInformationFromDictionary(dictionary)
            
        }
    }

    
    func setDelegates() {
        
        
        tableView.delegate = self
        navigationController?.delegate = self
        emailField.delegate = self
        ageField.delegate = self
        sexField.delegate = self
        heightField.delegate = self
        weightField.delegate = self
        
        exerciseDurationField.delegate = self
        trainingDaysField.delegate = self
        fatField.delegate = self
        carbohydrateField.delegate = self
        proteinField.delegate = self
        
        
    }
    
    func configureTableView() {

        tableView.allowsSelection = false
        self.navigationController!.navigationBar.translucent = false
        self.tabBarController!.tabBar.translucent = false
        
        
    }
    
    func configureSliders() {
        activityLevelSlider.continuous = false
    }
    
    func configureNavigationItem() {
        
        self.tabBarController?.navigationItem.title = "Goals"
        self.tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editGoalLevel:")]
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
        
    }
    

    func addDoneButtonToActiveTextField() {
        let keyboardToolbar = UIToolbar()
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
        
        
        let checkmarkBarButton = UIBarButtonItem(customView: checkmarkButton)
        //var cancelBarButton = UIBarButtonItem(customView: cancelPickerButton)
        
        keyboardToolbar.barTintColor = UIColor.whiteColor()
        keyboardToolbar.items = [flexBarButton, checkmarkBarButton]
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
        let attributedText = NSMutableAttributedString(string: "Total Percentage = \(totalPercentage) %")
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
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch activeTextField! {
        case ageField :
            return PickerViewConstants.Age.numberOfComponents
        case sexField :
            return 1
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                return PickerViewConstants.Height.SI.numberOfComponents
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
                return PickerViewConstants.Height.Metric.numberOfComponents
            } else { return 0 }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                return PickerViewConstants.Weight.SI.numberOfComponents
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
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
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                
                return PickerViewConstants.Height.SI.heightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
                return PickerViewConstants.Height.Metric.heightMetric[component].count
            } else { return 0 }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                return PickerViewConstants.Weight.SI.weightSI[component].count
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch activeTextField! {
        case ageField :
            return "\(PickerViewConstants.Age.age[row])"
        case sexField :
            return "\(body.sexString(row))"
        case heightField :
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                return PickerViewConstants.Height.SI.heightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
                return PickerViewConstants.Height.Metric.heightMetric[component][row]
            } else { return "" }
        case weightField :
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                return PickerViewConstants.Weight.SI.weightSI[component][row]
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
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
            
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                var feet:String!
                var inches:String!
                feet = PickerViewConstants.Height.SI.heightSI[0][pickerView.selectedRowInComponent(0)]
                inches = PickerViewConstants.Height.SI.heightSI[2][pickerView.selectedRowInComponent(2)]
                getHeightFromPickerView(feet, inches: inches)
                
                
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
                var centimeters:String!
                centimeters = PickerViewConstants.Height.Metric.heightMetric[0][pickerView.selectedRowInComponent(0)]
                getHeightFromPickerView(centimeters)
                
            }
        
        case weightField :
            
            var wholeWeight:String!
            var decimalWeight:String!
            var unit:String!
            
            if unitSegmentedControl.selectedSegmentIndex == Body.Constants.SI {
                wholeWeight = PickerViewConstants.Weight.SI.weightSI[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = PickerViewConstants.Weight.SI.weightSI[1][pickerView.selectedRowInComponent(1)]
                unit = PickerViewConstants.Weight.SI.weightSI[2][pickerView.selectedRowInComponent(2)]
            } else if unitSegmentedControl.selectedSegmentIndex == Body.Constants.METRIC {
                wholeWeight = PickerViewConstants.Weight.Metric.weightMetric[0][pickerView.selectedRowInComponent(0)]
                decimalWeight = PickerViewConstants.Weight.Metric.weightMetric[1][pickerView.selectedRowInComponent(1)]
                unit = PickerViewConstants.Weight.Metric.weightMetric[2][pickerView.selectedRowInComponent(2)]
            }
            getWeightFromPickerView(wholeWeight, decimalWeight: decimalWeight, unit: unit)
        case exerciseDurationField :
            let hours = exerciseDuration[Time.HOURS.rawValue][pickerView.selectedRowInComponent(Time.HOURS.rawValue)]
            let hr = exerciseDuration[Time.HR.rawValue][pickerView.selectedRowInComponent(Time.HR.rawValue)]
            let minutes = exerciseDuration[Time.MINUTES.rawValue][pickerView.selectedRowInComponent(Time.MINUTES.rawValue)]
            let min = exerciseDuration[Time.MIN.rawValue][pickerView.selectedRowInComponent(Time.MIN.rawValue)]
            getExerciseDurationFromPickerView(hours, hr: hr, minutes: minutes, min: min)
        case trainingDaysField :
            let days = trainingDays[Day.DAY.rawValue][pickerView.selectedRowInComponent(Day.DAY.rawValue)]
            getTrainingDaysFromPickerView(days)
        case fatField, carbohydrateField, proteinField :
            let fat = macroNutrients[Macronutrients.FAT.rawValue][pickerView.selectedRowInComponent(Macronutrients.FAT.rawValue)]
            let carbohydrate = macroNutrients[Macronutrients.CARBOHYDRATE.rawValue][pickerView.selectedRowInComponent(Macronutrients.CARBOHYDRATE.rawValue)]
            let protein = macroNutrients[Macronutrients.PROTEIN.rawValue][pickerView.selectedRowInComponent(Macronutrients.PROTEIN.rawValue)]
            
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
    
    func getTrainingDaysFromPickerView(days: String) {
        if activeTextField! == trainingDaysField {
            let daysInt = (days as NSString).integerValue
            switch daysInt {
                case 1 :
                    trainingDaysField.text = days + " day"
                default:
                    trainingDaysField.text = days + " days"
            }
            
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
            let ageRow = PickerViewConstants.getRowFromAge(ageField.text!)
            pickerView.selectRow(ageRow, inComponent: 0, animated: true)
        case sexField :
            pickerView.selectRow(body.sexInt(sexField.text!), inComponent: 0, animated: true)
        
        case heightField :
            var height = PickerViewConstants.getRowFromHeight(heightField.text!, unit: unitSegmentedControl.selectedSegmentIndex)
            switch unitSegmentedControl.selectedSegmentIndex {
            case Body.Constants.SI:
                pickerView.selectRow(height[0], inComponent: 0, animated: true)
                pickerView.selectRow(height[1], inComponent: 2, animated: true)
            case Body.Constants.METRIC:
                pickerView.selectRow(height[0], inComponent: 0, animated: true)
                pickerView.selectRow(height[1], inComponent: 1, animated: true)
            default: return
            }
            
        case weightField :
            
            var weight = PickerViewConstants.getRowFromWeight(weightField.text!, unit: unitSegmentedControl.selectedSegmentIndex)
            
            pickerView.selectRow(weight[0], inComponent: 0, animated: true)
            pickerView.selectRow(weight[1], inComponent: 1, animated: true)
        case exerciseDurationField :
            var exerciseDurationArray = PickerViewConstants.getRowFromExerciseDuration(exerciseDurationField.text!)
            pickerView.selectRow(exerciseDurationArray[0], inComponent: 0, animated: true)
            pickerView.selectRow(exerciseDurationArray[1], inComponent: 2, animated: true)
        case trainingDaysField :
            let trainingDays = PickerViewConstants.getRowFromTrainingDays(trainingDaysField.text!)
            pickerView.selectRow(trainingDays, inComponent: 0, animated: true)
        case fatField, carbohydrateField, proteinField:
            let fatRow = PickerViewConstants.getRowFromMacronutrient(fatField.text!)
            let fatComponent = Macronutrients.FAT.rawValue
            
            let carbohydrateRow = PickerViewConstants.getRowFromMacronutrient(carbohydrateField.text!)
            let carbohydrateComponent = Macronutrients.CARBOHYDRATE.rawValue
            
            let proteinRow = PickerViewConstants.getRowFromMacronutrient(proteinField.text!)
            let proteinComponent = Macronutrients.PROTEIN.rawValue
            
            pickerView.selectRow(fatRow, inComponent: fatComponent, animated: true)
            pickerView.selectRow(carbohydrateRow, inComponent: carbohydrateComponent, animated: true)
            pickerView.selectRow(proteinRow, inComponent: proteinComponent, animated: true)
        default: return
        }
    }

    func toggleCheckmarkButton() {
        let fatPercentage = PickerViewConstants.getRowFromMacronutrient(fatField.text!)
        let carbohydratePercentage = PickerViewConstants.getRowFromMacronutrient(carbohydrateField.text!)
        let proteinPercentage = PickerViewConstants.getRowFromMacronutrient(proteinField.text!)
        totalPercentageInt = fatPercentage + carbohydratePercentage + proteinPercentage
        totalPercentage = "\(totalPercentageInt)"
        
        let text = "Total Percentage = \(totalPercentageInt) %"
        let attributedText = NSMutableAttributedString(string: text)
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
    
    func endEditing(sender : UIBarButtonItem) {
        switch sender {
        case checkmarkButton:
            activeTextField!.resignFirstResponder()
        default : return
        }
    }
    
    @IBAction func changeCalorieGoal(sender: UISlider) {
        calorieGoalLabel.text = "Goal: \(Int(sender.value))"
        saveSettings()
        
    }

    @IBAction func changeActivityLevel(sender: UISlider) {
        saveSettings()
        saveGoalCaloriesToParse()
        setCalorieVariablesAndLabels()
    }
    func setSliderThumbImage(toggle : Int) {
        switch toggle {
        case ON:
            //let string = NSString(format: "%d", body.goalCalories)
            //var calorieGoalSliderThumbImage = drawText(string, point: CGPointMake(2, 8))
            dispatch_async(dispatch_get_main_queue()) {
                self.calorieGoalSlider.setNeedsDisplay()
                //self.calorieGoalSlider.setThumbImage(calorieGoalSliderThumbImage, forState: UIControlState.Normal)
            }
            
        case OFF:
            dispatch_async(dispatch_get_main_queue()) {
                //self.calorieGoalSlider.setThumbImage(nil, forState: UIControlState.Normal)
            }
            
        default : return
        }
    }
    
    func editGoalLevel(sender : UIBarButtonItem) {
        
        switch sender.title! {
        case EDIT:
            tabBarController?.navigationItem.rightBarButtonItem?.title = DONE
            setSliderThumbImage(OFF)
            calorieGoalSlider.enabled = true
            activityLevelSlider.enabled = true
            toggleTextFields(true)
        case DONE:
            tabBarController?.navigationItem.rightBarButtonItem?.title = EDIT
            setSliderThumbImage(ON)
            
            
            body.goalLevel = (calorieGoalSlider.value - calorieGoalSlider.minimumValue)/(calorieGoalSlider.maximumValue - calorieGoalSlider.minimumValue)
            body.goalCalories = Int(calorieGoalSlider.value)
            calorieGoalSlider.enabled = false
            activityLevelSlider.enabled = false
            toggleTextFields(false)
            
            body.printBodyInformation()
            saveGoalCaloriesToParse()
            
        default : return
        }
    }

    func toggleTextFields(enabled : Bool) {
        emailField.enabled = enabled
        ageField.enabled = enabled
        sexField.enabled = enabled
        heightField.enabled = enabled
        weightField.enabled = enabled
        exerciseDurationField.enabled = enabled
        trainingDaysField.enabled = enabled
        fatField.enabled = enabled
        carbohydrateField.enabled = enabled
        proteinField.enabled = enabled
        
    }
    
    
    func setCalorieLabels() {
        let goal = body.goalLevel
        
        var calorieGoalArray = body.getCalorieRange()
        
        let deficitCalories = calorieGoalArray[CalorieGoal.Deficit.rawValue]
        let maintenanceCalories = calorieGoalArray[CalorieGoal.Maintenance.rawValue]
        let surplusCalories = calorieGoalArray[CalorieGoal.Surplus.rawValue]
        
        let defCal:Float = Float(deficitCalories)
        let surCal:Float = Float(surplusCalories)
        
        calorieGoalSlider.minimumValue = defCal
        calorieGoalSlider.maximumValue = surCal
        calorieGoalSlider.value = goal * (calorieGoalSlider.maximumValue - calorieGoalSlider.minimumValue) + calorieGoalSlider.minimumValue
        let goalCalories = Int(calorieGoalSlider.value)
        
        
        
        deficitCaloriesLabel.text = "\(deficitCalories)"
        maintenanceCaloriesLabel.text = "\(maintenanceCalories)"
        surplusCaloriesLabel.text = "\(surplusCalories)"
        calorieGoalLabel.text = "Goal: \(goalCalories)"
        
    }
    
    /**
        MARK: UITextfield Delegate Protocol
    **/
    
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
        case fatField, carbohydrateField, proteinField :
            activeTextField!.inputView = customView
            print("")
        default : return
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeTextField = nil
        customView = nil
        calorieGoalCustomView = nil
        
        if textField == emailField {
            emailField.keyboardType = UIKeyboardType.EmailAddress
        }
        
        pickerView = UIPickerView()
        
        saveSettings()
        saveGoalCaloriesToParse()
        setCalorieVariablesAndLabels()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func unitSegmentedControlChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            case Body.Constants.SI:
                heightField.text = body.heightSI
                weightField.text = body.weightSI
            case Body.Constants.METRIC:
                heightField.text = body.heightMetric
                weightField.text = body.weightMetric
            default : return
        }
    }
    
    /**
        MARK: save settings to parse
    **/
    
    func saveSettings() {
        body.email = emailField.text!
        body.age = ageField.text!
        body.sex = body.sexInt(sexField.text!)
        
        var height = body.getHeightFromText(heightField.text!, unit: unitSegmentedControl.selectedSegmentIndex)
        var weight = body.getWeightFromText(weightField.text!, unit: unitSegmentedControl.selectedSegmentIndex)
        
        body.heightSI = height[0]
        body.heightMetric = height[1]
        
        body.weightSI = weight[0]
        body.weightMetric = weight[1]
        
        body.activityLevel = activityLevelSlider.value
        body.exerciseDuration = exerciseDurationField.text!
        body.trainingDays = trainingDaysField.text!
        
        body.goalCalories = Int(calorieGoalSlider.value)
        
        body.fatPercent = (fatField.text! as NSString).floatValue
        body.carbohydratePercent = (carbohydrateField.text! as NSString).floatValue
        body.proteinPercent = (proteinField.text! as NSString).floatValue
        
        
        body.goalLevel = (calorieGoalSlider.value - calorieGoalSlider.minimumValue)/(calorieGoalSlider.maximumValue - calorieGoalSlider.minimumValue)
        body.unit = unitSegmentedControl.selectedSegmentIndex
        
    
    }
    
    func configureSettings(unit: Int) {
        
        emailField.text = body.email
        ageField.text = body.age
        sexField.text = body.sexString(body.sex)
        
        
        switch unit {
            case Body.Constants.SI:
                heightField.text = body.heightSI
                weightField.text = body.weightSI
            case Body.Constants.METRIC:
                heightField.text = body.heightMetric
                weightField.text = body.weightMetric
            default : return
        }
        
        activityLevelSlider.value = body.activityLevel
        exerciseDurationField.text = body.exerciseDuration
        trainingDaysField.text = body.trainingDays
        
        fatField.text = "\(body.fatPercent) %"
        carbohydrateField.text = "\(body.carbohydratePercent) %"
        proteinField.text = "\(body.proteinPercent) %"
        
    }
    
    
    func saveGoalCaloriesToParse() {
        var user:PFUser = PFUser.currentUser()!
        user = body.getUpdatedUser(user)
        
        user.saveInBackgroundWithBlock() { (success:Bool, downloadError:NSError?) in
            if let error = downloadError {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showAlertView(success, buttonTitle: "Error", message: error.localizedDescription) { UIAlertAction in
                        
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Goal Calories have been updated")
                }
            }
        }
        
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func logout(sender : UIBarButtonItem) {
        saveGoalCaloriesToParse()
        self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}