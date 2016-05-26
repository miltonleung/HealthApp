//
//  Data.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-25.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

class Data {
    var viewcontroller = ViewController()
    
    var lifetimeDistanceAchievements = []
    var doneLifetimeDistanceAchievements = [Int]()
    var currentLifetimeDistanceAchievements = [Int]()
    
    var lifetimeStepsAchievements = []
    var doneLifetimeStepsAchievements = [Int]()
    var currentLifetimeStepsAchievements = [Int]()
    
    var millionTargetCounter = 1000000
    var thousandTargetCounter = 1000
    
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
    
    func updateLifetimeDistanceAchievement() {
        var lifetimeDistanceDictionary = [Int: Int]()
        
        while (totalDistance > thousandTargetCounter && !doneLifetimeDistanceAchievements.contains(thousandTargetCounter)) {
            doneLifetimeDistanceAchievements.append(thousandTargetCounter)
            currentLifetimeDistanceAchievements.append(thousandTargetCounter)
            let size = lifetimeDistanceDictionary.count
            lifetimeDistanceDictionary[size + 1] = totalDistance
            thousandTargetCounter += 1000
        }
        NSNotificationCenter.defaultCenter().postNotificationName("lifetimeNotification", object: nil, userInfo: lifetimeDistanceDictionary)
    }
    
    func updateLifetimeStepsAchievement() {
        var lifetimeStepsDictionary = [Int: Int]()
        
        while (totalSteps > millionTargetCounter && !doneLifetimeStepsAchievements.contains(millionTargetCounter)) {
            doneLifetimeStepsAchievements.append(millionTargetCounter)
            currentLifetimeStepsAchievements.append(millionTargetCounter)
            let size = lifetimeStepsDictionary.count
            lifetimeStepsDictionary[size + 1] = totalSteps
            millionTargetCounter += 1000000
        }
        NSNotificationCenter.defaultCenter().postNotificationName("lifetimeNotification", object: nil, userInfo: lifetimeStepsDictionary)
    }
    
}