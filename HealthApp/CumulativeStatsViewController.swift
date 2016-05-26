//
//  CumulativeStatsViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-02.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import HealthKit

class CumulativeStatsViewController: UIViewController {
    
    @IBOutlet weak var cumulativeSteps: UILabel!
    @IBOutlet weak var cumulativeDistance: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var healthManager:HealthManager?
    let data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        healthManager = HealthManager()
        
        authorizeHealthKit()
        updateFirstDate()
    }
    
    func authorizeHealthKit() {
        healthManager!.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorized")
                self.updateFirstDate()
                self.updateTotalSteps()
                self.updateTotalDistance()
                
            }
            else {
                print("HealthKit denied")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }
    
    func updateFirstDate() {
        
        self.healthManager?.readFirstDate({ (date, error) -> Void in
            if (error != nil) {
                print("Error reading first date from HealthKit")
                return
            }
            
            self.date.text = "since \(ModelInterface.sharedInstance.getDayNameByString(date))"
        });
    }

    func updateTotalSteps() {
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        self.healthManager?.readTotalSample(stepsCount!, completion: { (totalSteps, error) -> Void in
            if (error != nil) {
                print("Error reading total steps from HealthKit")
                return;
            }
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let totalResult = Int(totalSteps.1.doubleValueForUnit(HKUnit.countUnit()))
                self.data.totalSteps = totalResult
                let totalResultwithCommas = ModelInterface.sharedInstance.addThousandSeperator(totalResult)
                self.cumulativeSteps.text = "\(totalResultwithCommas)"
                print(self.cumulativeSteps.text!)
            });
        });
    }
    func updateTotalDistance() {
        let distanceType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        self.healthManager?.readTotalSample(distanceType!, completion: { (totalDistance, error) -> Void in
            if (error != nil) {
                print("Error reading total distance from HealthKit")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let totalResult = Int(totalDistance.1.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo)))
                self.data.totalDistance = totalResult
                let totalResultwithCommas = ModelInterface.sharedInstance.addThousandSeperator(totalResult)
                self.cumulativeDistance.text = "\(totalResultwithCommas) km"
                print(self.cumulativeDistance.text!)
            });
        });
    }

}
