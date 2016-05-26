//
//  AchivementModel.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-01.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

protocol AchievementProtocol {
    func reachedAchievement(distance: Int) -> String
    func hardestHole(distance: Double) -> String
    func reachedDistanceLifetimeAchievement(distance: Int) -> Bool
    
}

extension ModelInterface: AchievementProtocol {
    func reachedAchievement(distance: Int) -> String {
        var done:Int = 0
        var retMessage = ""
        
        if doneAchievements.count > 0 {
            done = doneAchievements.last!
            retMessage = achievements[done]!
        }
        
        for (steps, message) in achievements {
            if distance >= steps && steps > done && !doneAchievements.contains(steps) {
                doneAchievements.append(steps)
                retMessage = message
                done = steps
            }
        }
        return retMessage
        
    }
    
    func hardestHole(distance: Double) -> String {
        var holeNumber = 0
        if (distance <= 1) {
            return "The first kilometre's the hardest."
        }
        else if distance <= 2 {
            return "The second kilometre's the hardest."
        } else if distance <= 3 {
            return "The third kilometre's the hardest."
        } else {
            holeNumber = Int(ceil(distance))
        }
        
        
        return "The \(holeNumber)th kilometre's the hardest."
    }
    
    func reachedDistanceLifetimeAchievement(distance: Int) -> Bool {
        
        
        if distance % 1000000 == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func reachedStepsLifetimeAchievement(steps: Int) -> Bool {
        return false
    }

}