//
//  ViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/1/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var open: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad();
        
        open.target = self.revealViewController();
        open.action = Selector("revealToggle:");
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
    }
    
}
