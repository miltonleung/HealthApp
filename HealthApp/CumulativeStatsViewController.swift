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
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var cumulativeSteps: UILabel!
    @IBOutlet weak var cumulativeDistance: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var healthManager:HealthManager?
    let data = Data()
    
    // Passed in from view controller
    var firstDate:String!
    var totalSteps:Int!
    var totalDistance:Double!
    
    @IBAction func closeButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        healthManager = HealthManager()
        
        popUpView.layer.cornerRadius = 11
        
        authorizeHealthKit()
        updateFirstDate()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateTotalSteps()
        self.updateTotalDistance()
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
        if let firstDate = NSUserDefaults.standardUserDefaults().stringForKey("firstDate") {
            self.date.text = "since \(firstDate)"
        }
    }
    
    func updateTotalSteps() {
        
        let totalResultwithCommas = DateHelper.addThousandSeperator(totalSteps)
        self.cumulativeSteps.text = "\(totalResultwithCommas)"
        print(self.cumulativeSteps.text!)
        
    }
    func updateTotalDistance() {
        
        
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        let rounded = numberFormatter.stringFromNumber(totalDistance)!
        //                let totalResultwithCommas = String(format: "%.1f", rounded)
        
        self.cumulativeDistance.text = "\(rounded) km"
        print(self.cumulativeDistance.text!)
        
    }
    
}
