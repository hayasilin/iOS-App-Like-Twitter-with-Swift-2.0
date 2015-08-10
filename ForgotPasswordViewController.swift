//
//  ForgotPasswordViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/8/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self;
    }
    
    @IBAction func forgotPawwrod(sender: UIButton) {
        var email = self.emailField.text
        PFUser.requestPasswordResetForEmailInBackground(email, block: nil);
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true);
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
