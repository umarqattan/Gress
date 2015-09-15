//
//  NewGressProfileViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/13/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Parse

let FINISHED = true
let NOT_FINISHED = false


class NewGressProfileViewController : UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var newProfileProgressBar: UIProgressView!
    @IBOutlet weak var newProfilePictureImageView: UIImageView!
    @IBOutlet weak var editProfilePictureButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField:UITextField?
    var keyboardDismissTapGesture: UIGestureRecognizer!
    var forwardButton:UIBarButtonItem!
    var backButton:UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var height:CGFloat!
    
    var body:Body!
    
    
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func fetchBodies() -> [Body] {
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "Body")
        let result = sharedContext.executeFetchRequest(fetchRequest, error: error)
        if error != nil {
            println("Could not execute fetch request due to: \(error)")
        }
        return result as! [Body]
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
        
        setDelegates()
        
        configureUserInputView()
        configureNavigationItem()
        configureNewProfileProgressBar(false)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    func updateSharedBodyWithPersonal() {
        body.firstName = firstNameField.text
        body.lastName = lastNameField.text
        body.fullName = firstNameField.text + " " + lastNameField.text
        body.email = emailAddressField.text
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func goForward(sender: UIBarButtonItem) {
        
        updateSharedBodyWithPersonal()
       
        
        let bodyInformationViewController = storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileBodyViewController") as! NewGressProfileBodyViewController
        bodyInformationViewController.body = body
        navigationController?.pushViewController(bodyInformationViewController, animated: true)
    }
    
    /**
        MARK: If a new user decides to cancel making a profile,
              then the user must be deleted from both Parse and
              Core Data.
    **/
    func cancel(sender: UIBarButtonItem) {
        var user:PFUser = PFUser.currentUser()!
        
        /**
            Delete from CoreData first so that we can use Parse
            to get the currentUser.
        **/
        let username = user.valueForKey(Body.Keys.USER_NAME) as! String
        let currentBody = findBodyWithCurrentUserName(username)!
        sharedContext.deleteObject(currentBody)
        
        
        /**
            Delete user from Parse
        **/
        user.delete()
        
        /**
            Go back to the home screen
        **/
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func configureNavigationItem() {
        forwardButton = UIBarButtonItem(image: UIImage(named: "Right-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goForward:"))
        forwardButton.enabled = false
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancel:"))
        cancelButton.enabled = true
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItems = [forwardButton]

    }
    
    func configureUserInputView() {
        userInputView.layer.cornerRadius = 12
    }

    
    func configureNewProfileProgressBar(finished: Bool) {
        if finished {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.28
                self.forwardButton.enabled = true
            })
        } else {
            UIView.animateWithDuration(1.5, animations: {
                self.newProfileProgressBar.progress = 0.000
                self.forwardButton.enabled = false
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
    
    
    
    func keyboardWillShow(notification : NSNotification) {
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, getKeyboardHeight(notification), 0.0)
        scrollView.contentInset = contentInsets
        
        var aRect = userInputView.frame
        if CGRectContainsPoint(aRect, activeTextField!.frame.origin) {
            scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
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
        scrollView.contentOffset = CGPointMake(0.0, 0.0)
        scrollView.scrollRectToVisible(scrollView.frame, animated: true)
        
    }
    
    func dismissKeyboard(gestureRecognizer : UIGestureRecognizer) {
        if (activeTextField != nil) {
            activeTextField!.resignFirstResponder()
        } else {
            return
        }
    }
    
    /**
        MARK: When a user cancels making a new profile,
              delete their account and dismiss the view-
              controller.
    **/
    
    
    /**
        MARK: TextFieldDelegate methods
    **/
    
    func setDelegates() {
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailAddressField.delegate = self
        scrollView.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        
        configureNewProfileProgressBar(NOT_FINISHED)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
        
        if !firstNameField.text.isEmpty && !lastNameField.text.isEmpty && !emailAddressField.text.isEmpty {
            configureNewProfileProgressBar(FINISHED)
        } else {
            configureNewProfileProgressBar(NOT_FINISHED)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}