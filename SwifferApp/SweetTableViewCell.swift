//
//  SweetTableViewCell.swift
//  SwifferApp
//
//  Created by Kareem Khattab on 11/8/14.
//  Copyright (c) 2014 Kareem Khattab. All rights reserved.
//

import UIKit
import MessageUI

class SweetTableViewCell: UITableViewCell, MFMailComposeViewControllerDelegate {

    @IBOutlet var usernameLabel: UILabel! = UILabel()
    @IBOutlet var timestampLabel: UILabel! = UILabel()
    @IBOutlet var titleTextView: UITextView! = UITextView();
    @IBOutlet var sweetTextView: UITextView! = UITextView()
    @IBOutlet var profileImageView: UIImageView! = UIImageView()
    @IBOutlet var location: UIButton!;
    @IBOutlet weak var emilLabel: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func loctionBtn(sender: UIButton) {
        println("Location");
        
    }
    
    
    @IBAction func emailBtn(sender: AnyObject) {
        println("email")
        
        let mailComposeViewController = configureMailComposeViewController();
        
        if MFMailComposeViewController.canSendMail(){
            //self.presentViewController(mailComposeViewController, animated: true, completion: nil);
        }else{
            self.showSendMailErrorAlert();
        }
        
        
    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController{
        
        
        let mailComposerVC = MFMailComposeViewController();
        mailComposerVC.mailComposeDelegate = self;
        //mailComposerVC.setToRecipients(["\()"]);
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