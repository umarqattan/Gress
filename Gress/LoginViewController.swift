//
//  LoginViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//


import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var createAnAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setTextFieldDelegates()
    }
    
    
    @IBAction func createAnAccount(sender: AnyObject) {
        let signUpViewController = storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func login(sender: UIButton) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.loginButton.hidden = true
        })
        activityIndicator.startAnimating()
        
        PFUser.logInWithUsernameInBackground(userNameField.text, password: passwordField.text) { user, downloadError in
            if let error = downloadError {
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    UIView.animateWithDuration(0.3, animations: {
                        self.loginButton.hidden = false
                    })
                    self.showAlertView(false, buttonTitle: "Error", message: error.localizedDescription, completionHandler: nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    UIView.animateWithDuration(0.3, animations: {
                        self.loginButton.hidden = false
                    })
                    self.showAlertView(true, buttonTitle: "Success", message: "Logged in successfully!") { UIAlertAction in
                        
                        let rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileViewController") as! NewGressProfileViewController
                        
                        
                        let newGressProfileNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileNavigationController") as! UINavigationController
                        newGressProfileNavigationController.setViewControllers([rootViewController], animated: true)
                        
                        
                        
                        self.presentViewController(newGressProfileNavigationController, animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    /**
        MARK: UITextFieldDelegate Methods
    **/
    
    func setTextFieldDelegates() {
        userNameField.delegate = self
        passwordField.delegate = self
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !userNameField.text.isEmpty && !passwordField.text.isEmpty {
            loginButton.enabled = true
        } else {
            loginButton.enabled = false
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

