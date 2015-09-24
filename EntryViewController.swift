//
//  EntryViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/29/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var startBtn: UIButton!
    
    var pageViewController: UIPageViewController!
    var pageContent: NSArray!
    var pageImages: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBtn.layer.cornerRadius = 5
        
        self.pageContent = NSArray(objects:
            "運用Crack the term的平台，將可透過技能交換的方式，立即找到想要學習的技能，或是提供他人相關的技能",
            "我們相信『主動』，『分享』及聚集『夥伴』的學習方式，是現在網路時代取得新知識的新方法。",
            "透過『技能分享』或『技能交換』的方式，將可以最快速，及最直接的方式找到專屬於你的學習機會，達成人生規劃及未來職涯的新契機。"
        );
        self.pageImages = NSArray(objects: "page1", "page2", "page3");
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pageVC") as! UIPageViewController;
        
        self.pageViewController.dataSource = self;
        
        let startVC = self.viewControllerAtIndex(0) as IntroductionViewController;
        let viewControllers = NSArray(object: startVC);
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil);
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.height - 100);
        self.addChildViewController(self.pageViewController);
        self.view.addSubview(self.pageViewController.view);
        self.pageViewController.didMoveToParentViewController(self);
        
    }
    
    func viewControllerAtIndex(index: Int) -> IntroductionViewController{
        if ((self.pageContent.count == 0) || (index >= self.pageContent.count)){
            return IntroductionViewController();
        }
        
        let vc: IntroductionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("introVC") as! IntroductionViewController;
        vc.imageFile = self.pageImages[index] as! String;
        vc.contentText = self.pageContent[index] as! String;
        vc.pageIndex = index;
        
        return vc;
        
    }
    
    //MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! IntroductionViewController;
        var index = vc.pageIndex as Int;
        
        if (index == 0 || index == NSNotFound){
            return nil;
        }
        
        index--
        return self.viewControllerAtIndex(index);
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! IntroductionViewController;
        var index = vc.pageIndex as Int;
        if (index == NSNotFound){
            return nil;
        }
        index++
        
        if index == self.pageContent.count{
            return nil;
        }
        
        return self.viewControllerAtIndex(index);
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageContent.count;
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0;
    }

    
}
