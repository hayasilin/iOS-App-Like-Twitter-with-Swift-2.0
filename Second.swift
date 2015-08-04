//
//  Second.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/1/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import Foundation

class Second: UIViewController{
    
    override func viewDidLoad() {
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
    }
}