//
//  HealthManager.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-04-29.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!) {
        
        let healthKitReadSet = Set(arrayLiteral:
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
                                   HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
        )
        
        if !HKHealthStore.isHealthDataAvailable() {
            
            let error = NSError(domain: "milton.HealthBasics", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            
            if (completion != nil) {
                completion(success:false, error:error)
            }
            
            return;
        }
        
        healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitReadSet) { (success, error) -> Void in
            if (completion != nil ) {
                completion(success:success, error:error)
            }
        }
    }
    
    func readRecentSample(sampleType:HKQuantityType, inout recentData: [String: HKQuantity], completion: (([String: HKQuantity]!, NSError!) -> Void)!)
    {
        let endDate = NSDate()
        let beginningOfDay = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: [])
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -7, toDate: beginningOfDay!, options: [])
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options:HKQueryOptions.StrictStartDate)
        
        let intervalComponent = NSDateComponents()
        intervalComponent.day = 1
        let anchorDate = NSCalendar.currentCalendar().dateFromComponents(intervalComponent)
        //        var dates = [String]()
        //        var recentData = [String: HKQuantity]()
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .CumulativeSum, anchorDate: anchorDate!, intervalComponents: intervalComponent)
        query.initialResultsHandler = { query, result, error in
            if let queryError = error {
                completion(nil, queryError)
                return
            }
            
            guard let statsCollection = result else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            let endDates = NSDate()
            guard let startDates = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -7, toDate: beginningOfDay!, options: []) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            statsCollection.enumerateStatisticsFromDate(startDates, toDate: endDates) {
                [unowned self] statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let str = dateFormatter.stringFromDate(statistics.startDate)
                    
                    //                    if !dates.contains(str) {
                    //                        dates.append(str)
                    //                    }
                    recentData[str] = quantity
                }
            }
            if  result != nil {
                completion(recentData, nil)
            }
        }
        query.statisticsUpdateHandler = { query, resultStatistics, statisticsCollection, error in
            
            guard let statsCollection = statisticsCollection else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            let endDates = NSDate()
            guard let startDates = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -7, toDate: beginningOfDay!, options: []) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            statsCollection.enumerateStatisticsFromDate(startDates, toDate: endDates) {
                [unowned self] statistics, stop in
                //                if let quantity = statistics.sumQuantity() {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let str = dateFormatter.stringFromDate(statistics.startDate)
                
                //                    if !dates.contains(str) {
                //                        dates.append(str)
                //                    }
                recentData[str] = statistics.sumQuantity()
                //                }
            }
            if  statisticsCollection != nil {
                completion(recentData, nil)
            }
        }
        self.healthKitStore.executeQuery(query)
    }
    
    func readTotalSample(sampleType: HKQuantityType, completion: ((String, HKQuantity)!, NSError!) -> Void)
    {
        
        let intervalComponent = NSDateComponents()
        intervalComponent.year = 100
        let anchorDate = NSCalendar.currentCalendar().dateFromComponents(intervalComponent)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: nil, options: .CumulativeSum, anchorDate: anchorDate!, intervalComponents: intervalComponent)
        query.initialResultsHandler = { query, result, error in
            if let queryError = error {
                completion(nil, queryError)
                return
            }
            let startDate = NSDate.distantPast()
            let endDate = NSDate()
            
            guard let statsCollection = result else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }

            if result != nil {
                statsCollection.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    [unowned self] statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let str = dateFormatter.stringFromDate(statistics.startDate)
                        
                        let dateAndStat:(String, HKQuantity) = (str, quantity)
                        completion(dateAndStat, nil)
                        
                    }
                }
            }
        }
        
        query.statisticsUpdateHandler = { query, resultStatistics, statisticsCollection, error in
            print("Updating")
            if let queryError = error {
                completion(nil, queryError)
                return
            }
            let startDate = NSDate.distantPast()
            let endDate = NSDate()
            
            guard let statsCollection = statisticsCollection else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            
            if statisticsCollection != nil {
                statsCollection.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    [unowned self] statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let str = dateFormatter.stringFromDate(statistics.startDate)
                        
                        let dateAndStat:(String, HKQuantity) = (str, quantity)
                        completion(dateAndStat, nil)
                        
                    }
                }
            }
        }
        self.healthKitStore.executeQuery(query)
    }
}