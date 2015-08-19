//
//  SignUpViewController.swift
//  Gress
//
//  Created by Umar Qattan on 8/4/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SignUpViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameValidImageView: UIImageView!
    @IBOutlet weak var passwordValidImageView: UIImageView!
    @IBOutlet weak var userNameValidActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordValidActivityIndicator: UIActivityIndicatorView!
    var userNameExists = false
    var passwordIsSecure = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldDelegates()
        configureValidImageViews()
        configureButtons()
    }
    
    @IBAction func login(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUp(sender: UIButton) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.signUpButton.hidden = true
        })
        activityIndicator.startAnimating() // <-- Indicate that user is being created
        
        let user = PFUser()
        user.username = userNameField.text
        user.password = passwordField.text
        
        user.signUpInBackgroundWithBlock { success, downloadError in
            if let error = downloadError {
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    UIView.animateWithDuration(0.3, animations: {
                        self.signUpButton.hidden = false
                    })
                    self.showAlertView(success, buttonTitle: "Dismiss", message: error.localizedDescription, completionHandler: nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    UIView.animateWithDuration(0.3, animations: {
                        self.signUpButton.hidden = false
                    })
                    self.showAlertView(success, buttonTitle: "Get Started!", message: "Hooray, you are now apart of Gress!") { UIAlertAction in
                        
                        let rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileViewController") as! NewGressProfileViewController
                        let newGressProfileNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileNavigationController") as! UINavigationController
                        newGressProfileNavigationController.setViewControllers([rootViewController], animated: true)
                        self.presentViewController(newGressProfileNavigationController, animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    func configureButtons() {
        signUpButton.enabled = false
    }
    
    func configureValidImageViews() {
        
        userNameValidActivityIndicator.stopAnimating()
        passwordValidActivityIndicator.stopAnimating()
        userNameValidImageView.hidden = true
        passwordValidImageView.hidden = true
    }
    
    /**
        MARK: UITextFieldDelegate protocol methods
    **/
    
    func setTextFieldDelegates() {
        userNameField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == userNameField {
            UIView.animateWithDuration(0.3, animations: {
                textField.text = ""
                self.userNameValidImageView.hidden = true
            })
        }
        if textField == passwordField {
            UIView.animateWithDuration(0.3, animations: {
                self.passwordValidImageView.hidden = true
                textField.text = ""
            })
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text.isEmpty {
            textField.resignFirstResponder()
            return
        }
        if textField == userNameField {
            userNameValidActivityIndicator.startAnimating()
            ParseClient.doesUserExist(userNameField.text) { exists in
                if exists {
                    self.userNameExists = true
                    dispatch_async(dispatch_get_main_queue()) {
                        UIView.animateWithDuration(0.3, animations: {
                            self.userNameValidImageView.image = UIImage(named: "Cancel Filled-32")
                            self.userNameValidImageView.hidden = false
                            self.userNameValidActivityIndicator.stopAnimating()
                        })
                    }
                } else {
                    self.userNameExists = false
                    dispatch_async(dispatch_get_main_queue()) {
                        UIView.animateWithDuration(0.3, animations: {
                            self.userNameValidImageView.image = UIImage(named: "Ok Filled-32")
                            self.userNameValidImageView.hidden = false
                            self.userNameValidActivityIndicator.stopAnimating()
                        })
                    }
                }
            }
        }
        if textField == passwordField {
            passwordValidActivityIndicator.startAnimating()
            if !ParseClient.isPasswordSecure(passwordField.text) {
                self.passwordIsSecure = false
                dispatch_async(dispatch_get_main_queue()) {
                    UIView.animateWithDuration(0.3, animations: {
                        self.passwordValidImageView.image = UIImage(named: "Cancel Filled-32")
                        self.passwordValidImageView.hidden = false
                        self.passwordValidActivityIndicator.stopAnimating()
                    })
                }
            } else {
                self.passwordIsSecure = true
                dispatch_async(dispatch_get_main_queue()) {
                    UIView.animateWithDuration(0.3, animations: {
                        self.passwordValidImageView.image = UIImage(named: "Ok Filled-32")
                        self.passwordValidImageView.hidden = false
                        self.passwordValidActivityIndicator.stopAnimating()
                        
                    })
                }
            }
        }
        if !userNameExists && passwordIsSecure {
            dispatch_async(dispatch_get_main_queue()) {
                self.signUpButton.enabled = true
            }
        } else {
            signUpButton.enabled = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}