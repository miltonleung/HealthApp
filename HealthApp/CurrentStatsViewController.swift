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
    @IBOutlet weak var outOfSteps: UILabel!
    @IBOutlet weak var outOfDistance: UILabel!
    let pedometer = CMPedometer()
//    var delegate: CurrentStatsViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let ts = NSUserDefaults.standardUserDefaults().integerForKey("targetSteps")
        let steps = ModelInterface.sharedInstance.addThousandSeperator(ts)
            
            
        outOfSteps.text = "out of \(steps)"
        
        let td = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
        
        outOfDistance.text = "out of \(td) km"
        
        
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
                            let result = ModelInterface.sharedInstance.addThousandSeperator(numberOfSteps.integerValue)
                            self.currentSteps.text = "\(result)"
                            print(data?.numberOfSteps)
                        }
                        if let distance = data?.distance {
                            self.currentDistance.text = String(format: "%.2f", distance.doubleValue/1000)
                            print(data?.distance)
                        }
                    }
                });
            }
            self.pedometer.startPedometerUpdatesFromDate(beginningOfDay!) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let numberOfSteps = data?.numberOfSteps {
                        let result = ModelInterface.sharedInstance.addThousandSeperator(numberOfSteps.integerValue)
                        self.currentSteps.text = "\(result)"
                        print(data?.numberOfSteps)
                    }
                    if let distance = data?.distance {
                        self.currentDistance.text = String(format: "%.2f", distance.doubleValue/1000)
                        print(data?.distance)
                    }
                });
            }
        }
        
    }
}