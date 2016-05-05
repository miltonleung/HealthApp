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
            return "The first km's the hardest."
        }
        else if distance <= 2 {
            return "The second km's the hardest."
        } else if distance <= 3 {
            return "The third km's the hardest."
        } else {
            holeNumber = Int(ceil(distance))
        }
        
        
        return "The \(holeNumber)th km's the hardest."
    }

}