
//  ViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-04-29.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var banner: UILabel!
    
    var healthManager:HealthManager?
    let pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthManager = HealthManager()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "performLifetimeSegue", name: "lifetimeNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unwrapNotification:", name: "dailyNotification", object: nil)
        
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            print("first time")
            
            NSUserDefaults.standardUserDefaults().setInteger(8, forKey: "targetDistance")
            NSUserDefaults.standardUserDefaults().setInteger(10000, forKey: "targetSteps")
            
            let array = [1]
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: "doneDaily")
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstRun")
        }
        
        authorizeHealthKit()
        setFirstDate()
        //        updateBanner()
    }
    func unwrapNotification(notification: NSNotification) {
        if let dailyDistanceDictionary = notification.userInfo as? Dictionary<Int, NSNumber> {
            if let dailyDistance = dailyDistanceDictionary[1] {
                updateBanner(dailyDistance)
            }
        }
        else {
            print("error in userinfo type")
        }
    }
    func setFirstDate() {
        
        self.healthManager?.readFirstDate({ (date, error) -> Void in
            if (error != nil) {
                print("Error reading first date from HealthKit")
                return
            }
            firstDate = date
        });
    }
    
    func performLifetimeSegue() {
        
        self.performSegueWithIdentifier("lifetimeSegue", sender: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authorizeHealthKit()
    {
        healthManager!.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorized")
                
            }
            else {
                print("HealthKit denied")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }
    
    func updateBanner(distance: NSNumber) {
        self.banner.text = ModelInterface.sharedInstance.hardestHole(distance.doubleValue/1000)
        
        
        let a = distance.integerValue/1000
        let achievementString = ModelInterface.sharedInstance.reachedAchievement(a)
        
        if achievementString != "" && distance.doubleValue/1000 - Double(a) <= 0.5 {
            self.banner.text = achievementString
        }
    }
    
    
}

