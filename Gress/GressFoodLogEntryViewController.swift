//
//  GressFoodLogEntryViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import UIKit
import CoreData


class GressFoodLogEntryViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {

    
    var nutritionixFoodEntry:NutritionixFoodEntry!
    var foodLogEntry:FoodLogEntry!
    var body:Body!
    
    var cameFromFoodLogEntrySearchViewController:Bool = false
    var cameFromFoodLogViewController:Bool = false
    
    @IBOutlet weak var servingSizeField: UITextField!
    @IBOutlet weak var numberOfServingsField: UITextField!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydrateLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    
    var activeTextField: UITextField?
    var checkmarkButton:UIButton!
    var cancelPickerButton:UIButton!
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    
    func registerNibs() {
        tableView.registerNib(UINib(nibName: "FoodLogEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodLogEntryTableViewCell")
        tableView.registerNib(UINib(nibName: "FoodLogEntrySectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "FoodLogEntrySectionHeader")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setDelegates()
        configureNavigationItem()
        configureTableView()
        loadTableViewCells()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if cameFromFoodLogEntrySearchViewController {
            
            
            
        } else if cameFromFoodLogViewController {
            
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        servingSizeField.delegate = self
        numberOfServingsField.delegate = self
        
    }
    
    func configureNavigationItem() {
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveFoodLogEntry:")
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func configureTableView() {
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.edgesForExtendedLayout = UIRectEdge.None
        
    }
    
    func loadTableViewCells() {
        servingSizeField.text = "\(nutritionixFoodEntry.servingWeightGrams) g"
        numberOfServingsField.text = "0"
        caloriesLabel.text = "\(nutritionixFoodEntry.calories)"
        fatLabel.text = "\(nutritionixFoodEntry.fatGrams)"
        carbohydrateLabel.text = "\(nutritionixFoodEntry.carbohydrateGrams)"
        proteinLabel.text = "\(nutritionixFoodEntry.proteinGrams)"
    }
    
    func saveFoodLogEntry(sender : UIBarButtonItem) {
        
        /**
            TODO: Add to the list of added foodlogentries in GressFoodLogViewController
        **/
        
        
        updateFoodLogEntry()
        updateCoreFoodLogEntry()
        CoreDataStackManager.sharedInstance().saveContext()
        
        if cameFromFoodLogEntrySearchViewController {
            
            dismissViewControllerAnimated(true, completion: nil)
            
        } else if cameFromFoodLogViewController {
            
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func updateCoreFoodLogEntry() {
        
        if cameFromFoodLogViewController {
            foodLogEntry.foodItemName = nutritionixFoodEntry.foodItemName
            foodLogEntry.calories = nutritionixFoodEntry.calories
            foodLogEntry.servingSizeQuantity = nutritionixFoodEntry.servingSizeQuantity
            foodLogEntry.servingSizeUnit = nutritionixFoodEntry.servingSizeUnit
            foodLogEntry.servingsPerContainer = nutritionixFoodEntry.servingsPerContainer
            foodLogEntry.servingWeightGrams = nutritionixFoodEntry.servingWeightGrams
            foodLogEntry.fatGrams = nutritionixFoodEntry.fatGrams
            foodLogEntry.carbohydrateGrams = nutritionixFoodEntry.carbohydrateGrams
            foodLogEntry.proteinGrams = nutritionixFoodEntry.proteinGrams
            CoreDataStackManager.sharedInstance().saveContext()
        } else if cameFromFoodLogEntrySearchViewController {
            let dictionary = nutritionixFoodEntry.dictionary()
            foodLogEntry = FoodLogEntry(dictionary: dictionary, context: sharedContext)
            sharedContext.insertObject(foodLogEntry)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    func updateFoodLogEntry() {
        
        nutritionixFoodEntry.servingSizeQuantity = (Int((numberOfServingsField.text! as NSString).floatValue * (servingSizeField.text! as NSString).floatValue))
        nutritionixFoodEntry.calories = (caloriesLabel.text! as NSString).integerValue
        nutritionixFoodEntry.fatGrams = (fatLabel.text! as NSString).integerValue
        nutritionixFoodEntry.carbohydrateGrams = (carbohydrateLabel.text! as NSString).integerValue
        nutritionixFoodEntry.proteinGrams = (proteinLabel.text! as NSString).integerValue
        
    }
    
    func updateNutritionFacts() {
        
        let nutritionFactsMultiplier:Float = (numberOfServingsField.text! as NSString).floatValue
        caloriesLabel.text = "\(Int(Float(nutritionixFoodEntry.calories) * nutritionFactsMultiplier))"
        fatLabel.text = "\(Int(Float(nutritionixFoodEntry.fatGrams) * nutritionFactsMultiplier))"
        carbohydrateLabel.text = "\(Int(Float(nutritionixFoodEntry.carbohydrateGrams) * nutritionFactsMultiplier))"
        proteinLabel.text = "\(Int(Float(nutritionixFoodEntry.proteinGrams) * nutritionFactsMultiplier))"
        
    }
    
    /**
        MARK: UITextFieldDelegate Protocol Methods
    **/
    
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
    
    func endEditing(sender : UIBarButtonItem) {
        switch sender {
        case checkmarkButton:
            activeTextField!.resignFirstResponder()
        default : return
        }
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        addDoneButtonToActiveTextField()

        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        
        switch textField {
            case servingSizeField :
                return
            case numberOfServingsField :
                updateNutritionFacts()
            default : return
        }
        
    }
    
    
    /**
        MARK: UITableViewDelegate Protocol Methods
    **/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case FoodLogEntrySection.Quantity.rawValue :
            switch row {
            case QuantityRow.ServingSize.rawValue :
                print("Serving Size")
            case QuantityRow.NumberOfServings.rawValue :
                print("Number of Servings")
            default : return
            }
        case FoodLogEntrySection.NutritionFacts.rawValue :
            switch row {
            case NutritionFactsRow.Calories.rawValue :
                print("Calories")
            case NutritionFactsRow.Fat.rawValue :
                print("Fat (g)")
            case NutritionFactsRow.Carbohydrate.rawValue :
                print("Carbohydrate (g)")
            case NutritionFactsRow.Protein.rawValue :
                print("Protein (g)")
            default : return
            }
        default : return
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case FoodLogEntrySection.Quantity.rawValue :
            return nutritionixFoodEntry.foodItemName
        case FoodLogEntrySection.NutritionFacts.rawValue :
            return "Nutrition Facts"
        default : return nil
        }
    }
    
    
}
