//
//  GressTabBarController.swift
//  Gress
//
//  Created by Umar Qattan on 9/5/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit
import Parse

class GressTabBarController : UITabBarController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logout:"))
        
        navigationItem.leftBarButtonItem = logoutButton
        
        
    }
    func logout(sender : UIBarButtonItem) {
        /**
            TODO: Update Gress User before s/he logs out
        **/
        
        dispatch_async(dispatch_get_main_queue()) {
            
        
            PFUser.logOutInBackground()
            
            self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            
            
            
        }
        
        
    }
    
    
    
}