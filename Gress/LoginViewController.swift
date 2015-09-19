//
//  LoginViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import Foundation

import UIKit
import CoreData
import Parse


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var createAnAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        NutritionixClient.buildSearchURL("tofu", results: 10)
        NutritionixClient.getFields()
        setTextFieldDelegates()
        configureUserInputView()
    }
    
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
                        
                        let user:PFUser = PFUser.currentUser()!
                        if let alreadyCompletedProfile = user.valueForKey("complete_profile") as? Bool {
                            if alreadyCompletedProfile {
                                
                                let username = user["username"] as! String
                                let body = self.findBodyWithCurrentUserName(username)
                                
                                
                                let gressTabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("GressTabBarController") as! GressTabBarController
                                gressTabBarController.body = body
                                let gressNavigationController = UINavigationController(rootViewController: gressTabBarController)
                                self.presentViewController(gressNavigationController, animated: true, completion: nil)
                            } else {
                                let rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileViewController") as! NewGressProfileViewController
                                let newGressProfileNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileNavigationController") as! UINavigationController
                                newGressProfileNavigationController.setViewControllers([rootViewController], animated: true)
                                self.presentViewController(newGressProfileNavigationController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func configureUserInputView() {
        userInputView.layer.cornerRadius = 12
        loginButtonView.layer.cornerRadius = 12
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

