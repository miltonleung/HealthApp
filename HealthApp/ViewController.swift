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
    
    @IBOutlet weak var banner: UILabel!
    
    var healthManager:HealthManager?
    var firstDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthManager = HealthManager()
        
        
        authorizeHealthKit()
//        banner.text = ModelInterface.sharedInstance.hardestHole(CurrentStatsViewController.getDistance())
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
    
}

