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
                        // self.presentViewController
                        println("hIoijk")
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
    
    /**
        MARK: AlertController method when user tries to log in
    **/
    
    /**
    func showAlertView(success: Bool, title: String?, message: String?) {
        var alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var alertAction = UIAlertAction()
        if success {
            alertAction = UIAlertAction(title: "Go to Gress", style: UIAlertActionStyle.Cancel) { UIAlertAction in
                // add a segue here
            }
        } else {
            alertAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler : nil)
        }
        alertController.addAction(alertAction)
        presentViewController(alertController,
            animated: true,
            completion: nil)
    }
    **/
}

