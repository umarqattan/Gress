//
//  NewGressProfileNavigationController.swift
//  Gress
//
//  Created by Umar Qattan on 8/18/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit



extension UINavigationController {
    
    func cancel(sender : UIBarButtonItem) {
        let viewControllers = navigationController?.popToRootViewControllerAnimated(true)
        if viewControllers?.count == 0 {
            println("Cannot cancel")
            return
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func goBack(sender: UIBarButtonItem) {
        let viewControllers = navigationController?.popToRootViewControllerAnimated(true)
        if viewControllers?.count == 0 {
            println("Cannot cancel")
            return
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func goForward(sender: UIBarButtonItem) {
        
    }

}


class NewGressProfileNavigationController : UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let rootViewController = storyboard?.instantiateViewControllerWithIdentifier("NewGressProfileViewController") as! NewGressProfileViewController
        navigationController?.setViewControllers([rootViewController], animated: true)

        
        let backButton = UIBarButtonItem(image: UIImage(named: "Left-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goBack:"))
        let forwardButton = UIBarButtonItem(image: UIImage(named: "Right-32"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("goForward:"))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancel:"))
        
        
        let items:[AnyObject]? = [forwardButton, backButton]
        navigationItem.setRightBarButtonItems(items, animated: true)
        navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        
    }
    
    
    
    
    
}