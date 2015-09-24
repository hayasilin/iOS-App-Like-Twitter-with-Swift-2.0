//
//  ComposeViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/20/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class ComposeViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.layer.cornerRadius = 5
        titleTextView.layer.cornerRadius = 5
        locationTextView.layer.cornerRadius = 5
        
        contentTextView.delegate = self
        
    }
    
    @IBAction func sendCrack(sender: UIBarButtonItem) {
        
        let crack: PFObject = PFObject(className: "crack")
        if (!titleTextView.text.isEmpty && !contentTextView.text.isEmpty && !locationTextView.text.isEmpty){
            
            crack["title"] = titleTextView.text
            crack["content"] = contentTextView.text
            crack["cracker"] = PFUser.currentUser()
            crack["email"] = PFUser.currentUser()?.email
            crack["location"] = locationTextView.text
            
            crack.saveInBackgroundWithTarget(nil, selector: nil)
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else{
            let composeAlertController: UIAlertController = UIAlertController(title: "錯誤", message: "不可以有空白未填", preferredStyle: UIAlertControllerStyle.Alert)
            let composeAlertAction: UIAlertAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil)
            composeAlertController.addAction(composeAlertAction)
            self.presentViewController(composeAlertController, animated: true, completion: nil)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let newLength: Int = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingChar: Int = 140 - newLength
        countLabel.text = "\(remainingChar)"
        
        return (newLength >= 140) ? false : true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
