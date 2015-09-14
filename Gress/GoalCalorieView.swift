//
//  GoalCalorieView.swift
//  Gress
//
//  Created by Umar Qattan on 9/11/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import UIKit

let nibName = "GoalCalorieView"

@IBDesignable class GoalCalorieView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var view: UIView!
    
    
    
    
    
    @IBOutlet weak var calorieGoalSlider: UISlider!
    @IBOutlet weak var deficitCaloriesLabel: UILabel!
    @IBOutlet weak var maintenanceCaloriesLabel: UILabel!
    @IBOutlet weak var surplusCaloriesLabel: UILabel!
    @IBOutlet weak var goalCaloriesLabel: UILabel!
    
    
    
    
    func setCalorieLabels(goalLevel : Float, calorieGoalArray: [Int]) {
        
        
        var deficitCalories = calorieGoalArray[CalorieGoal.Deficit.rawValue]
        var maintenanceCalories = calorieGoalArray[CalorieGoal.Maintenance.rawValue]
        var surplusCalories = calorieGoalArray[CalorieGoal.Surplus.rawValue]
        
        var defCal:Float = Float(deficitCalories)
        var surCal:Float = Float(surplusCalories)
        
        calorieGoalSlider.minimumValue = defCal
        calorieGoalSlider.maximumValue = surCal
        calorieGoalSlider.enabled = false
        calorieGoalSlider.value = goalLevel * (calorieGoalSlider.maximumValue - calorieGoalSlider.minimumValue) + calorieGoalSlider.minimumValue
        var goalCalories = Int(calorieGoalSlider.value)

        
        
        
        deficitCaloriesLabel.text = "\(deficitCalories)"
        maintenanceCaloriesLabel.text = "\(maintenanceCalories)"
        surplusCaloriesLabel.text = "\(surplusCalories)"
        goalCaloriesLabel.text = "Goal: \(goalCalories)"
        
        
    }
    
    @IBAction func changeCalorieGoal(sender: UISlider) {
        
        goalCaloriesLabel.text = "Goal: \(Int(sender.value))"
        
    }
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        //let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    


}
