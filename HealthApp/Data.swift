//
//  Data.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-25.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

let lifetimeDistanceAchievements = [4: "Just Keep Swimming", 24: "Can You Hear Me?", 27: "27 by 27 by 27", 920: "New York, New York", 3476: "Fly Me to the Moon", 6371: "We Are The World"]
let lifetimeDistanceAchievementsDescription =
    [4: "a shark can smell blood from 4km away.",
     24: "a dolphin can detect underwater sounds from 24 km!",
     27: "everyone in the world (over 7 billion people) can fit in a 27 km cube!",
     920: "New York has 920 km of shoreline!",
     3476: "the moon’s diameter is 3,476?",
     6371: "the Earth’s radius is 6,371 km?"]
let lifetimeDistanceAchievementsImage =
    [4: "Shark",
     24: "Dolphin",
     27: "Cube",
     920: "NY",
     3476: "Moon",
     6371: "Earth"]
var currentLifetimeDistanceAchievements = [Int]()

let lifetimeStepsAchievements = []
var currentLifetimeStepsAchievements = [Int]()

var doneDailyDistanceAchievements = [Int]()
let dailyAchievements = [1: "Baby Steps", 3: "You have reached 3 km!", 5: "You have reached 5 km!"]

let wordsOfEnc = ["Bravo", "Way to Go", "You are a Legend", "You Deserve A Pat On The Back", "Looking Good", "Impressive", "Unbelievable", "Are you kidding me?!?", "Beautiful", "Well Done", "You Take The Biscuit Every Time", "You really outdid yourself", "Outstanding", "Coolio", "DAYUM!!", "You’re making it look easy!"]

class Data {
    var viewcontroller = ViewController()
    
    var dailyDistance: NSNumber = 0 {
        didSet {
            var dailyDistanceDictionary = [1 : dailyDistance]
            NSNotificationCenter.defaultCenter().postNotificationName("dailyNotification", object: nil, userInfo: dailyDistanceDictionary)
        }
    }
    var weeklyDistances = [Double]() {
        didSet {
            var weeklyDistancesDictionary = [1: weeklyDistances]
            NSNotificationCenter.defaultCenter().postNotificationName("checkInStatus", object: nil, userInfo: weeklyDistancesDictionary)
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
            
            for (distance, message) in lifetimeDistanceAchievements {
                if totalDistance >= distance && !doneLifetimeDistanceAchievements.contains(distance) {
                    doneLifetimeDistanceAchievements.append(distance)
                    currentLifetimeDistanceAchievements.append(distance)
                }
            }
            
            
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