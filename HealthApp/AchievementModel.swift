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

}