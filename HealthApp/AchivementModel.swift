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
        if doneAchievements.count > 0 {
            done = doneAchievements.last!
        }
        var retMessage = ""
        for (steps, message) in achievements {
            if distance >= steps && !doneAchievements.contains(steps) {
                doneAchievements.append(steps)
                retMessage = message
            }
        }
        return retMessage
        
    }

}