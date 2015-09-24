//
//  ChangePasswordViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/22/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordAgainTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPasswordAgainTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    @IBAction func changePasswordAction(sender: UIButton) {
        if (newPasswordTextField.text == newPasswordAgainTextField.text && !newPasswordTextField.text!.isEmpty && !newPasswordAgainTextField.text!.isEmpty){
            
            PFUser.currentUser()!.password = newPasswordAgainTextField.text;
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if error == nil{
                    print("Update password success")
                    let alertController = UIAlertController(title: "密碼更新成功", message: "請用新的密碼重新登入，謝謝", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: { (alertAction: UIAlertAction) -> Void in
                        PFUser.logOut()
                        
                        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LogInViewController
                        self.presentViewController(loginViewController, animated: true, completion: nil)
                    })
                    
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    print(error?.localizedDescription)
                }
            })
        }else{
            let alertController = UIAlertController(title: "密碼錯誤", message: "請輸入上下相同一致的密碼", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAcction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(alertAcction);
            
            presentViewController(alertController, animated: true, completion: nil);
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
