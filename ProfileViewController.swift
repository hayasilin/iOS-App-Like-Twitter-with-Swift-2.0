//
//  ProfileViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/22/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var slideOutMenu: UIBarButtonItem!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil{
            slideOutMenu.target = revealViewController()
            slideOutMenu.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        usernameTextField.text = PFUser.currentUser()?.username
        emailTextField.text = PFUser.currentUser()?.email
        
        let user: PFUser = PFUser.currentUser()!
        let profileImage: PFFile = user.objectForKey("profileImage") as! PFFile
        profileImage.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if error == nil{
                let image: UIImage = UIImage(data: imageData!)!
                self.profileImageView.image = image
            }
        }
    }
    
    @IBAction func changeProfileImageAction(sender: UIButton) {
        let alertController = UIAlertController(title: "確認", message: "請問是否變更顯示圖片？", preferredStyle: UIAlertControllerStyle.Alert)
        let confirmAlertAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.Default) { (alertAction: UIAlertAction) -> Void in
            //UIImagePickerController section
            let imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        let cancelAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(confirmAlertAction)
        alertController.addAction(cancelAlertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //Scale down image
        let scaledImage = self.scaleImageWith(pickedImage, and: CGSizeMake(100, 100))
        let imageData = UIImagePNGRepresentation(scaledImage)
        let imageFile: PFFile = PFFile(data: imageData!)
        PFUser.currentUser()?.setObject(imageFile, forKey: "profileImage")
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if error == nil{
                print("Change profileimage success")
                let alertView = UIAlertView(title: "更新成功", message: "變更顯示圖片成功", delegate: self, cancelButtonTitle: "確定")
                alertView.show()
                
            }else{
                print("Change profileimage fail")
            }
        })
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scaleImageWith(image: UIImage, and newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}
