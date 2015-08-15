//
//  NewGressProfileBodyViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/14/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse


class NewGressProfileBodyViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var agePickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureNewProfileProgressBar(NOT_FINISHED)
        
        
    }
    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.40
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.28
            })
        }
    }
    
    /**
        MARK: UIPickerView delegate methods
    **/
    
    /**
        TODO: Make sure to hide pickerViews until they the user 
              taps the designated area. Also, fix some of the 
              components/rows problems. Create a UIAlertView that
              contains a sheet so that a user can change their inputs
              without the UIPickerView obstructing their view.
    **/
    
    func setDelegates() {
        agePickerView.delegate = self
        heightPickerView.delegate = self
        weightPickerView.delegate = self
        
        agePickerView.dataSource = self
        heightPickerView.dataSource = self
        weightPickerView.dataSource = self
        
        scrollView.delegate = self
        unitSegmentedControl.selectedSegmentIndex = 0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch pickerView {
            case agePickerView :
                return [BodyInformation().age].count
            case weightPickerView :
                switch unitSegmentedControl.selectedSegmentIndex {
                    case 0 :
                        return BodyInformation().weightSI.count
                    case 1 :
                        return BodyInformation().weightMetric.count
                    default : return 0
                }
            case heightPickerView :
                switch unitSegmentedControl.selectedSegmentIndex {
                    case 0 :
                        return BodyInformation().heightSI.count
                    case 1 :
                        return BodyInformation().heightMetric.count
                    default: return 0
                }
            default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            case agePickerView :
                return BodyInformation().age.count
            case weightPickerView :
                switch unitSegmentedControl.selectedSegmentIndex {
                    case 0 :
                        return BodyInformation().weightSI[component].count
                    case 1 :
                        return BodyInformation().weightMetric[component].count
                    default : return 0
                }
            case heightPickerView :
                switch unitSegmentedControl.selectedSegmentIndex {
                    case 0 :
                        return BodyInformation().heightSI[component].count
                    case 1 :
                        return BodyInformation().heightMetric[component].count
                default: return 0
            }
            default : return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView {
        case agePickerView :
            return "\(BodyInformation().age[row])"
        case weightPickerView :
            switch unitSegmentedControl.selectedSegmentIndex {
            case 0 :
                return BodyInformation().weightSI[component][row]
            case 1 :
                return BodyInformation().weightMetric[component][row]
            default : return ""
            }
        case heightPickerView :
            switch unitSegmentedControl.selectedSegmentIndex {
            case 0 :
                return BodyInformation().heightSI[component][row]
            case 1 :
                return BodyInformation().heightMetric[component][row]
            default: return ""
            }
        default : return ""
        }
    }
    
}