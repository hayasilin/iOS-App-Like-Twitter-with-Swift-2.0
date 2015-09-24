//
//  IntroductionViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/29/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var introLabel: UILabel!
    
    var pageIndex: Int!;
    var contentText: String!;
    var imageFile: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: self.imageFile);
        self.introLabel.text = self.contentText;
        introLabel.textColor = UIColor.blackColor();
        
    }
    
    
}
