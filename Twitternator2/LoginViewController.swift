//
//  LoginViewController.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/7/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import UIKit
import TwitterKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField:UITextField!
    var textToSearch:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        // Dispatch after a second
        delay(1, closure: {
            self.loginAsGuest()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginAsGuest() {
        
        Twitter.sharedInstance().logInGuestWithCompletion { guestSession, error in
            if (guestSession != nil) {
                // make API calls that do not require user auth
                println("Logged as guest")
            } else {
                SweetAlert().showAlert("Failed to access Twitter please try again!")
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text != "" {
            textToSearch = textField.text
            textField.text = ""
            performSegueWithIdentifier("ShowTweets", sender: self)
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTweets" {
            let vc = segue.destinationViewController as! FeedViewController
            vc.textToSearch = textToSearch
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}

