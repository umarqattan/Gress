//
//  GressGoalsViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/4/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse




class GressGoalsViewController : UITableViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    /**
        MARK: Calories Section
    **/

    @IBOutlet weak var calorieGoalView: UIView!
    @IBOutlet weak var calorieGoalSlider: UISlider!
    @IBOutlet weak var deficitCaloriesLabel: UILabel!
    @IBOutlet weak var maintenanceCaloriesLabel: UILabel!
    @IBOutlet weak var goalCaloriesLabel: UILabel!
    @IBOutlet weak var surplusCaloriesLabel: UILabel!
    @IBOutlet weak var fatLossButton: UIButton!
    @IBOutlet weak var maintainButton: UIButton!
    @IBOutlet weak var leanGainButton: UIButton!
    
    /**
        MARK: Calories variables
    **/
    
    var deficitCalories:Int = 0
    var maintenanceCalories:Int = 0
    var surplusCalories:Int = 0
    var goalCalories:Int = 0
    var goal:Float!
    
    /**
        MARK: Macronutrients Section
    **/
    
    @IBOutlet weak var macroPieChart: PieChartView!
    @IBOutlet weak var fatGramsLabel: UILabel!
    @IBOutlet weak var fatPercentLabel: UILabel!
    @IBOutlet weak var carbohydrateGramsLabel: UILabel!
    @IBOutlet weak var carbohydratePercentLabel: UILabel!
    @IBOutlet weak var proteinGramsLabel: UILabel!
    @IBOutlet weak var proteinPercentLabel: UILabel!
    
    /**
        MARK: Macronutrient Pie Chart variables
    **/
    
    var fatPercent:CGFloat!
    var carbohydratePercent:CGFloat!
    var proteinPercent:CGFloat!
    
    var fatGrams:Int!
    var carbohydrateGrams:Int!
    var proteinGrams:Int!
    
    var macroPieChartFatLabel:UILabel!
    var macroPieChartCarbohydrateLabel:UILabel!
    var macroPieChartProteinLabel:UILabel!
    
    /**
        MARK: Gress User
    **/
    
    
    var body:Body!
    
    
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
        configureTableView()
        configureNavigationItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let gressTabBarController = parentViewController as? GressTabBarController {
            body = gressTabBarController.body
            setCalorieVariablesAndLabels()
            setMacroPieChart()
            configureNavigationItem()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveGoalCaloriesToParse()
        removeLabelsFromMacroPieChart()
    }
    
    func setDelegates() {
        tableView.delegate = self
        navigationController?.delegate = self
    }
    
    func configureTableView() {
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
    }
    
    func configureNavigationItem() {
        
        self.tabBarController?.navigationItem.title = "Goals"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editGoalLevel:")
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
    }

    
    
    
    /**
        MARK: Initialize body object from Parse user's name and email
              address.

    **/
    func setCalorieVariablesAndLabels() {
        
        /**
            TODO: unexpected behavior when user logs in from
                  the home screen. It goes through the first
                  if block rather than the second.
        **/
        
        setCalorieLabels()
        setMacronutrientLabels(calorieGoalSlider.value)
        setSliderThumbImage(ON)

    }
    
    
    
    func setCalorieLabels() {
        
        var calorieGoalArray = body.getCalorieRange()
        var defCal:Float!
        var surCal:Float!
        
        deficitCalories = calorieGoalArray[CalorieGoal.Deficit.rawValue]
        maintenanceCalories = calorieGoalArray[CalorieGoal.Maintenance.rawValue]
        surplusCalories = calorieGoalArray[CalorieGoal.Surplus.rawValue]

        defCal = Float(deficitCalories)
        surCal = Float(surplusCalories)
        
        calorieGoalSlider.minimumValue = defCal
        calorieGoalSlider.maximumValue = surCal
        calorieGoalSlider.enabled = false
        calorieGoalSlider.value = body.goalLevel * (calorieGoalSlider.maximumValue - calorieGoalSlider.minimumValue) + calorieGoalSlider.minimumValue
        goalCalories = Int(calorieGoalSlider.value)

        deficitCaloriesLabel.text = "\(deficitCalories)"
        maintenanceCaloriesLabel.text = "\(maintenanceCalories)"
        surplusCaloriesLabel.text = "\(surplusCalories)"
        goalCaloriesLabel.text = "Goal: \(goalCalories)"
    }

    func setMacronutrientLabels(calories : Float) {
        var macronutrientGoalArray = body.getMacronutrientsFromCalories(calories)
        
        fatGrams = macronutrientGoalArray[MacronutrientGoal.Fat.rawValue]
        carbohydrateGrams = macronutrientGoalArray[MacronutrientGoal.Carbohydrate.rawValue]
        proteinGrams = macronutrientGoalArray[MacronutrientGoal.Protein.rawValue]
        
        fatPercentLabel.text = "\(Int(body.fatPercent)) %"
        carbohydratePercentLabel.text = "\(Int(body.carbohydratePercent)) %"
        proteinPercentLabel.text = "\(Int(body.proteinPercent)) %"
        
        fatGramsLabel.text = "\(fatGrams) g"
        carbohydrateGramsLabel.text = "\(carbohydrateGrams) g"
        proteinGramsLabel.text = "\(proteinGrams) g"

    }
    
    func setMacroPieChart() {
        
        /**
            MARK: *Draw Macro Pie Chart with the user's macronutrient
                   percentages
        **/
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.macroPieChart.clearsContextBeforeDrawing = true
            self.macroPieChart.fatEndArc = CGFloat((self.fatPercentLabel.text! as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
            self.macroPieChart.carbohydrateEndArc = CGFloat((self.carbohydratePercentLabel.text! as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
            self.macroPieChart.proteinEndArc = CGFloat((self.proteinPercentLabel.text! as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
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
            
            var fatPercent = CGFloat((self.fatPercentLabel.text! as NSString).floatValue)
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
            
            
            var carbohydratePercent = CGFloat((self.carbohydratePercentLabel.text! as NSString).floatValue)
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
            
            
            var proteinPercent = CGFloat((self.proteinPercentLabel.text! as NSString).floatValue)
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
    
    func removeLabelsFromMacroPieChart() {
        dispatch_async(dispatch_get_main_queue()) {
            for subview in self.macroPieChart.subviews {
                if subview as! UILabel == self.macroPieChartFatLabel || subview as! UILabel == self.macroPieChartCarbohydrateLabel || subview as! UILabel == self.macroPieChartProteinLabel {
                    subview.removeFromSuperview()
                }
            }
        }
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
                    println("Goal Calories have been updated")
                }
            }
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    /**
        MARK: drawText(_NSString, _CGPoint) -> UIImage takes an NSString
              and a CGPoint so that an image with text can be drawn on a
              UISlider thumbImage.
    **/
    
        
    
    func setSliderThumbImage(toggle : Int) {
        switch toggle {
        case ON:
            var string = NSString(format: "%d", goalCalories)
            var calorieGoalSliderThumbImage = drawText(string, point: CGPointMake(2, 8))
            //calorieGoalSlider.setThumbImage(calorieGoalSliderThumbImage, forState: UIControlState.Normal)
        case OFF:
            //calorieGoalSlider.setThumbImage(nil, forState: UIControlState.Normal)
            println()
        default : return
        }
    }
    
    @IBAction func changeCalorieGoal(sender: UISlider) {

        goalCalories = Int(sender.value)
        goalCaloriesLabel.text = "Goal: \(goalCalories)"
        
    }
    
    func editGoalLevel(sender : UIBarButtonItem) {
        
        switch sender.title! {
        case EDIT:
            tabBarController?.navigationItem.rightBarButtonItem?.title = DONE
            setSliderThumbImage(OFF)
            calorieGoalSlider.enabled = true
            
        case DONE:
            tabBarController?.navigationItem.rightBarButtonItem?.title = EDIT
            setMacronutrientLabels(calorieGoalSlider.value)
            setSliderThumbImage(ON)
            
            
            body.goalLevel = (calorieGoalSlider.value - calorieGoalSlider.minimumValue)/(calorieGoalSlider.maximumValue - calorieGoalSlider.minimumValue)
            body.goalCalories = goalCalories
            calorieGoalSlider.enabled = false
            body.printBodyInformation()
            saveGoalCaloriesToParse()
            
        default : return
        }
    }

    
    func logout(sender : UIBarButtonItem) {
        saveGoalCaloriesToParse()
        self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }

}