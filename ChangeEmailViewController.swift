//
//  ChangeEmailViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/10/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UITableViewController {
    
    @IBOutlet weak var oldEmailField: UITextField!
    @IBOutlet weak var newEmailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldEmailField.text = PFUser.currentUser().email;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"));
        tapGesture.cancelsTouchesInView = true;
        tableView.addGestureRecognizer(tapGesture);
    }
    
    @IBAction func changeEmail(sender: UIButton) {
        
        if newEmailField.text.isEmpty{
            let alertController = UIAlertController(title: "錯誤", message: "新Emial欄位不可空白", preferredStyle: UIAlertControllerStyle.Alert);
            let alertAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil);
            alertController.addAction(alertAction);
            presentViewController(alertController, animated: true, completion: nil);
        }else{
        
            PFUser.currentUser().email = newEmailField.text;
            PFUser.currentUser().saveInBackgroundWithBlock(nil);
            navigationController?.popToRootViewControllerAnimated(true);
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
