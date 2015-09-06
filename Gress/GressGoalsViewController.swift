//
//  GressGoalsViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/4/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit

let CALORIE_GOAL:Int = 0
let MACRONUTRIENT_GOAL:Int = 1

enum ReuseIdentifier:String {
    case Calorie = "CalorieTableViewCell"
    case MacronutrientPieChart = "MacronutrientPieChartTableViewCell"
    case Fat = "FatTableViewCell"
    case Carbohydrate = "CarbohydrateTableViewCell"
    case Protein = "ProteinTableViewCell"
}

enum MacronutrientSection:Int {
    case PieChart = 0
    case Fat = 1
    case Carbohydrate = 2
    case Protein = 3
}

class GressGoalsViewController : UITableViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    /**
        MARK: Calories Section
    **/

    
    @IBOutlet weak var calorieGoalSlider: UISlider!
    @IBOutlet weak var deficitCalories: UILabel!
    @IBOutlet weak var maintenanceCalories: UILabel!
    @IBOutlet weak var surplusCalories: UILabel!
    @IBOutlet weak var fatLossButton: UIButton!
    @IBOutlet weak var maintainButton: UIButton!
    @IBOutlet weak var leanGainButton: UIButton!
    
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
    
    var macroPieChartFatLabel:UILabel!
    var macroPieChartCarbohydrateLabel:UILabel!
    var macroPieChartProteinLabel:UILabel!
    
    
    
    /**
        MARK: Gress User
    **/
    
    var body:BodyInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setMacroPieChart()
        navigationController?.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        body = getSharedBodyObject()
        configureNavigationItem()
    }
    
    func setDelegates() {
        tableView.delegate = self
        
    }
    
    func configureNavigationItem() {
        
        self.tabBarController?.navigationItem.title = "Goals"
        
    }

    
    
    /**
    func setNibs() {
        let calorieTableViewCellNib = UINib(nibName: "CalorieTableViewCellNib", bundle: nil)
        let macroPieChartTableViewCellNib = UINib(nibName: "MacroPieChartTableViewCellNib", bundle: nil)
        let fatTableViewCellNib = UINib(nibName: "FatTableViewCellNib", bundle: nil)
        let carbohydrateTableViewCellNib = UINib(nibName: "CarbohydrateTableViewCellNib", bundle: nil)
        let proteinTableViewCellNib = UINib(nibName: "ProteinTableViewCellNib", bundle: nil)
        
        
        tableView.registerNib(calorieTableViewCellNib, forCellReuseIdentifier: ReuseIdentifier.Calorie.rawValue)
        tableView.registerNib(macroPieChartTableViewCellNib, forCellReuseIdentifier: ReuseIdentifier.MacronutrientPieChart.rawValue)
        tableView.registerNib(fatTableViewCellNib, forCellReuseIdentifier: ReuseIdentifier.Fat.rawValue)
        tableView.registerNib(carbohydrateTableViewCellNib, forCellReuseIdentifier: ReuseIdentifier.Carbohydrate.rawValue)
        tableView.registerNib(proteinTableViewCellNib, forCellReuseIdentifier: ReuseIdentifier.Protein.rawValue)
    }
    
**/
    func setMacroPieChart() {
        
        /**
            TODO: *Draw Macro Pie Chart with the user's macronutrient
                   percentages
        **/
        
        macroPieChart.clearsContextBeforeDrawing = true
        macroPieChart.fatEndArc = CGFloat((fatPercentLabel.text! as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
        macroPieChart.carbohydrateEndArc = CGFloat((carbohydratePercentLabel.text! as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
        macroPieChart.proteinEndArc = CGFloat((proteinPercentLabel.text! as NSString).floatValue)/100.0 * 2 * CGFloat(M_PI)
        
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
    
    @IBAction func changeCalorieGoal(sender: UISlider) {
        /**
            TODO: *Change color of calorieGoalSlider at certain values
                  *Change fatGrams.text, carbohydrateGrams.textm and
                   proteinGrams.text based on a formula
        **/
        
    }
    
    func setCalorieGoalSliderValues() {
        /** 
            TODO: *Change deficitCalories.text, maintenanceCalories.text,
                   and surplusCalories.text when a user logs in.
        **/
        
        
    }
    
    
    
    
    
    
    
}