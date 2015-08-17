
//
//  TimeLineTableViewController.swift
//  SwifferApp
//
//  Created by Kareem Khattab on 11/8/14.
//  Copyright (c) 2014 Kareem Khattab. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            var logInSignUpVC: LogInSignUpViewController = storyboard!.instantiateViewControllerWithIdentifier("logInSignUp") as! LogInSignUpViewController;
            
            self.presentViewController(logInSignUpVC, animated: true, completion: nil);
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
        self.loadData();
    }
    
    func loadData(){
        var findTimelineData: PFQuery = PFQuery(className: "Sweets");
        findTimelineData.orderByDescending("createdAt")
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error: NSError!) -> Void in
            
            if error == nil{
                self.timelineData.removeAll(keepCapacity: false);
                self.timelineData = objects as! [PFObject]
                self.tableView.reloadData();
            }
        }

    }
    
    /*
    @IBAction func logOut(sender: UIBarButtonItem) {
        PFUser.logOut();
        self.showLoginSignUp();
    }
*/
    
    
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
        cell.emilLabel.setTitle((sweet.objectForKey("email")) as? String, forState: UIControlState.Normal);
        
        let sendEmail = storyboard?.instantiateViewControllerWithIdentifier("sendmail") as! SendEmailViewController;
        
        sendEmail.mailAddress = (sweet.objectForKey("email")) as? String;
        
        
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