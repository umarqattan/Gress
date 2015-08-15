//
//  NewGressProfileViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/13/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse

let FINISHED = true
let NOT_FINISHED = false


class NewGressProfileViewController : UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var newProfilePictureImageView: UIImageView!
    @IBOutlet weak var editProfilePictureButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField:UITextField!
    var keyboardDismissTapGesture: UIGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldDelegates()
        subscribeToKeyboardNotifications()
        configureNewProfileProgressBar(false)
        navigationController?.navigationItem.rightBarButtonItem?.enabled = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.333
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.000
            })
            
        }
    }
    
    func toggleEditProfileButton(enabled : Bool) {
        editProfilePictureButton.enabled = enabled
    }
    
    @IBAction func editProfilePicture(sender: UIButton) {
        
        var alertActionSheet = UIAlertController(title: "Change Profile Picture", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertActionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { UIAlertAction in
                alertActionSheet.dismissViewControllerAnimated(true, completion: nil)
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                } else {
                    println("Camera not available")
            }
            })
        alertActionSheet.addAction(UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default) { UIAlertAction in
                alertActionSheet.dismissViewControllerAnimated(true, completion: nil)
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            })
        alertActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                alertActionSheet.dismissViewControllerAnimated(true, completion: nil)
            })
        
        presentViewController(alertActionSheet, animated: true, completion: nil)
    }
    
    /**
        MARK: UIImagePickerControllerDelegate methods
    **/
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        newProfilePictureImageView.layer.borderWidth = 3
        newProfilePictureImageView.layer.cornerRadius = newProfilePictureImageView.frame.height/2.0
        newProfilePictureImageView.layer.masksToBounds = false
        newProfilePictureImageView.layer.borderColor = UIColor(red: 51.0/255.0, green: 147.0/255.0, blue: 210.0/255.0, alpha: 1.0).CGColor
        newProfilePictureImageView.clipsToBounds = true
        newProfilePictureImageView.contentMode = UIViewContentMode.ScaleAspectFill
        newProfilePictureImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        PROBLEM:  The textFields get obstructed by the
                  keyboard.
        SOLUTION: Post notifications to the defaultNot-
                  ificationCenter whenever the keyboard
                  shows up. Such notifications help to
                  shift the textFields so they're in view.
        LINK:     https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
    **/
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification : NSNotification) {
        
        let keyboardInfo = notification.userInfo
        let keyboardSize = keyboardInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue().size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        
        var aRect = userInputView.frame
        if CGRectContainsPoint(aRect, activeTextField.frame.origin) {
            scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
        }
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
            view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        
        if keyboardDismissTapGesture != nil {
            view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func getKeyboardHeight(notification : NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func dismissKeyboard(gestureRecognizer : UIGestureRecognizer) {
        if (activeTextField != nil) {
            activeTextField.resignFirstResponder()
        } else {
            return
        }
    }
    
    /**
        MARK: When a user cancels making a new profile,
              delete their account and dismiss the view-
              controller.
    **/
    @IBAction func cancelNewProfile(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        MARK: TextFieldDelegate methods
    **/
    
    func setTextFieldDelegates() {
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailAddressField.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        configureNewProfileProgressBar(NOT_FINISHED)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        
        if !firstNameField.text.isEmpty && !lastNameField.text.isEmpty && !emailAddressField.text.isEmpty {
            configureNewProfileProgressBar(FINISHED)
            navigationController?.navigationItem.rightBarButtonItem?.enabled = true
        } else {
            configureNewProfileProgressBar(NOT_FINISHED)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}