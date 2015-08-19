//
//  NewGressProfileActivityViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit



class NewGressProfileActivityViewController : UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var activitySlider: UISlider!
    @IBOutlet weak var sedentaryButton: UIButton!
    @IBOutlet weak var metropolitanButton: UIButton!
    @IBOutlet weak var athleteButton: UIButton!
    @IBOutlet weak var exerciseDurationField: UITextField!
    
    var backButton:UIBarButtonItem!
    var forwardButton:UIBarButtonItem!
    var cancelButton:UIBarButtonItem!
    
    var body:BodyInformation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        configureNewProfileProgressBar(NOT_FINISHED)
        configureNavigationItem()
        
        
    }
    
    func setDelegates() {
        
        scrollView.delegate = self
        exerciseDurationField.delegate = self
    }
    
    func configureNavigationItem() {
        backButton = UIBarButtonItem(image: UIImage(named: "Left-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack:"))
        forwardButton = UIBarButtonItem(image: UIImage(named: "Right-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goForward:"))
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancel:"))
        
        navigationItem.rightBarButtonItems = [forwardButton, backButton]
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.65
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.50
            })
        }
    }
    
    func goForward(sender: UIBarButtonItem) {
        return
    }
    
    func goBack(sender: UIBarButtonItem) {
        
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func cancel(sender : UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
        MARK: UIPickerViewDataSource required protocol methods
    **/
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    /**
        MARK: UITextFieldDelegate protocol methods
    **/
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        return
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        return
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    
    
}