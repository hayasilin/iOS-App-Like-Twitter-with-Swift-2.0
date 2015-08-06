
//
//  TimeLineTableViewController.swift
//  SwifferApp
//
//  Created by Kareem Khattab on 11/8/14.
//  Copyright (c) 2014 Kareem Khattab. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var timelineData = [PFObject]();
    @IBOutlet weak var open: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            open.target = self.revealViewController()
            open.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.loadData();
        
        if PFUser.currentUser() == nil {
            self.showLoginSignUp();
        }
        
        self.refreshControl = UIRefreshControl();
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh");
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func refresh(sender:AnyObject){
        println("refresh")
        self.loadData();
        self.refreshControl?.endRefreshing();
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        //self.loadData();
        
        var footerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        self.tableView.tableFooterView = footerView;
        var logOutBtn: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton;
        logOutBtn.frame = CGRectMake(20, 10, 100, 20);
        logOutBtn.setTitle("Log Out", forState: UIControlState.Normal);
        logOutBtn.addTarget(self, action: "logOut:", forControlEvents: UIControlEvents.TouchUpInside);
        footerView.addSubview(logOutBtn);
        
    }
    
    func showLoginSignUp(){
        var loginAlert: UIAlertController = UIAlertController(title: "Signup / Login", message: "please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
        loginAlert.addTextFieldWithConfigurationHandler({
            textfield in
            textfield.placeholder = "Your your name";
        })
        
        loginAlert.addTextFieldWithConfigurationHandler({
            textfield in
            textfield.placeholder = "Your Password";
            textfield.secureTextEntry = true;
        })
        
        //Login section
        loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            let textfields: NSArray = loginAlert.textFields as AnyObject! as! NSArray;
            let usernameTextField: UITextField = textfields.objectAtIndex(0) as! UITextField;
            let passwordTextField: UITextField = textfields.objectAtIndex(1) as! UITextField;
            PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text){
                (user:PFUser!, error:NSError!)->Void in
                
                if user != nil{
                    println("Login Successfully");
                    
                }else{
                    println("Login Failed");
                    var loginFail: UIAlertController = UIAlertController(title: "Login failed", message: "Please reenter Username and Password", preferredStyle: UIAlertControllerStyle.Alert);
                    var loginFailAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                        alertAction in
                        self.showLoginSignUp();
                    })
                    loginFail.addAction(loginFailAction);
                    self.presentViewController(loginFail, animated: true, completion: nil);
                }
                
            }
        }));
        
        //Sign up section
        loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
            alertAction in
            let textfields: NSArray = loginAlert.textFields as AnyObject! as! NSArray;
            let usernameTextField: UITextField = textfields.objectAtIndex(0) as! UITextField;
            let passwordTextField: UITextField = textfields.objectAtIndex(1) as! UITextField;
            
            var sweeter: PFUser = PFUser();
            sweeter.username = usernameTextField.text;
            sweeter.password = passwordTextField.text;
            
            sweeter.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    println("Sign up succcessfully")
                    
                    //UIImagePickerController section
                    var imagePicker: UIImagePickerController = UIImagePickerController();
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    imagePicker.delegate = self;
                    
                    self.presentViewController(imagePicker, animated: true, completion: nil);
                    
                } else {
                    println("Sign up failed!")
                    var signUpFail: UIAlertController = UIAlertController(title: "Sign up failed", message: "帳號已經有人使用了！！", preferredStyle: UIAlertControllerStyle.Alert);
                    var signUpFailAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                        alertAction in
                        self.showLoginSignUp();
                    })
                    signUpFail.addAction(signUpFailAction);
                    self.presentViewController(signUpFail, animated: true, completion: nil);
                    
                }
            }
        }))
        self.presentViewController(loginAlert, animated: true, completion: nil);
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
    }
    
    func scaleImageWith(image: UIImage, and newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height));
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    @IBAction func loadData(){
        timelineData.removeAll(keepCapacity: false);
        var findTimelineData: PFQuery = PFQuery(className: "Sweets");
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error: NSError!) -> Void in
            
            if error == nil{
                self.timelineData = objects.reverse() as! [PFObject]
                self.tableView.reloadData();
            }
        }
    }
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        PFUser.logOut();
        self.showLoginSignUp();
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: SweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SweetTableViewCell;
        
        let sweet: PFObject = self.timelineData[indexPath.row] as PFObject;
        cell.sweetTextView.text = sweet.objectForKey("content") as! String;
        cell.titleTextView.text = sweet.objectForKey("title") as! String;
        cell.location.setTitle((sweet.objectForKey("location")) as? String, forState: UIControlState.Normal);
        
        
        //Add appearing animation
        /*
        cell.sweetTextView.alpha = 0;
        cell.timestampLabel.alpha = 0;
        cell.usernameLabel.alpha = 0;
        cell.titleTextView.alpha = 0;
        */

        
        //Show Date
        var dataFormer:NSDateFormatter = NSDateFormatter();
        dataFormer.dateFormat = "yyyy-MM-dd HH:mm";
        cell.timestampLabel.text = dataFormer.stringFromDate(sweet.createdAt);
        
        //Show username
        var findSweeter: PFQuery = PFUser.query();
        findSweeter.whereKey("objectId", equalTo: sweet.objectForKey("sweeter").objectId);
        findSweeter.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                if let actualObjects = objects{
                    let possibleUser = (actualObjects as NSArray).lastObject as? PFUser;
                    if let user = possibleUser{
                        cell.usernameLabel.text = user.username;
                        
                        //ProfileImage
                        
                        cell.profileImageView.alpha = 0;
                        let profileImage: PFFile = user.objectForKey("profileImage") as! PFFile;
                        profileImage.getDataInBackgroundWithBlock{
                            (imageData: NSData!, error: NSError!) -> Void in
                            
                            if (error == nil){
                                let image: UIImage = UIImage(data: imageData)!;
                                cell.profileImageView.image = image;
                            }
                        }
                        
                        UIView.animateWithDuration(0.5, animations: {
                            cell.sweetTextView.alpha = 1;
                            cell.timestampLabel.alpha = 1;
                            cell.usernameLabel.alpha = 1;
                            cell.profileImageView.alpha = 1;
                            cell.titleTextView.alpha = 1;
                        })
                        
                    }
                }
            }
        }
        return cell
    }
}