//
//  AchievementsViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-24.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    let data = Data()
    
    @IBOutlet weak var AchievementsView: UIView!
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBAction func closeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AchievementsView.layer.cornerRadius = 11
        // Do any additional setup after loading the view.
        number.text = "\(data.currentLifetimeDistanceAchievements.last) km!"
//        let days = ModelInterface.sharedInstance().daysDifference(<#T##startString: String##String#>, endDate: <#T##NSDate#>)
        message.text = "It only took you 91 days? Keep it up! Here's to the next thousand!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
