//
//  LogInViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/20/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LogInViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBAction func logIn(sender: UIButton) {
        logIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logInBtn.layer.cornerRadius = 5
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        //Facebook Login
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Not log in")
        }else{
            print("Log in")
        }
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        //loginButton.center = self.view.center
        loginButton.center = CGPointMake(self.view.center.x, 400.0)
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
    }
    
    //MARK: - FBSDKLogin
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil{
            print("Login complete")
            dispatch_async(dispatch_get_main_queue()){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let SWViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("swVC") 
                self.presentViewController(SWViewController, animated: true, completion: nil)
            }

        }else{
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User log out")
    }
    
    func logIn(){
        
        indicatorView.hidden = false
        indicatorView.startAnimating()
        
        let user = PFUser();
        user.username = usernameTextField.text;
        user.password = passwordTextField.text;
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!, block: {
            (user: PFUser?, error: NSError?) -> Void in
            
            if error == nil{
                print("Login Successfully");
                
                dispatch_async(dispatch_get_main_queue()){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let SWViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("swVC") 
                    self.presentViewController(SWViewController, animated: true, completion: nil)
                }
            }else{
                print("Login Failed");
                print(error?.localizedDescription)
                
                self.indicatorView.stopAnimating()
                self.indicatorView.hidden = true
                
                let loginFail: UIAlertController = UIAlertController(title: "登入失敗", message: "請重新輸入帳號及密碼", preferredStyle: UIAlertControllerStyle.Alert);
                let loginFailAction: UIAlertAction = UIAlertAction(title: "我知道了", style: UIAlertActionStyle.Default, handler: nil);
                loginFail.addAction(loginFailAction);
                self.presentViewController(loginFail, animated: true, completion: nil);
            }
        })
    }
    
    @IBAction func anonymousLogIn(sender: UIButton) {
        PFAnonymousUtils.logInWithBlock { (user: PFUser?, error: NSError?) -> Void in
            if error != nil || user == nil {
                print("Anonymous login failed.")
            } else {
                print("Anonymous user logged in.")
                dispatch_async(dispatch_get_main_queue()){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let anonymousVC: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("anonymousVC") as! UINavigationController
                    self.presentViewController(anonymousVC, animated: true, completion: nil)
                }
            }
        }
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
