//
//  GressFoodLogViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import UIKit
import CoreData

class GressFoodLogViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    var addFoodLogEntryButton:UIBarButtonItem!
    var editFoodLogEntriesButton:UIBarButtonItem!
    var body:Body!
    var foodLogEntries:[NutritionixFoodEntry] = []
    var coreFoodLogEntries:[FoodLogEntry] = []
    
    
    
    
    var temporaryContext : NSManagedObjectContext!
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }()

    
    func fetchFoodLogEntries() -> [FoodLogEntry] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "FoodLogEntry")
        let result = sharedContext.executeFetchRequest(fetchRequest, error: error)
        if error != nil {
            println("Could not execute fetch request due to: \(error)")
        }
        return result as! [FoodLogEntry]
    }
    
    func fetchFBodies() -> [Body] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "Body")
        let result = sharedContext.executeFetchRequest(fetchRequest, error: error)
        if error != nil {
            println("Could not execute fetch request due to: \(error)")
        }
        return result as! [Body]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gressTabBarController = tabBarController as! GressTabBarController
        body = gressTabBarController.body
        setDelegates()
        configureTableView()
        configureNavigationItem()
        registerNibs()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var parentTabBarController = tabBarController as! GressTabBarController
        body = parentTabBarController.body
        body.printBodyInformation()
        
        coreFoodLogEntries = fetchFoodLogEntries()
        
        
        configureNavigationItem()
        configureTableView()
        
    }

    func registerNibs() {
        tableView.registerNib(UINib(nibName: "FoodLogEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodLogEntryTableViewCell")
        tableView.registerNib(UINib(nibName: "FoodLogEntrySectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "FoodLogEntrySectionHeader")
        
    }

    func configureCell(cell : FoodLogEntryTableViewCell, foodLogEntry : FoodLogEntry) {
        cell.foodLabel.text = "\(foodLogEntry.foodItemName)"
        cell.quantityLabel.text = "\(foodLogEntry.servingSizeQuantity) g"
        cell.caloriesLabel.text = "\(foodLogEntry.calories)"
        cell.fatLabel.text = "\(foodLogEntry.fatGrams) g"
        cell.carbohydrateLabel.text = "\(foodLogEntry.carbohydrateGrams) g"
        cell.proteinLabel.text = "\(foodLogEntry.proteinGrams) g"
    }
    
    func configureNavigationItem() {
        
        tabBarController?.navigationItem.title = "Food Log"
        
        addFoodLogEntryButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFoodLogEntry:")
        editFoodLogEntriesButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editFoodLogEntries:")
        
        tabBarController?.navigationItem.rightBarButtonItems = [addFoodLogEntryButton, editFoodLogEntriesButton]
        
    }
    
    func configureTableView() {
        
        tabBarController?.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()

        }
    }
    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func editFoodLogEntries(sender : UIBarButtonItem) {
        
        switch sender.title! {
            case EDIT:
                editFoodLogEntriesButton.title = DONE
            case DONE:
                editFoodLogEntriesButton.title = EDIT
            default : return
        }
    }
    
    func addFoodLogEntry(sender : UIBarButtonItem) {
        
        let gressFoodLogEntrySearchNavigationController = storyboard?.instantiateViewControllerWithIdentifier("GressFoodLogEntrySearchNavigationController") as! UINavigationController
        let gressFoodLogEntrySearchViewController = gressFoodLogEntrySearchNavigationController.childViewControllers[0] as! GressFoodLogEntrySearchViewController
        gressFoodLogEntrySearchViewController.body = body
        
        presentViewController(gressFoodLogEntrySearchNavigationController, animated: true, completion: nil)
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var gressFoodLogEntryViewController = storyboard?.instantiateViewControllerWithIdentifier("GressFoodLogEntryViewController") as! GressFoodLogEntryViewController
    
        let editFoodLogEntry = coreFoodLogEntries[indexPath.row]
        
        let nutritionixEditFoodLogEntry = NutritionixFoodEntry(dictionary: editFoodLogEntry.dictionary())
        
        gressFoodLogEntryViewController.foodLogEntry = editFoodLogEntry
        gressFoodLogEntryViewController.nutritionixFoodEntry = nutritionixEditFoodLogEntry
        gressFoodLogEntryViewController.cameFromFoodLogEntrySearchViewController = false
        gressFoodLogEntryViewController.cameFromFoodLogViewController = true
        tabBarController?.navigationController?.pushViewController(gressFoodLogEntryViewController, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreFoodLogEntries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cellReuseIdentifier = "FoodLogEntryTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! FoodLogEntryTableViewCell
        
        let foodLogEntry = coreFoodLogEntries[indexPath.row]
        
        configureCell(cell, foodLogEntry: foodLogEntry)
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if editFoodLogEntriesButton.title == DONE  {
            return UITableViewCellEditingStyle.Delete
        }
        return UITableViewCellEditingStyle.None
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editFoodLogEntriesButton.title == DONE && editingStyle == UITableViewCellEditingStyle.Delete {
            
            let entryToDelete = foodLogEntries[indexPath.row]
            
            for entry in fetchFoodLogEntries() {
                if entry.isEqualToNutritionixEntry(entryToDelete) {
                    sharedContext.deleteObject(entry)
                }
            }
            CoreDataStackManager.sharedInstance().saveContext()
            
            dispatch_async(dispatch_get_main_queue()) {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.reloadData()
            }
        }
    }
    
    
    /**
        MARK: NSFetchedResultsControllerDelegate protocol methods
    **/

}
