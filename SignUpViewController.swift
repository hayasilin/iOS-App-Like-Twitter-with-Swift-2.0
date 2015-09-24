//
//  SignUpViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/20/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBAction func signUp(sender: UIButton) {
        signUp()
    }
    
    func signUp(){
        let user = PFUser();
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        user.signUpInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil{
                print("Sign up successfully")
                
                //UIImagePickerController section
                let imagePicker: UIImagePickerController = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
                let successAlertController: UIAlertController = UIAlertController(title: "註冊成功", message: "您已經成功註冊，請按下確定選擇大頭圖像", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction: UIAlertAction = UIAlertAction(title: "開始選擇大頭圖像", style: UIAlertActionStyle.Default, handler: nil)
                successAlertController.addAction(alertAction)
                self.presentViewController(successAlertController, animated: true, completion: nil)
            }else{
                print("Sign up failed")
                print(error?.localizedDescription)
                
                let failAlertController: UIAlertController = UIAlertController(title: "註冊失敗", message: "該帳號已經有人使用了，請重新輸入", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction: UIAlertAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil)
                failAlertController.addAction(alertAction)
                self.presentViewController(failAlertController, animated: true, completion: nil)
            }
        })
    }
    
    //Sign Up image function
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        
        //SCale down image
        let scaledImage = self.scaleImageWith(pickedImage, and: CGSizeMake(80, 80))
        
        let imageData = UIImagePNGRepresentation(scaledImage)
        let imageFile: PFFile = PFFile(data: imageData!)
        PFUser.currentUser()?.setObject(imageFile, forKey: "profileImage")
        PFUser.currentUser()?.save()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        dispatch_async(dispatch_get_main_queue()){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let timelineViewController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("timelineVC") as! UINavigationController
            
            self.presentViewController(timelineViewController, animated: true, completion: nil)
        }
    }

    func scaleImageWith(image: UIImage, and newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.layer.cornerRadius = 5
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
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
        // Dispose of any resources that can be recreated.
    }

}
