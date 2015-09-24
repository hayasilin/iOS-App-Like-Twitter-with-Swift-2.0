//
//  SlideOutMenuViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/22/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit
import MessageUI

class SlideOutMenuViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func logOutAction(sender: UIButton) {
        PFUser.logOut()
        
        let loginViewController = storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LogInViewController
        presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func sendEmailAction(sender: UIButton) {
        let mailComposeViewController = configureMailComposeViewController()
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }else{
            self.showSendMailErrorAlert()
        }
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["kuanwei.hayasi@gmail.com"])
        mailComposeVC.setSubject("請給我們支持與指教")
        mailComposeVC.setMessageBody("請寫下...", isHTML: false)
        return mailComposeVC
    }
    
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertView(title: "無法寄信", message: "此裝置目前無法寄信，請稍候再重試一次", delegate: self, cancelButtonTitle: "我知道了")
        sendMailErrorAlert.show()
    }
    
    //MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
}
