//
//  ForgotPasswordViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/22/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resentBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        resentBtn.layer.cornerRadius = 5
    }
    
    @IBAction func resentEmailAction(sender: UIButton) {
        let email = emailTextField.text
        
        PFUser.requestPasswordResetForEmailInBackground(email!, block: {
            (success: Bool, error: NSError?) -> Void in
            if error == nil{
                print("Resent Email successfully")
                let alertController = UIAlertController(title: "寄出成功", message: "已經重新寄出密碼信", preferredStyle: UIAlertControllerStyle.Alert)
                let goLoginAction = UIAlertAction(title: "前往登入頁面", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction) -> Void in
                    
                    let logInViewController: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LogInViewController
                    self.presentViewController(logInViewController, animated: true, completion: nil)
                })
                
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
                
                alertController.addAction(goLoginAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }else{
                print("erro occur")
                let alertController = UIAlertController(title: "查無此人", message: "並無此信箱，是否仍無註冊呢？", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    
}
