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
        
        if (!currentLifetimeDistanceAchievements.isEmpty || !currentLifetimeStepsAchievements.isEmpty) {
            updateAchievements()
        }
        else {
            //        dismissViewControllerAnimated(false, completion: nil)
            dismissViewControllerAnimated(true, completion: { () -> Void in
                //            NSNotificationCenter.defaultCenter().postNotificationName("multipleAchievement", object: nil)
            });
        }
    }
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
////        AchievementsView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).CGColor
//        AchievementsView.layer.shadowColor = UIColor.blackColor().CGColor
//
//        AchievementsView.layer.shadowOffset = CGSize(width: 1, height: -1)
//        AchievementsView.layer.shadowOpacity = 0.8
//        AchievementsView.layer.shadowRadius = 3
//        AchievementsView.clipsToBounds = true
//        view.addSubview(AchievementsView)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AchievementsView.layer.cornerRadius = 11
        AchievementsView.backgroundColor = UIColor(patternImage: UIImage(named: "SingleAchievements")!)
        
//        AchievementsView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).CGColor
//        AchievementsView.layer.shadowOffset = CGSize(width: 1, height: -1)
//        AchievementsView.layer.shadowRadius = 3
//        
//        view.addSubview(AchievementsView)

        updateAchievements()
        
    }
    
    func updateAchievements() {
        let reps = currentLifetimeStepsAchievements.count + currentLifetimeDistanceAchievements.count
        if reps == 1 {
            AchievementsView.backgroundColor = UIColor(patternImage: UIImage(named: "SingleAchievements")!)
        }
        else if reps == 2 {
            AchievementsView.backgroundColor = UIColor(patternImage: UIImage(named: "TwoAchievements")!)
        }
        else {
            AchievementsView.backgroundColor = UIColor(patternImage: UIImage(named: "MultipleAchievements")!)

        }
        
        if !currentLifetimeStepsAchievements.isEmpty {
            if let text = currentLifetimeStepsAchievements.last {
                let newText = ModelInterface.sharedInstance.addThousandSeperator(text)
                number.text = "\(newText) steps!"
            }
            //        let days = ModelInterface.sharedInstance().daysDifference(<#T##startString: String##String#>, endDate: <#T##NSDate#>)
            message.text = "It only took you 91 days? Keep it up! Here's to the next million!"
            
            currentLifetimeStepsAchievements.removeLast()
        }
        else if !currentLifetimeDistanceAchievements.isEmpty {
            if let text = currentLifetimeDistanceAchievements.last {
                let newText = ModelInterface.sharedInstance.addThousandSeperator(text)
                number.text = "\(newText) km!"
            }
            //        let days = ModelInterface.sharedInstance().daysDifference(<#T##startString: String##String#>, endDate: <#T##NSDate#>)
            message.text = "It only took you 91 days? Keep it up! Here's to the next thousand!"
            
            currentLifetimeDistanceAchievements.removeLast()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
