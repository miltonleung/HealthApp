//
//  DateModel.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-04-30.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

protocol DateProtocol {
    func convertDate(date: NSDate) -> String
}

extension ModelInterface: DateProtocol {
    
    func convertDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.stringFromDate(date)
        return str
    }
    
}