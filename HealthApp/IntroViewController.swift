//
//  IntroViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-27.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import HealthKit

class IntroViewController: UIViewController {
    
    var healthManager:HealthManager?
    var freshOrExisting = 0 // 0 is fresh, 1 is existing
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var authorizeView: UIView!
    @IBAction func existingButton(sender: AnyObject) {
        freshOrExisting = 1
        welcomeView.hidden = true
        authorizeView.hidden = false
    }
    
    @IBAction func freshButton(sender: AnyObject) {
        freshOrExisting = 0
        welcomeView.hidden = true
        authorizeView.hidden = false
    }
    @IBAction func authorizeButton(sender: AnyObject) {
        authorizeHealthKit()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeView.layer.cornerRadius = 11
        authorizeView.layer.cornerRadius = 11
        
        healthManager = HealthManager()
        authorizeView.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authorizeHealthKit() {
        healthManager!.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorized")
                if self.freshOrExisting == 1 {
                    self.setFirstDate()
                }
                else {
                    let today = ModelInterface.sharedInstance.convertDate(NSDate())
                    NSUserDefaults.standardUserDefaults().setObject(today, forKey: "firstDate")
                    
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                print("HealthKit denied")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }
    func setFirstDate() {
        
        self.healthManager?.readFirstDate({ (date, error) -> Void in
            if (error != nil) {
                print("Error reading first date from HealthKit")
                return
            }
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: "firstDate")
        });
    }
}
