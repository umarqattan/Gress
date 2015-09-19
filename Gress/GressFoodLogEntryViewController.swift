//
//  GressFoodLogEntryViewController.swift
//  Gress
//
//  Created by Umar Qattan on 9/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import UIKit

class GressFoodLogEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var foodLogEntry:FoodLogEntry!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setDelegates()
        configureNavigationItem()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureNavigationItem() {
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveFoodLogEntry:")
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveFoodLogEntry(sender : UIBarButtonItem) {
        
        /**
            TODO: Add to the list of added foodlogentries in GressFoodLogViewController
        **/
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
