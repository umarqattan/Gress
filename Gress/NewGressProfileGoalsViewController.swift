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
    
    @IBOutlet weak var macroPieChart: PieChartView!
    
    var backButton:UIBarButtonItem!
    var forwardButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    
    
    var activeTextField:UITextField?
    var pickerView:UIPickerView!
    var customView:UIView!
    var fatLabel:UILabel!
    var carbohydrateLabel:UILabel!
    var proteinLabel:UILabel!
    var totalPercentageLabel:UILabel!
    var totalPercentageInt = 100
    var totalPercentage = "100"
    var checkmarkButton:UIButton!
    var cancelPickerButton:UIButton!
    
    var macroPieChartFatLabel:UILabel!
    var macroPieChartCarbohydrateLabel:UILabel!
    var macroPieChartProteinLabel:UILabel!
    
    
    var body:BodyInformation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureNewProfileProgressBar(NOT_FINISHED)
        configureUserInputView()
        setDelegates()
        configureTextFields()
        setMacroPieChart()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        body = getSharedBodyObject()
        body.nutrition = fatField.text + " " + carbohydrateField.text + " " + proteinField.text
        body.goalLevel = goalSlider.value
        updateSharedBodyObject(body)
        
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
                self.forwardButton.enabled = true
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.74
                self.forwardButton.enabled = false
            })
        }
    }
    
    func configureNavigationItem() {
        backButton = UIBarButtonItem(image: UIImage(named: "Left-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack:"))
        forwardButton = UIBarButtonItem(image: UIImage(named: "Right-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goForward:"))
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancel:"))
        
        navigationItem.rightBarButtonItems = [forwardButton, backButton]
        navigationItem.leftBarButtonItem = cancelButton
    }

    
    func configureUserInputView() {
        userInputView.layer.cornerRadius = 12
        macroPieChart.layer.cornerRadius = 12
    }
    
    func configureTextFields() {
        fatField.text = "15 %"
        carbohydrateField.text = "65 %"
        proteinField.text = "20 %"
    }
    
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelvetiaNeue-Light", size: 15)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = macroNutrients[component][row]
        
        return pickerLabel!
    }
    
    @IBAction func goalSliderChanged(sender: UISlider) {
        configureNewProfileProgressBar(FINISHED)
    }
    
    /**
        MARK: Helper functions to get text from pickerView
              and to add subViews to customView.
    **/
    
    
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
    
    func endEditing(sender : UIBarButtonItem) {
       
        switch sender {
            case checkmarkButton :
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.macroPieChart.fatEndArc = CGFloat((self.fatField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
                    self.macroPieChart.carbohydrateEndArc = CGFloat((self.carbohydrateField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
                    self.macroPieChart.proteinEndArc = CGFloat((self.proteinField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
                    self.macroPieChart.fatPercent = CGFloat((self.fatField.text as NSString).floatValue)
                    self.macroPieChart.carbohydratePercent = CGFloat((self.carbohydrateField.text as NSString).floatValue)
                    self.macroPieChart.proteinPercent = CGFloat((self.proteinField.text as NSString).floatValue)
                    self.addMacroLabelsToPieChart()
                    self.macroPieChart.setNeedsDisplay()
                }
                
                activeTextField!.resignFirstResponder()
            
            case cancelPickerButton :
                
                fatField.text = "15 %"
                carbohydrateField.text = "65 %"
                proteinField.text = "20 %"
                
                macroPieChart.fatEndArc = CGFloat((fatField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
                macroPieChart.carbohydrateEndArc = CGFloat((carbohydrateField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
                macroPieChart.proteinEndArc = CGFloat((proteinField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
                macroPieChart.fatPercent = CGFloat((fatField.text as NSString).floatValue)
                macroPieChart.carbohydratePercent = CGFloat((carbohydrateField.text as NSString).floatValue)
                macroPieChart.proteinPercent = CGFloat((proteinField.text as NSString).floatValue)
                macroPieChart.setNeedsDisplay()
                
                activeTextField!.resignFirstResponder()
            default : return
        }
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
        MARK: Set MacroPieChart sections using the macronutrient
              percentages.
    **/
    
    func setMacroPieChart() {
    
        macroPieChart.clearsContextBeforeDrawing = true
        macroPieChart.fatEndArc = CGFloat((fatField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
        macroPieChart.carbohydrateEndArc = CGFloat((carbohydrateField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
        macroPieChart.proteinEndArc = CGFloat((proteinField.text as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.macroPieChart.setNeedsDisplay()
            self.addMacroLabelsToPieChart()
        }
    }
    
    func addMacroLabelsToPieChart() {
        
        dispatch_async(dispatch_get_main_queue()) {
            var macroPieChartRect = self.macroPieChart.bounds
            var centerPoint = CGPointMake(CGRectGetMidX(macroPieChartRect), CGRectGetMidY(macroPieChartRect))
            var radius:CGFloat = {
                var width = CGRectGetWidth(macroPieChartRect)
                var height = CGRectGetHeight(macroPieChartRect)
                if width > height {
                    return height/2.0
                } else {
                    return width/2.0
                }
            }()
            
            
            var fatHalfAngle:CGFloat = (self.macroPieChart.fatEnd-self.macroPieChart.fatStart)/2.0 + self.macroPieChart.fatStart
            var fatX:CGFloat = centerPoint.x + radius * cos(fatHalfAngle  ) / 2.0
            var fatY:CGFloat = centerPoint.y + radius * sin(fatHalfAngle ) / 2.0
            var fatCenterPoint:CGPoint = CGPointMake(fatX-15, fatY)
            
            var fatPercent = CGFloat((self.fatField.text as NSString).floatValue)
            var fatString = NSString(format: "Fat\n %.2f \\%", fatPercent)
            var fatStringSize = fatString.sizeWithAttributes([NSFontAttributeName : font])
            
            self.macroPieChartFatLabel = UILabel(frame: CGRectMake(fatCenterPoint.x, fatCenterPoint.y, fatStringSize.width, fatStringSize.height))
            self.macroPieChartFatLabel.lineBreakMode = .ByWordWrapping
            self.macroPieChartFatLabel.textAlignment = NSTextAlignment.Center
            self.macroPieChartFatLabel.numberOfLines = 0
            self.macroPieChartFatLabel.text = "Fat\n\(fatPercent)%"
            self.macroPieChartFatLabel.font = font
            
            
            var carbohydrateHalfAngle:CGFloat = (self.macroPieChart.carbohydrateEnd-self.macroPieChart.carbohydrateStart)/2.0 + self.macroPieChart.carbohydrateStart
            var carbohydrateX:CGFloat = centerPoint.x + radius * cos(carbohydrateHalfAngle ) / 2.0
            var carbohydrateY:CGFloat = centerPoint.y + radius * sin(carbohydrateHalfAngle ) / 2.0
            var carbohydrateCenterPoint:CGPoint = CGPointMake(carbohydrateX-15.0, carbohydrateY-10.0)
            
            
            var carbohydratePercent = CGFloat((self.carbohydrateField.text as NSString).floatValue)
            var carbohydrateString = NSString(format: "Carbohydrate\n %.2f \\%", carbohydratePercent)
            var carbohydrateStringSize = carbohydrateString.sizeWithAttributes([NSFontAttributeName : font])
            
            self.macroPieChartCarbohydrateLabel = UILabel(frame: CGRectMake(carbohydrateCenterPoint.x, carbohydrateCenterPoint.y, carbohydrateStringSize.width, carbohydrateStringSize.height))
            self.macroPieChartCarbohydrateLabel.lineBreakMode = .ByWordWrapping
            self.macroPieChartCarbohydrateLabel.textAlignment = NSTextAlignment.Center
            self.macroPieChartCarbohydrateLabel.numberOfLines = 0
            self.macroPieChartCarbohydrateLabel.text = "Carbohydrate\n\(carbohydratePercent)%"
            self.macroPieChartCarbohydrateLabel.font = font
            

            var proteinHalfAngle:CGFloat = (self.macroPieChart.proteinEnd-self.macroPieChart.proteinStart)/2.0 + self.macroPieChart.proteinStart
            var proteinX:CGFloat = centerPoint.x + radius * cos(proteinHalfAngle ) / 2.0
            var proteinY:CGFloat = centerPoint.y + radius * sin(proteinHalfAngle ) / 2.0
            var proteinCenterPoint:CGPoint = CGPointMake(proteinX-10, proteinY)
            
            
            var proteinPercent = CGFloat((self.proteinField.text as NSString).floatValue)
            var proteinString = NSString(format: "Protein\n%.2f\\%", proteinPercent)
            var proteinStringSize = proteinString.sizeWithAttributes([NSFontAttributeName : font])
            
            
            self.macroPieChartProteinLabel = UILabel(frame: CGRectMake(proteinCenterPoint.x, proteinCenterPoint.y, proteinStringSize.width, proteinStringSize.height))
            self.macroPieChartProteinLabel.lineBreakMode = .ByWordWrapping
            self.macroPieChartProteinLabel.textAlignment = NSTextAlignment.Center
            self.macroPieChartProteinLabel.numberOfLines = 0
            self.macroPieChartProteinLabel.text = "Protein\n\(proteinPercent)%"
            self.macroPieChartProteinLabel.font = font

            
            
            self.macroPieChart.addSubview(self.macroPieChartFatLabel)
            self.macroPieChart.addSubview(self.macroPieChartCarbohydrateLabel)
            self.macroPieChart.addSubview(self.macroPieChartProteinLabel)
        }
    }
    
    func removeMacroLabelsFromPieChart() {
        
        dispatch_async(dispatch_get_main_queue()) {
            for subview in self.macroPieChart.subviews {
                if subview as! NSObject == self.macroPieChartFatLabel || subview as! NSObject == self.macroPieChartCarbohydrateLabel || subview as! NSObject == self.macroPieChartProteinLabel {
                    subview.removeFromSuperview()
                }
            }
        }
    
    }
    
    
    /**
        MARK: UITextFieldDelegate methods
    **/
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        
        removeMacroLabelsFromPieChart()
        addCustomViewToTextFieldInputView()
        addDoneButtonToActiveTextField()
        configureDefaultPickerViewValues()
        
        switch textField {
            case fatField :
                fatField.inputView = customView
            case carbohydrateField :
                carbohydrateField.inputView = customView
            case proteinField :
                proteinField.inputView = customView
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