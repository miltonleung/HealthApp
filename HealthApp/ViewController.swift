
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
    
    // Passed to ProgressViewController
    var scenario: Int! // 0 flying, 1 Pass, 2 Inconsistency, 3 Lower
    var average: Double!
    var targetDistance: Int!
    var count: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthManager = HealthManager()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "performLifetimeSegue", name: "lifetimeNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unwrapNotification:", name: "dailyNotification", object: nil)
        
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            reset()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkInUnwrap:", name: "checkInStatus", object: nil)
    }
    
    func reset() {
        print("Resetting")
        NSUserDefaults.standardUserDefaults().setInteger(6, forKey: "targetDistance")
        NSUserDefaults.standardUserDefaults().setInteger(8000, forKey: "targetSteps")
        
        let array = [1]
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "doneDaily")
        
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "doneLifetimeDistance")
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "doneLifetimeSteps")
        
        NSUserDefaults.standardUserDefaults().setInteger(1000000, forKey: "millionTargetCounter")
        NSUserDefaults.standardUserDefaults().setInteger(1000, forKey: "thousandTargetCounter")
        
        let today = ModelInterface.sharedInstance.convertDate(NSDate())
        let temp:[Int: String] = [1: today]
        var data = NSKeyedArchiver.archivedDataWithRootObject(temp)
        NSUserDefaults.standardUserDefaults().setObject(today, forKey: "firstDate")
        NSUserDefaults.standardUserDefaults().setObject(today, forKey: "firstLogin")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "doneLifetimeDistanceDates")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "doneLifetimeStepsDates")
        
        NSUserDefaults.standardUserDefaults().setObject(today, forKey: "checkIn")
    }
    func checkInUnwrap(notification: NSNotification) {
        let firstLogin = NSUserDefaults.standardUserDefaults().stringForKey("firstLogin")
        if let checkIn = NSUserDefaults.standardUserDefaults().stringForKey("checkIn") {
            let daysSince = ModelInterface.sharedInstance.daysDifference(checkIn, endDate: NSDate())
            if daysSince >= 5 || (checkIn == firstLogin && checkedInToday == false) {
                checkedInToday = true
                if let weeklyDictionary = notification.userInfo as? Dictionary<Int, [Double]> {
                    if let weeklyDistances = weeklyDictionary[1] {
                        var counter = 0
                        targetDistance = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
                        let target = Double(targetDistance)
                        for d in weeklyDistances {
                            if d >= target {
                                counter += 1
                            }
                        }
                        count = counter
                        var sum = 0.0
                        for d in weeklyDistances {
                            sum += d
                        }
                        average = sum/Double(weeklyDistances.count)
                        
                        if counter == 7 {
                            scenario = 0
                        }
                        else if counter >= 4 && abs(average - target) <= 1.4 {
                            scenario = 1
                        }
                        else if counter <= 4 && weeklyDistances.maxElement()! - weeklyDistances.minElement()! >= 4 && weeklyDistances.maxElement() >= target {
                            scenario = 2
                        }
                        else {
                            scenario = 3
                        }
                        self.performSegueWithIdentifier("progress", sender: nil)
                    }
                }
                let today = ModelInterface.sharedInstance.convertDate(NSDate())
                NSUserDefaults.standardUserDefaults().setObject(today, forKey: "checkIn")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "progress") {
            let progress = segue.destinationViewController as! ProgressViewController
            progress.scenario = scenario
            progress.average = average
            progress.targetDistance = targetDistance
            progress.count = count
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        print("viewdidappera")
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            self.performSegueWithIdentifier("introSegue", sender: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstRun")
        }
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
    
    func performLifetimeSegue() {
        self.performSegueWithIdentifier("lifetimeSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateBanner(distance: NSNumber) {
        self.banner.text = ModelInterface.sharedInstance.hardestHole(distance.doubleValue/1000)
        
        
        let a = distance.integerValue/1000
        let achievement = ModelInterface.sharedInstance.reachedAchievement(a)
        let achievementString = achievement.1
        let achievementNumber  = achievement.0
        
        if achievementString != "" && distance.doubleValue/1000 - Double(achievementNumber) <= 1.5 {
            self.banner.text = achievementString
        }
    }
    
    
}

