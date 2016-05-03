//
//  ViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-04-29.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var pedometerSteps: UILabel!
    @IBOutlet weak var banner: UILabel!
    @IBOutlet weak var pedometerDistance: UILabel!
    
    var stepsDictionary = [String: HKQuantity]()
    var distanceDictionary = [String: HKQuantity]()
    var healthManager:HealthManager?
    let pedometer = CMPedometer()
    var firstDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthManager = HealthManager()
        
        
        authorizeHealthKit()
        self.updatePedometer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authorizeHealthKit()
    {
        healthManager!.authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                print("HealthKit authorized")
                
            }
            else {
                print("HealthKit denied")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }
    
    func updatePedometer() {
        
        if (CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable()) {
            let beginningOfDay = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: [])
            self.pedometer.queryPedometerDataFromDate(beginningOfDay!, toDate: NSDate()) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if error == nil {
                        if let numberOfSteps = data?.numberOfSteps {
                            self.pedometerSteps.text = "\(numberOfSteps)"
//                            self.banner.text = ModelInterface.sharedInstance.reachedAchievement(numberOfSteps.integerValue)
//                            print(self.banner.text)
                            print(data?.numberOfSteps)
                        }
                        if let distance = data?.distance {
                            self.pedometerDistance.text = String(format: "%.2f", distance.doubleValue/1000)
                            self.banner.text = ModelInterface.sharedInstance.reachedAchievement(distance.integerValue/1000)
                            print(self.banner.text)
                            print(data?.distance)
                        }
                    }
                });
            }
            self.pedometer.startPedometerUpdatesFromDate(beginningOfDay!) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let numberOfSteps = data?.numberOfSteps {
                        self.pedometerSteps.text = "this is the updated \(numberOfSteps.integerValue)"
//                        self.banner.text = ModelInterface.sharedInstance.reachedAchievement(numberOfSteps.integerValue)
//                        print(self.banner.text)
                        print(data?.numberOfSteps)
                    }
                    if let distance = data?.distance {
                        self.pedometerDistance.text = String(format: "%.2f", distance.doubleValue/1000)
                        self.banner.text = ModelInterface.sharedInstance.reachedAchievement(distance.integerValue/1000)
                        print(self.banner.text)
                        print(data?.distance)
                    }
                });
            }
        }
        
    }
}

