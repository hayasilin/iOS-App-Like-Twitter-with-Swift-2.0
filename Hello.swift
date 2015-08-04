//
//  Hello.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/1/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import Foundation

class Hello: UIViewController{
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
    }
}