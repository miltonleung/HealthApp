//
//  Constants.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-01.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

var achievements = [1: "Baby Steps", 3: "You have reached 3 km!", 5: "You have reached 5 km!"]

var doneAchievements = [Int]()

var lifetimeDistance = [1000000]

var doneLifeTimeDistance = [Int]()

var targetDistance = 8
var targetSteps = 10000

class Data {
    var viewcontroller = ViewController()
    var totalSteps: Int = 0 {
        didSet {
            print("New total steps value set")
        }
    }
    var totalDistance: Int = 0 {
        didSet {
            print("New total distance value set")
            NSNotificationCenter.defaultCenter().postNotificationName("lifetimeNotification", object: nil)
        }
    }
}
