//
//  WelcomeViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-27.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import HealthKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var authorizeView: UIView!
    @IBOutlet weak var message: UILabel!
    
    var healthManager:HealthManager?
    
    @IBAction func accept(sender: AnyObject) {
        authorizeHealthKit()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeView.layer.cornerRadius = 11
        healthManager = HealthManager()
        
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
                self.dismissViewControllerAnimated(true, completion: nil)
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
