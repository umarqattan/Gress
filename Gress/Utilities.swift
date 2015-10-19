//
//  Utilities.swift
//  Gress
//
//  Created by Umar Qattan on 8/12/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation
import UIKit



extension String {
    
    var length : Int {
        return self.characters.count

    }
    
    
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}

extension UIViewController {
    
    /**
        MARK: displays a UIAlertController with the following parameters.
    **/
    
    
    
    
    func showAlertView(success: Bool, buttonTitle: String, message: String?, completionHandler: ((UIAlertAction!) -> Void)!)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
    
    /**
        MARK: methods to deal with a keyboard showing and hiding
    **/
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification : NSNotification, gestureRecognizer: UIGestureRecognizer?, activeTextField: UITextField, scrollView: UIScrollView, aView: UIView) {
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, getKeyboardHeight(notification), 0.0)
        scrollView.contentInset = contentInsets
        
        let aRect = aView.frame
        if CGRectContainsPoint(aRect, activeTextField.frame.origin) {
            scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
        }
        if gestureRecognizer == nil {
            let aGestureRecognizer:UIGestureRecognizer? = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
            view.addGestureRecognizer(aGestureRecognizer!)
        }
    }
    
    func keyboardWillHide(notification : NSNotification, gestureRecognizer: UIGestureRecognizer?, activeTextField: UITextField, scrollView: UIScrollView, aView: UIView) {
        
        if gestureRecognizer != nil {
            var aGestureRecognizer: UIGestureRecognizer? = gestureRecognizer
            view.removeGestureRecognizer(aGestureRecognizer!)
            aGestureRecognizer = nil
        }
        
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.contentOffset = CGPointMake(0.0, 0.0)
        scrollView.scrollRectToVisible(scrollView.frame, animated: true)
        
    }
    
    func getKeyboardHeight(notification : NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func dismissKeyboard(gestureRecognizer : UIGestureRecognizer, activeTextField: UITextField?) {
        if (activeTextField != nil) {
            activeTextField!.resignFirstResponder()
        } else {
            return
        }
    }
    
    func drawText(text : NSString, point : CGPoint) -> UIImage {
        
        let size = CGSizeMake(31, 31);
        UIGraphicsBeginImageContextWithOptions(size, true, 0);
        
        UIColor.whiteColor().setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        let font = UIFont(name: "HelveticaNeue", size: 12.0)!
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRectMake(0, 15, image.size.width, image.size.height))
        let rect:CGRect = CGRectMake(point.x, point.y, image.size.width, image.size.height)
        UIColor.whiteColor().set()
        text.drawInRect(CGRectIntegral(rect), withAttributes: [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)])
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return newImage
        
    }

    
    
    
}
    

    

