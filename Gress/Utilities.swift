//
//  Utilities.swift
//  Gress
//
//  Created by Umar Qattan on 8/12/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /**
        MARK: displays a UIAlertController with the following parameters.
    **/
    
    func showAlertView(success: Bool, buttonTitle: String, message: String?, completionHandler: ((UIAlertAction!) -> Void)!)
    {
        var alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var alertAction = UIAlertAction()
        if success {
            alertAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default, handler: completionHandler)
        } else {
            alertAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Cancel, handler : nil)
        }
        alertController.addAction(alertAction)
        presentViewController(alertController,
            animated: true,
            completion: nil)
    }

}