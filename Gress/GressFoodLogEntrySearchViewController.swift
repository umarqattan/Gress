//
//  GressFoodLogEntrySearchViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import UIKit
import CoreData

class GressFoodLogEntrySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    
    
    
    @IBOutlet weak var nutritionixSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noResultsFoundLabel: UILabel!
    var foodLogEntries:[NutritionixFoodEntry] = []
    
    var body:Body!
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }()
    
    
    func registerNibs() {
        tableView.registerNib(UINib(nibName: "FoodLogEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodLogEntryTableViewCell")
        tableView.registerNib(UINib(nibName: "FoodLogEntrySectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "FoodLogEntrySectionHeader")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItem()
        registerNibs()
        setDelegates()
        configureTableView()
    }

    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        nutritionixSearchBar.delegate = self
        
    }
    
    func configureNavigationItem() {
        
        navigationItem.title = "Search Nutritionix"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        
        
    }
    
    func cancel(sender : UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configureTableView() {
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.edgesForExtendedLayout = UIRectEdge.None
        
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        /**
            Search nutritionix for the food corresponding to the text
        **/
        
        
        /*
            dismiss keyboard and start animating
            the activity indicator
        */
        searchBar.resignFirstResponder()
        
        self.noResultsFoundLabel.hidden = true
        activityIndicator.startAnimating()
        
        
        /*
            Deinit foodLogEntries array and clear the tableView
        */
        
        foodLogEntries = []
        tableView.reloadData()
        
        /*
            Request foodLogEntries from Nutritionix
        */
        
        NutritionixClient().getFoodLogEntries(searchBar.text!, results: 10) { foodLogEntries, success, error in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    for foodLogEntry in foodLogEntries! {
                        self.foodLogEntries.append(foodLogEntry)
                    }
                    if self.foodLogEntries.count == 0 {
                        self.noResultsFoundLabel.hidden = false
                    } else {
                        self.tableView.reloadData()
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        tableView.reloadData()
        return true
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.FoodLogEntry.rawValue :
            return UIView.loadFromNibNamed("FoodLogEntrySectionHeader", bundle: nil)
        default : return nil
        }
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return foodLogEntries.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FoodLogEntryTableViewCell", forIndexPath: indexPath) as! FoodLogEntryTableViewCell
        
        let foodLogEntry = foodLogEntries[indexPath.row]
        configureFoodLogEntryCell(cell, foodLogEntry: foodLogEntry)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
    
    func configureFoodLogEntryCell(cell : FoodLogEntryTableViewCell, foodLogEntry : NutritionixFoodEntry) {
        cell.foodLabel.text = "\(foodLogEntry.foodItemName)"
        cell.quantityLabel.text = "\(foodLogEntry.servingWeightGrams) g"
        cell.caloriesLabel.text = "\(foodLogEntry.calories)"
        cell.fatLabel.text = "\(foodLogEntry.fatGrams) g"
        cell.carbohydrateLabel.text = "\(foodLogEntry.carbohydrateGrams) g"
        cell.proteinLabel.text = "\(foodLogEntry.proteinGrams) g"
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /**
            TODO: Push FoodLogEntryViewController
        **/
        
        let gressFoodLogEntryViewController = storyboard?.instantiateViewControllerWithIdentifier("GressFoodLogEntryViewController") as! GressFoodLogEntryViewController
        let foundFoodLogEntry = foodLogEntries[indexPath.row]
        
        gressFoodLogEntryViewController.nutritionixFoodEntry = foundFoodLogEntry
        gressFoodLogEntryViewController.body = body
        gressFoodLogEntryViewController.cameFromFoodLogEntrySearchViewController = true
        gressFoodLogEntryViewController.cameFromFoodLogViewController = false
    
        navigationController?.pushViewController(gressFoodLogEntryViewController, animated: true)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
