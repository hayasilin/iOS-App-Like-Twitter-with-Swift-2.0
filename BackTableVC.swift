//
//  BackTableVC.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/1/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    
    
    override func viewDidLoad() {
        
    }
    
    
    
    
    @IBAction func logOutAction(sender: UIButton) {
        PFUser.logOut()

        var logInSignUpVC: LogInSignUpViewController = storyboard!.instantiateViewControllerWithIdentifier("logInSignUp") as! LogInSignUpViewController;
        
        self.presentViewController(logInSignUpVC, animated: true, completion: nil);        
    }
    
    
    
}
