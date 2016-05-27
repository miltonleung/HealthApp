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
    
}

extension ModelInterface: AchievementProtocol {
    func reachedAchievement(distance: Int) -> String {
        var done:Int = 0
        var retMessage = ""
        
        if var doneDaily = NSUserDefaults.standardUserDefaults().arrayForKey("doneDaily") as? [Int] {
            
            if doneDaily.count > 0 {
                done = doneDaily.last!
                retMessage = dailyAchievements[done]!
            }
            
            for (steps, message) in dailyAchievements {
                if distance >= steps && steps > done && !doneDaily.contains(steps) {
                    doneDaily.append(steps)
                    retMessage = message
                    done = steps
                }
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
}