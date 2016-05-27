//
//  Data.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-25.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

let lifetimeDistanceAchievements = []
var currentLifetimeDistanceAchievements = [Int]()

let lifetimeStepsAchievements = []
var currentLifetimeStepsAchievements = [Int]()


var firstDate:String = "2010-01-01"

var doneDailyDistanceAchievements = [Int]()
let dailyAchievements = [1: "Baby Steps", 3: "You have reached 3 km!", 5: "You have reached 5 km!"]

let wordsOfEnc = ["Bravo", "Way to Go", "You are a Legend", "You Deserve A Pat On The Back", "Looking Good", "Impressive", "Unbelievable", "Are you kidding me?!?", "Beautiful", "Well Done", "You Take The Biscuit Every Time", "Outstanding", "You really outdid yourself", "Outstanding", "Coolio", "DAYUM!!"]

class Data {
    var viewcontroller = ViewController()
    
    var dailyDistance: NSNumber = 0 {
        didSet {
            var dailyDistanceDictionary = [1 : dailyDistance]
            NSNotificationCenter.defaultCenter().postNotificationName("dailyNotification", object: nil, userInfo: dailyDistanceDictionary)
        }
    }
    var totalSteps: Int = 0 {
        willSet {
            //            currentLifetimeStepsAchievements = [Int]()
        }
        didSet {
            print("New total steps value set")
            if totalSteps != 0 {
                updateLifetimeStepsAchievement()
            }
        }
    }
    var totalDistance: Int = 0 {
        willSet {
            //            currentLifetimeDistanceAchievements = [Int]()
        }
        didSet {
            print("New total distance value set")
            if totalDistance != 0 {
                updateLifetimeDistanceAchievement()
            }
        }
    }
    
    var checkedBoth: Int = 0 {
        didSet {
            if checkedBoth == 2 {
                if (!currentLifetimeDistanceAchievements.isEmpty || !currentLifetimeStepsAchievements.isEmpty) {
                    NSNotificationCenter.defaultCenter().postNotificationName("lifetimeNotification", object: nil)
                }
                checkedBoth = 0
            }
        }
    }
    func updateLifetimeDistanceAchievement() {
        var lifetimeDistanceDictionary = [Int: Int]()
        var thousandTargetCounter = NSUserDefaults.standardUserDefaults().integerForKey("thousandTargetCounter")
        
        if var doneLifetimeDistanceAchievements = NSUserDefaults.standardUserDefaults().arrayForKey("doneLifetimeDistance") as? [Int] {
            
            while (totalDistance >= thousandTargetCounter && !doneLifetimeDistanceAchievements.contains(thousandTargetCounter)) {
                doneLifetimeDistanceAchievements.append(thousandTargetCounter)
                currentLifetimeDistanceAchievements.append(thousandTargetCounter)
                let size = lifetimeDistanceDictionary.count
                lifetimeDistanceDictionary[size + 1] = thousandTargetCounter
                thousandTargetCounter += 1000
            }
            NSUserDefaults.standardUserDefaults().setInteger(thousandTargetCounter, forKey: "thousandTargetCounter")
            NSUserDefaults.standardUserDefaults().setObject(doneLifetimeDistanceAchievements, forKey: "doneLifetimeDistance")
            checkedBoth += 1

        }
    }
    
    func updateLifetimeStepsAchievement() {
        var lifetimeStepsDictionary = [Int: Int]()
        var millionTargetCounter = NSUserDefaults.standardUserDefaults().integerForKey("millionTargetCounter")
        
        if var doneLifetimeStepsAchievements = NSUserDefaults.standardUserDefaults().arrayForKey("doneLifetimeSteps") as? [Int] {
            
            while (totalSteps >= millionTargetCounter && !doneLifetimeStepsAchievements.contains(millionTargetCounter)) {
                doneLifetimeStepsAchievements.append(millionTargetCounter)
                currentLifetimeStepsAchievements.append(millionTargetCounter)
                let size = lifetimeStepsDictionary.count
                lifetimeStepsDictionary[size + 1] = millionTargetCounter
                millionTargetCounter += 1000000
            }
            NSUserDefaults.standardUserDefaults().setInteger(millionTargetCounter, forKey: "millionTargetCounter")
            NSUserDefaults.standardUserDefaults().setObject(doneLifetimeStepsAchievements, forKey: "doneLifetimeSteps")
            checkedBoth += 1

        }
    }
    
}