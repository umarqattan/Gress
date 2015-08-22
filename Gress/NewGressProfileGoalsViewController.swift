//
//  NewGressProfileGoalsViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/21/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit

enum Macronutrients: Int {
    case FAT = 0, FAT_PERCENT, CARBOHYDRATE, CARBOHYDRATE_PERCENT, PROTEIN, PROTEIN_PERCENT
}
let macroNutrients = PickerViewConstants.Nutrition.macroNutrients

class NewGressProfileGoalsViewController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var goalSlider: UISlider!
    @IBOutlet weak var fatButton: UIButton!
    @IBOutlet weak var carbohydrateButton: UIButton!
    @IBOutlet weak var proteinButton: UIButton!
    @IBOutlet weak var fatLossButton: UIButton!
    @IBOutlet weak var maintainButton: UIButton!
    @IBOutlet weak var leanOutButton: UIButton!
    
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var carbohydrateField: UITextField!
    @IBOutlet weak var proteinField: UITextField!
    
    var activeTextField:UITextField?
    var pickerView:UIPickerView!
    var customView:UIView!
    var checkmarkButton:UIButton!
    
    var body:BodyInformation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNewProfileProgressBar(NOT_FINISHED)
        configureUserInputView()
        setDelegates()
        configureTextFields()
    }
    
    func setDelegates() {
        scrollView.delegate = self
        fatField.delegate = self
        carbohydrateField.delegate = self
        proteinField.delegate = self
        
    }
    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 1.00
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.74
            })
        }
    }
    
    func configureUserInputView() {
        userInputView.layer.cornerRadius = 12
    }
    
    func configureTextFields() {
        fatField.text = "15 %"
        carbohydrateField.text = "65 %"
        proteinField.text = "20 %"
    }
    /**
        MARK: UIPickerViewDelegate methods
    **/
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return PickerViewConstants.Nutrition.numberOfComponents
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField! {
        case fatField :
            if component == Macronutrients.FAT_PERCENT.rawValue || component == Macronutrients.CARBOHYDRATE_PERCENT.rawValue || component == Macronutrients.PROTEIN_PERCENT.rawValue {
                return 1
            }
            return macroNutrients[Macronutrients.FAT.rawValue].count
        case carbohydrateField :
            if component == Macronutrients.FAT_PERCENT.rawValue || component == Macronutrients.CARBOHYDRATE_PERCENT.rawValue || component == Macronutrients.PROTEIN_PERCENT.rawValue {
                return 1
            }
            return macroNutrients[Macronutrients.CARBOHYDRATE.rawValue].count
        case proteinField :
            if component == Macronutrients.FAT_PERCENT.rawValue || component == Macronutrients.CARBOHYDRATE_PERCENT.rawValue || component == Macronutrients.PROTEIN_PERCENT.rawValue {
                return 1
            }
            return macroNutrients[Macronutrients.PROTEIN.rawValue].count
        default : return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return macroNutrients[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var fat = macroNutrients[Macronutrients.FAT.rawValue][pickerView.selectedRowInComponent(Macronutrients.FAT.rawValue)]
        var carbohydrate = macroNutrients[Macronutrients.CARBOHYDRATE.rawValue][pickerView.selectedRowInComponent(Macronutrients.CARBOHYDRATE.rawValue)]
        var protein = macroNutrients[Macronutrients.PROTEIN.rawValue][pickerView.selectedRowInComponent(Macronutrients.PROTEIN.rawValue)]
        getPercentagesFromPickerView(fat, carbohydrate: carbohydrate, protein: protein)
        toggleCheckmarkButton()
    }
    
    func getPercentagesFromPickerView(fat: String, carbohydrate: String, protein: String) {
        fatField.text = fat + " %"
        carbohydrateField.text = carbohydrate + " %"
        proteinField.text = protein + " %"
    }
    
    func configureDefaultPickerViewValues() {
        var fatRow = PickerViewConstants.getRowFromMacronutrient(fatField.text)
        var fatComponent = Macronutrients.FAT.rawValue
        
        var carbohydrateRow = PickerViewConstants.getRowFromMacronutrient(carbohydrateField.text)
        var carbohydrateComponent = Macronutrients.CARBOHYDRATE.rawValue
        
        var proteinRow = PickerViewConstants.getRowFromMacronutrient(proteinField.text)
        var proteinComponent = Macronutrients.PROTEIN.rawValue
        
        pickerView.selectRow(fatRow, inComponent: fatComponent, animated: true)
        pickerView.selectRow(carbohydrateRow, inComponent: carbohydrateComponent, animated: true)
        pickerView.selectRow(proteinRow, inComponent: proteinComponent, animated: true)
    }
    /**
        MARK: UITextFieldDelegate methods
    **/
    
    func addDoneButtonToActiveTextField() {
        var keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        
        let checkmarkImage = UIImage(named: "Checkmark-25")!
        let checkmarkFilledImage = UIImage(named: "Checkmark Filled-25")!
        let checkmarkImageSize = checkmarkImage.size
        let checkmarkImageFrame = CGRectMake(0, 0, checkmarkImageSize.width, checkmarkImageSize.height)
        
        checkmarkButton = UIButton(frame: checkmarkImageFrame)
        
        checkmarkButton.setBackgroundImage(checkmarkImage, forState: UIControlState.Normal)
        checkmarkButton.setBackgroundImage(checkmarkFilledImage, forState: UIControlState.Selected)
        checkmarkButton.setBackgroundImage(checkmarkFilledImage, forState: UIControlState.Highlighted)
        checkmarkButton.addTarget(self, action: Selector("endEditing:"), forControlEvents: UIControlEvents.TouchUpInside)
        var checkmarkBarButton = UIBarButtonItem(customView: checkmarkButton)
        
        keyboardToolbar.tintColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        keyboardToolbar.items = [flexBarButton, checkmarkBarButton]
        activeTextField!.inputAccessoryView = keyboardToolbar
    }
    
    /**
        MARK: ensure the numbers corresponding to
              the macronutrient percentages add up
              to 100% before allowing the user to
              dismiss the textfield.
    **/
    func toggleCheckmarkButton() {
        var fatPercentage = PickerViewConstants.getRowFromMacronutrient(fatField.text)
        var carbohydratePercentage = PickerViewConstants.getRowFromMacronutrient(carbohydrateField.text)
        var proteinPercentage = PickerViewConstants.getRowFromMacronutrient(proteinField.text)
        var totalPercentage = fatPercentage + carbohydratePercentage + proteinPercentage
        
        if totalPercentage == 100 {
            println("Total adds up to 100%!")
            checkmarkButton.enabled = true
        } else {
            println("Total adds up to \(totalPercentage)%. Try again.")
            checkmarkButton.enabled = false
        }
    }
    
    func endEditing(sender : UIBarButtonItem) {
       activeTextField!.resignFirstResponder()
    }

    /**
        TODO: Instead of filling the entire inputView with
              the pickerView, make a custom view, add the 
              pickerView as a subview with a particular
              frame size (a fraction of the UIView), and 
              add subtitles for the three columns of the 
              pickerView.
    **/
    func addCustomViewToTextFieldInputView() {
        
        
        customView = UIView(frame: activeTextField!.frame)
        customView.backgroundColor = UIColor(red: 60.0/255.0, green: 228.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        pickerView = UIPickerView(frame: CGRectMake(customView.frame.size.width/4, customView.frame.size.height/3, customView.frame.size.width*0.75, customView.frame.size.height*0.50))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    
        customView.addSubview(pickerView)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)

        //addCustomViewToTextFieldInputView()
        addDoneButtonToActiveTextField()
        configureDefaultPickerViewValues()
        
        switch textField {
            case fatField :
                fatField.inputView = pickerView
            case carbohydrateField :
                carbohydrateField.inputView = pickerView
            case proteinField :
                proteinField.inputView = pickerView
            default : return
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}