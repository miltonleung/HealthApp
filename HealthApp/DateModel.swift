//
//  DateModel.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-04-30.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation

protocol ConvertProtocol {
    func convertDate(date: NSDate) -> String
    func getDayNameBy(stringDate: String) -> String
    func getMonthNameBy(stringDate: String) -> String
    func getDayNameByString(stringDate: String) -> String
    func addThousandSeperator(number: Int) -> String
}

extension ModelInterface: ConvertProtocol {
    
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
    
    func getMonthNameBy(stringDate: String) -> String
    {
        let df  = NSDateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.dateFromString(stringDate)!
        df.dateFormat = "MMM"
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
    func addThousandSeperator(number: Int) -> String
    {
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return numberFormatter.stringFromNumber(number)!
    }
}