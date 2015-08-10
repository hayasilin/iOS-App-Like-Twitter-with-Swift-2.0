//
//  ChangePasswordViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/10/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UITableViewController {
    

    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var newPasswordAgainField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    @IBAction func changePassword(sender: UIButton) {
        
        if (newPasswordField.text == newPasswordAgainField.text && !newPasswordField.text.isEmpty && !newPasswordAgainField.text.isEmpty){
            
        PFUser.currentUser().password = newPasswordAgainField.text;
        PFUser.currentUser().saveInBackgroundWithBlock(nil);
            
        navigationController?.popToRootViewControllerAnimated(true);
            
        }else{
            let alertController = UIAlertController(title: "密碼錯誤", message: "請輸入上下相同一致的密碼", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAcction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(alertAcction);
            
            presentViewController(alertController, animated: true, completion: nil);
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
