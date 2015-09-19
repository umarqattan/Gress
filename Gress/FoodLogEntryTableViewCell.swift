//
//  FoodLogEntryTableViewCell.swift
//  Gress
//
//  Created by Umar Qattan on 9/17/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import UIKit


class FoodLogEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydrateLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
