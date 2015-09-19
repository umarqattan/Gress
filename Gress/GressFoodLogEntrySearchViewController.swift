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
    
    var foodLogEntries:[FoodLogEntry] = []
    
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    
    func registerNibs() {
        tableView.registerNib(UINib(nibName: "FoodLogEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodLogEntryTableViewCell")
        tableView.registerNib(UINib(nibName: "FoodLogEntrySectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "FoodLogEntrySectionHeader")
        
        
    }
    
    func fetchBodies() -> [Body] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "Body")
        let result = sharedContext.executeFetchRequest(fetchRequest, error: error)
        if error != nil {
            println("Could not execute fetch request due to: \(error)")
        }
        return result as! [Body]
    }
    
    func fetchFoodLogs() -> [FoodLog] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "FoodLog")
        let result = sharedContext.executeFetchRequest(fetchRequest, error: error)
        if error != nil {
            println("Could not execute fetch request due to: \(error)")
        }
        return result as! [FoodLog]
    }
    
    func fetchFoodLogEntries() -> [FoodLogEntry] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "FoodLogEntry")
        let result = sharedContext.executeFetchRequest(fetchRequest, error: error)
        if error != nil {
            println("Could not execute fetch request due to: \(error)")
        }
        return result as! [FoodLogEntry]
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

        
        configureNavigationItem()
        registerNibs()
        setDelegates()
        //configureTableView()
    }

    
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        nutritionixSearchBar.delegate = self
        
    }
    
    func configureNavigationItem() {
        
        navigationItem.title = "Search Nutritionix"
        
        
    }
    
   
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        /**
            Search nutritionix for the food corresponding to the text
        **/
        
        searchBar.resignFirstResponder()
        activityIndicator.startAnimating()
        
        foodLogEntries = []
        tableView.reloadData()
        
        NutritionixClient().getFoodLogEntries(searchBar.text, results: 10) { foodLogEntries, success, error in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    for foodLogEntry in foodLogEntries! {
                        //self.sharedContext.insertObject(foodLogEntry)
                        self.foodLogEntries.append(foodLogEntry)
                        print(foodLogEntry)
                        //CoreDataStackManager.sharedInstance().saveContext()
                    }
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
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
    
    
    /**
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0 :
                return 44
        default : return 20.0
        }
    }
    **/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        if foodLogEntries.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FoodLogEntryTableViewCell", forIndexPath: indexPath) as! FoodLogEntryTableViewCell
            var foodLogEntry = foodLogEntries[indexPath.row]
            configureFoodLogEntryCell(cell, foodLogEntry: foodLogEntry)
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
    
    func configureFoodLogEntryCell(cell : FoodLogEntryTableViewCell, foodLogEntry : FoodLogEntry) {
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
        gressFoodLogEntryViewController.foodLogEntry = foodLogEntries[indexPath.row]
        navigationController?.pushViewController(gressFoodLogEntryViewController, animated: true)
        
    }
    
/*
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
*/
    /*
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /**
        MARK: UITextfieldDelegate protocol methods
    **/

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
