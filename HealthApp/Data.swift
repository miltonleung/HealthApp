//
//  Data.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-25.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

let lifetimeDistanceAchievements = []
var doneLifetimeDistanceAchievements = [Int]()
var currentLifetimeDistanceAchievements = [Int]()

let lifetimeStepsAchievements = []
var doneLifetimeStepsAchievements = [Int]()
var currentLifetimeStepsAchievements = [Int]()

var millionTargetCounter = 1000000
var thousandTargetCounter = 1000

var firstDate:String = "2010-01-01"

let wordsOfEnc = ["Bravo", "Way to Go", "You are a Legend", "You Deserve A Pat On The Back", "Looking Good", "Impressive", "Unbelievable", "Are you kidding me?!?", "Beautiful", "Well Done", "You Take The Biscuit Every Time", "Outstanding", "You really outdid yourself", "Outstanding", "Coolio", "DAYUM!!"]

class Data {
    var viewcontroller = ViewController()
    
    
    
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
        
        while (totalDistance > thousandTargetCounter && !doneLifetimeDistanceAchievements.contains(thousandTargetCounter)) {
            doneLifetimeDistanceAchievements.append(thousandTargetCounter)
            currentLifetimeDistanceAchievements.append(thousandTargetCounter)
            let size = lifetimeDistanceDictionary.count
            lifetimeDistanceDictionary[size + 1] = thousandTargetCounter
            thousandTargetCounter += 1000
        }
        checkedBoth += 1
        //        NSNotificationCenter.defaultCenter().postNotificationName("lifetimeNotification", object: nil, userInfo: lifetimeDistanceDictionary)
    }
    
    func updateLifetimeStepsAchievement() {
        var lifetimeStepsDictionary = [Int: Int]()
        
        while (totalSteps > millionTargetCounter && !doneLifetimeStepsAchievements.contains(millionTargetCounter)) {
            doneLifetimeStepsAchievements.append(millionTargetCounter)
            currentLifetimeStepsAchievements.append(millionTargetCounter)
            let size = lifetimeStepsDictionary.count
            lifetimeStepsDictionary[size + 1] = millionTargetCounter
            millionTargetCounter += 1000000
        }
        checkedBoth += 1
        //        NSNotificationCenter.defaultCenter().postNotificationName("lifetimeNotification", object: nil, userInfo: lifetimeStepsDictionary)
    }
    
}