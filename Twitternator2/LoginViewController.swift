//
//  LoginViewController.swift
//  Twitternator2
//
//  Created by Bernardo Santana on 9/7/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

import UIKit
import TwitterKit


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showUserStream(sender: UIButton) {
        
        if Twitter.sharedInstance().session() == nil {
            Twitter.sharedInstance().logInWithCompletion { session, error in
                if (session != nil) {
                    println("signed in as \(session.userName)");
                    self.performSegueWithIdentifier("ShowUserStream", sender: self)
                } else {
                    println("error: \(error.localizedDescription)");
                    let alertController = UIAlertController(title: "Whoops", message: "Could not login twitter. Please try again!", preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                        // ...
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.presentViewController(alertController, animated: true) {
                    }
                }
            }
        } else {
            performSegueWithIdentifier("ShowUserStream", sender: self)
        }
    }
    
    @IBAction func showRandomStream(sender: UIButton) {
        performSegueWithIdentifier("ShowRandomStream", sender: self)
    }
    

}

