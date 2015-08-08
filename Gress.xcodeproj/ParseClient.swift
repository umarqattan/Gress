//
//  Parse.swift
//  ParseStarterProject
//
//  Created by Umar Qattan on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse


class ParseClient {
    
    
    /**
        MARK: When a person first uses Gress, he/she will choose a username.
              If a username is chosen, the below method will check if it's
              already in use. If it is in use, then it will return true;
              otherwise, it will return false. This will help the user know
              when their chosen username is unique, which will allow them to
              proceed to the application.
    **/
    class func doesUserExist(username : String, completionHandler:(exists:Bool) -> Void) {
        var query = PFUser.query()
        var doesUserExist = false
        query?.whereKey("username", equalTo: username)
        query!.getFirstObjectInBackgroundWithBlock { userObject, downloadError in
            if userObject != nil {
                completionHandler(exists: true)
                println("A user already exists with the name, \(username)")
            } else {
                completionHandler(exists: false)
                println("\(username) is available!")
            }
        }
    }
    
    class func isPasswordSecure(password: String) -> Bool {
        
        var aPassword:NSString = password as NSString
        var range:NSRange
        var capitalCharacterSet = NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        var numberCharacterSet = NSCharacterSet.decimalDigitCharacterSet()
        var specialCharacterSet = NSCharacterSet(charactersInString: "!@#$%^&*()_")
        
        var hasCapitalLetter = false
        var hasNumber = false
        var hasSpecialCharacter = false
        
        for(var i = 0; i < aPassword.length; i++){
            if capitalCharacterSet.characterIsMember(aPassword.characterAtIndex(i)) {
                hasCapitalLetter = true
            }
            if numberCharacterSet.characterIsMember(aPassword.characterAtIndex(i)) {
                hasNumber = true
            }
            if specialCharacterSet.characterIsMember(aPassword.characterAtIndex(i)) {
                hasSpecialCharacter = true
            }
        }
        
        if !hasCapitalLetter {
            println("Could not find capital letter")
        }
        if !hasNumber {
            println("Could not find number")
        }
        if !hasSpecialCharacter {
            println("Could not find special character")
        }
        
        return hasCapitalLetter && hasNumber && hasSpecialCharacter
    }
    
    
    
}