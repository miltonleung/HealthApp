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
    
    func readFirstDate(completion: (String, NSError!) -> Void) {
        let startDate = NSDate.distantPast()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, results, error) -> Void in
            if error != nil {
                print("Error retrieving first date")
                return
            }
            if let firstDate = results!.first?.startDate {
                let firstDateasString = DateHelper.convertDate(firstDate)
                completion(firstDateasString, nil)
            }
            
            
        }
        
        self.healthKitStore.executeQuery(query)
    }
    
    
    func readRecentSample(sampleType:HKQuantityType, completion: ([String]!, [Double]!, NSError!) -> Void)
    {
        let endDate = NSDate()
        let beginningOfDay = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: [])
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -7, toDate: beginningOfDay!, options: [])
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options:HKQueryOptions.StrictStartDate)
        
        let intervalComponent = NSDateComponents()
        intervalComponent.day = 1
        let anchorDate = NSCalendar.currentCalendar().dateFromComponents(intervalComponent)
        var dates = [String]()
        var distance = [Double]()
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .CumulativeSum, anchorDate: anchorDate!, intervalComponents: intervalComponent)
        query.initialResultsHandler = { query, result, error in
            if let queryError = error {
                completion(nil, nil, queryError)
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
                if let quantity = statistics.sumQuantity()?.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo)){
                    
                    let str = DateHelper.convertDate(statistics.startDate)
                    distance.append(quantity)
                    dates.append(str)
                }
            }
            if  result != nil {
                completion(dates, distance, nil)
            }
        }
//        query.statisticsUpdateHandler = { query, resultStatistics, statisticsCollection, error in
//            
//            guard let statsCollection = statisticsCollection else {
//                // Perform proper error handling here
//                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
//            }
//            let endDates = NSDate()
//            guard let startDates = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -7, toDate: beginningOfDay!, options: []) else {
//                fatalError("*** Unable to calculate the start date ***")
//            }
//            
//            dates = [String]()
//            distance = [Double]()
//            
//            statsCollection.enumerateStatisticsFromDate(startDates, toDate: endDates) {
//                [unowned self] statistics, stop in
//                if let quantity = statistics.sumQuantity()?.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo)){
//                    
//                    let str = DateHelper.convertDate(statistics.startDate)
//                    distance.append(quantity)
//                    dates.append(str)
//                    print("new data available")
//                }
//                
//                if  statisticsCollection != nil {
//                    completion(dates, distance, nil)
//                }
//            }
//        }
        self.healthKitStore.executeQuery(query)
            
        
    }
    
    func readYearSample(sampleType:HKQuantityType, completion: ([String]!, [Double]!, NSError!) -> Void)
    {
        let endDate = NSDate()
        
        let components = NSCalendar.currentCalendar().components([.Year, .Month], fromDate: NSDate())
        let startOfMonth = NSCalendar.currentCalendar().dateFromComponents(components)!
        
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -1, toDate: startOfMonth, options: [])
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options:HKQueryOptions.StrictStartDate)
        
        let intervalComponent = NSDateComponents()
        intervalComponent.month = 1
        let anchorDate = NSCalendar.currentCalendar().dateFromComponents(intervalComponent)
        var dates = [String]()
        var distance = [Double]()
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .CumulativeSum, anchorDate: anchorDate!, intervalComponents: intervalComponent)
        query.initialResultsHandler = { query, result, error in
            if let queryError = error {
                completion(nil, nil, queryError)
                return
            }
            
            guard let statsCollection = result else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            let endDates = NSDate()
            guard let startDates = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -1, toDate: startOfMonth, options: []) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            statsCollection.enumerateStatisticsFromDate(startDates, toDate: endDates) {
                [unowned self] statistics, stop in
                if let quantity = statistics.sumQuantity()?.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo)){
                    
                    let str = DateHelper.convertDate(statistics.startDate)
                    distance.append(quantity)
                    dates.append(str)
                }
            }
            if  result != nil {
                completion(dates, distance, nil)
            }
        }
        query.statisticsUpdateHandler = { query, resultStatistics, statisticsCollection, error in
            
            guard let statsCollection = statisticsCollection else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            let endDates = NSDate()
            guard let startDates = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -1, toDate: startOfMonth, options: []) else {
                fatalError("*** Unable to calculate the start date ***")
            }
            
            dates = [String]()
            distance = [Double]()
            
            statsCollection.enumerateStatisticsFromDate(startDates, toDate: endDates) {
                [unowned self] statistics, stop in
                if let quantity = statistics.sumQuantity()?.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo)){
                    
                    let str = DateHelper.convertDate(statistics.startDate)
                    distance.append(quantity)
                    dates.append(str)
                    print("new data available")
                }
                
                if  statisticsCollection != nil {
                    completion(dates, distance, nil)
                }
            }
        }
        self.healthKitStore.executeQuery(query)
        
        
    }
    
    func readTotalSample(sampleType: HKQuantityType, completion: ((String, HKQuantity)!, NSError!) -> Void)
    {
        
        let intervalComponent = NSDateComponents()
        intervalComponent.year = 100
        let anchorDate = NSCalendar.currentCalendar().dateFromComponents(intervalComponent)
        
        let firstDate = NSUserDefaults.standardUserDefaults().stringForKey("firstDate")
        let tempStart = DateHelper.convertStringtoDate(firstDate!)
        let startDate = NSCalendar.currentCalendar().startOfDayForDate(tempStart)

        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: NSDate(), options: HKQueryOptions.StrictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .CumulativeSum, anchorDate: anchorDate!, intervalComponents: intervalComponent)
        query.initialResultsHandler = { query, result, error in
            if let queryError = error {
                completion(nil, queryError)
                return
            }
            
            let endDate = NSDate()

            guard let statsCollection = result else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            
            if result != nil {
                statsCollection.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    [unowned self] statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let str = DateHelper.convertDate(statistics.startDate)
                        
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

            let endDate = NSDate()
            
            guard let statsCollection = statisticsCollection else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error?.localizedDescription) ***")
            }
            
            if statisticsCollection != nil {
                statsCollection.enumerateStatisticsFromDate(startDate, toDate: endDate) {
                    [unowned self] statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        let str = DateHelper.convertDate(statistics.startDate)
                        
                        let dateAndStat:(String, HKQuantity) = (str, quantity)
                        completion(dateAndStat, nil)
                        
                    }
                }
            }
        }
        self.healthKitStore.executeQuery(query)
    }
}