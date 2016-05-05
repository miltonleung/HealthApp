//
//  CurrentStatsViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-02.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import CoreMotion

class CurrentStatsViewController: UIViewController {
    
    @IBOutlet weak var currentSteps: UILabel!
    @IBOutlet weak var currentDistance: UILabel!
    @IBOutlet weak var date: UILabel!
    let pedometer = CMPedometer()
    var distanceValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateext = ModelInterface.sharedInstance.convertDate(NSDate())
        self.date.text = "for \(ModelInterface.sharedInstance.getDayNameByString(dateext))"
        
        self.updatePedometer()
    }
    
    func updatePedometer() {
        
        if (CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable()) {
            let beginningOfDay = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: [])
            self.pedometer.queryPedometerDataFromDate(beginningOfDay!, toDate: NSDate()) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if error == nil {
                        if let numberOfSteps = data?.numberOfSteps {
                            self.currentSteps.text = "\(numberOfSteps)"
                            print(data?.numberOfSteps)
                        }
                        if let distance = data?.distance {
                            self.currentDistance.text = String(format: "%.2f", distance.doubleValue/1000)
//                            self.banner.text = ModelInterface.sharedInstance.reachedAchievement(distance.integerValue/1000)
//                            print(self.banner.text)
                            print(data?.distance)
                        }
                    }
                });
            }
            self.pedometer.startPedometerUpdatesFromDate(beginningOfDay!) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let numberOfSteps = data?.numberOfSteps {
                        self.currentSteps.text = "this is the updated \(numberOfSteps.integerValue)"
                        print(data?.numberOfSteps)
                    }
                    if let distance = data?.distance {
                        self.currentDistance.text = String(format: "%.2f", distance.doubleValue/1000)
//                        self.banner.text = ModelInterface.sharedInstance.reachedAchievement(distance.integerValue/1000)
//                        print(self.banner.text)
                        self.distanceValue = distance.doubleValue/1000
                        print(data?.distance)
                    }
                });
            }
        }
        
    }
    func getDistance() -> Double {
        return distanceValue
    }
}