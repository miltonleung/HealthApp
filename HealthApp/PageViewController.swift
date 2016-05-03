//
//  PageViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-01.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let stepPage: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("stepPage")
        let distancePage: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("distancePage")
        let graphPage: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("graphPage")
        
        pages.append(stepPage)
        pages.append(distancePage)
        pages.append(graphPage)
        
        setViewControllers([stepPage], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex - 1 < 0 {
            return nil
        }
        let previousIndex = currentIndex - 1
        return pages[previousIndex]
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex == pages.count - 1 {
            return nil
        }
        let nextIndex = currentIndex + 1
        return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}