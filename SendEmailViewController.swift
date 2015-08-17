//
//  SendEmailViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/17/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit
import MessageUI

class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var mailAddress: String!;
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.startAnimating();
        
        let mailComposeViewController = configureMailComposeViewController();
        
        if MFMailComposeViewController.canSendMail(){
            
            self.presentViewController(mailComposeViewController, animated: true, completion: nil);
        }else{
            self.showSendMailErrorAlert();
        }
        
        println(mailAddress);
        
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
        
        //結束後回到TimeLineTableViewController
        let timelineVC = storyboard?.instantiateViewControllerWithIdentifier("swVC") as! SWRevealViewController;
        presentViewController(timelineVC, animated: true, completion: nil);
        
        indicatorView.startAnimating();

    }


}
