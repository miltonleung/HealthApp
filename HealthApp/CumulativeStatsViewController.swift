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
    
    var healthManager:HealthManager?
    var firstDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        healthManager = HealthManager()
        
        authorizeHealthKit()

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
            self.firstDate = ModelInterface.sharedInstance.getDayNameByString(date)
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
                self.cumulativeSteps.text = "total steps: \(totalResult) since \(self.firstDate)"
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
                self.cumulativeDistance.text = "total distance: \(totalResult) since \(self.firstDate)"
                print(self.cumulativeDistance.text!)
            });
        });
    }

}
