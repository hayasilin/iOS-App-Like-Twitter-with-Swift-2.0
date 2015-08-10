//
//  BackTableVC.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/1/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import Foundation
import MessageUI

class BackTableVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func logOutAction(sender: UIButton) {
        PFUser.logOut()
        var logInSignUpVC: LogInSignUpViewController = storyboard!.instantiateViewControllerWithIdentifier("logInSignUp") as! LogInSignUpViewController;
        self.presentViewController(logInSignUpVC, animated: true, completion: nil);        
    }
    
    @IBAction func sendEmail(sender: UIButton) {
        let mailComposeViewController = configureMailComposeViewController();
        
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mailComposeViewController, animated: true, completion: nil);
        }else{
            self.showSendMailErrorAlert();
        }
        
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController();
        mailComposerVC.mailComposeDelegate = self;
        mailComposerVC.setToRecipients(["kuanwei.hayasi@gmail.com"]);
        mailComposerVC.setSubject("請給我們支持與指教");
        mailComposerVC.setMessageBody("請寫下...", isHTML: false);
        
        return mailComposerVC;
    }
    
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertView(title: "無法寄信", message: "裝置無法寄信，請再重試一次", delegate: self, cancelButtonTitle: "我知道了");
        sendMailErrorAlert.show();
    }
    
    //MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil);
    }
    
}
