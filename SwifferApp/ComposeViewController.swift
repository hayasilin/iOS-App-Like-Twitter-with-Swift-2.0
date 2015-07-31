


//
//  ComposeViewController.swift
//  SwifferApp
//
//  Created by Kareem Khattab on 11/8/14.
//  Copyright (c) 2014 Kareem Khattab. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet var sweetTextView: UITextView! = UITextView()
    @IBOutlet var charRemainingLabel: UILabel! = UILabel()
    @IBOutlet weak var locationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sweetTextView.layer.cornerRadius = 5;
        sweetTextView.delegate = self
        
        titleTextView.layer.cornerRadius = 5;
        
        //Open the keyboard when user hits the TextView
        titleTextView.becomeFirstResponder()
        
        titleTextView.delegate = self;
        sweetTextView.delegate = self;
        locationTextView.delegate = self;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSweet(sender: AnyObject) {
        
        var sweet: PFObject = PFObject(className: "Sweets");
        
        if (!titleTextView.text.isEmpty && !sweetTextView.text.isEmpty && !locationTextView.text.isEmpty){
            sweet["title"] = titleTextView.text;
            sweet["content"] = sweetTextView.text;
            sweet["sweeter"] = PFUser.currentUser();
            sweet["location"] = locationTextView.text;
            sweet.saveInBackgroundWithTarget(nil, selector: nil);
            
            self.navigationController?.popToRootViewControllerAnimated(true);
        }else{
            println("不可有空白");
            var composeError: UIAlertController = UIAlertController(title: "輸入錯誤", message: "不可以有空白", preferredStyle: UIAlertControllerStyle.Alert);
            var composeErrorAction: UIAlertAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil);
            composeError.addAction(composeErrorAction);
            self.presentViewController(composeError, animated: true, completion: nil);
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var newLength: Int = (textView.text as NSString).length + (text as NSString).length - range.length;
        var remainingChar: Int = 140 - newLength;
        charRemainingLabel.text = "\(remainingChar)";
        
        return (newLength >= 140) ? false : true;
    }

}
