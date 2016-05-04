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
    
    func getDayNameBy(stringDate: String) -> String
    {
        let df  = NSDateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.dateFromString(stringDate)!
        df.dateFormat = "EE"
        return df.stringFromDate(date);
    }
    
    func getDayNameByString(stringDate: String) -> String
    {
        let dateFormatter  = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.dateFromString(stringDate)!
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        return dateFormatter.stringFromDate(date);
    }
}