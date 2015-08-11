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

        PFUser.requestPasswordResetForEmailInBackground(email, block: {
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil{
                println("寄出確認信成功")
                let alertController = UIAlertController(title: "成功", message: "寄出確認信成功", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(alertAction);
                self.presentViewController(alertController, animated: true, completion: nil)
                
                //need to add pop to LogInViewController automatically;
                
            }else{
                println("查無此人");
                let alertController = UIAlertController(title: "查無此信箱", message: "查無此人喔", preferredStyle: UIAlertControllerStyle.Alert);
                let alertAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.Default, handler: nil);
                alertController.addAction(alertAction);
                self.presentViewController(alertController, animated: true, completion: nil);
            }
            
        });
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
