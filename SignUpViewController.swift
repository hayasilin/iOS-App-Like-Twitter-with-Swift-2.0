//
//  SignUpViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 7/26/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self;
        passwordTextField.delegate = self;
        signUpBtnOutlet.layer.cornerRadius = 5;
    }
    
    @IBAction func signUpBtn(sender: UIButton) {
        signUp();
    }
    
    func signUp(){
        var sweeter: PFUser = PFUser();
        sweeter.username = usernameTextField.text;
        sweeter.password = passwordTextField.text;
        sweeter.email = emailTextField.text;
        
        sweeter.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                println("Sign up succcessfully")
                
                //UIImagePickerController section
                var imagePicker: UIImagePickerController = UIImagePickerController();
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.delegate = self;
                
                self.presentViewController(imagePicker, animated: true, completion: nil);
                
                var signUpSuccess: UIAlertController = UIAlertController(title: "Sign up success", message: "Sign up success", preferredStyle: UIAlertControllerStyle.Alert);
                
                
            } else {
                println("Sign up failed!")
                var signUpFail: UIAlertController = UIAlertController(title: "Sign up failed", message: "帳號已經有人使用了！！", preferredStyle: UIAlertControllerStyle.Alert);
                var signUpFailAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
                signUpFail.addAction(signUpFailAction);
                self.presentViewController(signUpFail, animated: true, completion: nil);
            }
        }
    }
    
    //Sing up Image method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        
        //Scale down image
        let scaledImage = self.scaleImageWith(pickedImage, and: CGSizeMake(80, 80));
        
        let imageData = UIImagePNGRepresentation(scaledImage);
        let imageFile: PFFile = PFFile(data: imageData);
        PFUser.currentUser().setObject(imageFile, forKey: "profileImage")
        PFUser.currentUser().save();
        
        picker.dismissViewControllerAnimated(true, completion: nil);
        
        dispatch_async(dispatch_get_main_queue()){
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var SWViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("swVC") as! UIViewController;
            
            self.presentViewController(SWViewController, animated: true, completion: nil);
        
        /*
        dispatch_async(dispatch_get_main_queue()){
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var TimeLineViewController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("main") as! UINavigationController;
            self.presentViewController(TimeLineViewController, animated: true, completion: nil);
*/
        }
    }
    
    func scaleImageWith(image: UIImage, and newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height));
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true);
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
