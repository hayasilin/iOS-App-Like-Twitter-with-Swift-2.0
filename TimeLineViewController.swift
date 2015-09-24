//
//  TimeLineViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/19/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class TimeLineViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var timelineData = [PFObject]()
    @IBOutlet weak var slideOutMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() == nil{
            let logInViewController: LogInViewController = storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LogInViewController
            self.presentViewController(logInViewController, animated: true, completion: nil)
        }
        
        self.refreshControl = UIRefreshControl()
        //self.refreshControl?.attributedTitle = NSAttributedString(string: "往下拉來更新")
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        //Slide out menu
        if revealViewController() != nil{
            slideOutMenu.target = self.revealViewController()
            slideOutMenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func refresh(){
        print("Refresh")
        self.loadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func loadData(){
        let findTimelineData: PFQuery = PFQuery(className: "crack")
        findTimelineData.orderByDescending("createdAt")
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil{
                self.timelineData.removeAll(keepCapacity: false)
                self.timelineData = objects as! [PFObject]
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CrackTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CrackTableViewCell
        
        let crack: PFObject = self.timelineData[indexPath.row] as PFObject
        cell.titleTextView.text = crack.objectForKey("title") as! String
        cell.contentTextView.text = crack.objectForKey("content") as! String
        cell.locationBtn.setTitle((crack.objectForKey("location")) as? String, forState: UIControlState.Normal)
        cell.emailBtn.setTitle((crack.objectForKey("email")) as? String, forState: UIControlState.Normal)
        
        
        //Show date
        let dateFormer: NSDateFormatter = NSDateFormatter()
        dateFormer.dateFormat = "yyyy-MM-dd HH:mm"
        cell.dateLabel.text = dateFormer.stringFromDate(crack.createdAt!)
        
        //Show username
        let findCracker: PFQuery = PFUser.query()!
        findCracker.whereKey("objectId", equalTo: PFUser.currentUser()!.username!)
        findCracker.whereKey("objectId", equalTo: crack.objectForKey("cracker")!.objectId!!)
        
        findCracker.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                if let actualObjects = objects{
                    let possibleUser = (actualObjects as NSArray).lastObject as? PFUser;
                    if let user = possibleUser{
                        cell.nameLabel.text = user.username;
                        
                        //ProfileImage
                        
                        cell.profileImageView.alpha = 1;
                        if user.objectForKey("profileImage") == nil{
                            //println("There is no profileImage.")
                            let noImage: UIImage = UIImage(named: "user")!
                            cell.profileImageView.image = noImage
                        }else{
                            let profileImage: PFFile = user.objectForKey("profileImage") as! PFFile;
                            profileImage.getDataInBackgroundWithBlock{
                                (imageData: NSData?, error: NSError?) -> Void in
                                
                                if (error == nil){
                                    let image: UIImage = UIImage(data: imageData!)!;
                                    cell.profileImageView.image = image;
                                }
                            }
                        }
                        
                        UIView.animateWithDuration(0.5, animations: {
                            cell.profileImageView.alpha = 1
                            cell.nameLabel.alpha = 1
                            cell.dateLabel.alpha = 1
                            cell.titleTextView.alpha = 1
                            cell.contentTextView.alpha = 1
                            
                        })
                    }
                }
            }
        }
        return cell
    }
}
