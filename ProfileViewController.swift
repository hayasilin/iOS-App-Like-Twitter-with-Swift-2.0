//
//  ProfileViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/6/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            open.target = self.revealViewController();
            open.action = "revealToggle:";
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        }
        
        accountField.delegate = self;
        emailField.delegate = self;
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        accountField.text = PFUser.currentUser().username;
        emailField.text = PFUser.currentUser().email;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }

    
    
}
