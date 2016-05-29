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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var secondLayer: UIImageView!

    @IBOutlet weak var thirdLayer: UIImageView!
    @IBAction func closeButton(sender: AnyObject) {
        
        if (!currentLifetimeDistanceAchievements.isEmpty || !currentLifetimeStepsAchievements.isEmpty) {
            updateAchievements()
        }
        else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AchievementsView.layer.cornerRadius = 11

        
        updateAchievements()
    }
    
    func updateAchievements() {
        let tempCombinedAchievements = currentLifetimeStepsAchievements + currentLifetimeDistanceAchievements
        let reps = tempCombinedAchievements.count
        if reps >= 1 {
            if tempCombinedAchievements[0] % 1000 == 0 {
                AchievementsView.backgroundColor = UIColor(patternImage: UIImage(named: "FirstLight")!)
            } else {
                AchievementsView.backgroundColor = UIColor(patternImage: UIImage(named: "FirstDark")!)
            }
        }
        if reps >= 2 {
            if tempCombinedAchievements[1] % 1000 == 0 {
                secondLayer.image = UIImage(named: "SecondLight")
            } else {
                secondLayer.image = UIImage(named: "SecondDark")
            }
        }
        if reps >= 3 {
            if tempCombinedAchievements[2] % 1000 == 0 {
                thirdLayer.image = UIImage(named: "ThirdLight")
            } else {
                thirdLayer.image = UIImage(named: "ThirdDark")
            }
            
        }
        let random = Int(arc4random_uniform(UInt32(wordsOfEnc.count)))
        if let firstDate = NSUserDefaults.standardUserDefaults().stringForKey("firstDate") {
            if !currentLifetimeStepsAchievements.isEmpty {
                if let text = currentLifetimeStepsAchievements.first {
                    let newText = ModelInterface.sharedInstance.addThousandSeperator(text)
                    number.text = "\(newText) steps!"
                }
                let days = ModelInterface.sharedInstance.daysDifference(firstDate, endDate: NSDate())
                message.text = "\(wordsOfEnc[random])! It only took you \(days) days? Keep it up! Here's to the next million!"
                
                currentLifetimeStepsAchievements.removeFirst()
            }
            else if !currentLifetimeDistanceAchievements.isEmpty {
                if let text = currentLifetimeDistanceAchievements.first {
                    let newText = ModelInterface.sharedInstance.addThousandSeperator(text)
                    number.text = "\(newText) km!"
                    let days = ModelInterface.sharedInstance.daysDifference(firstDate, endDate: NSDate())
                    if text % 1000 == 0 {
                        icon.image = UIImage(named: "Medal")
                        titleLabel.text = "Lifetime Achievement"
                        message.text = "\(wordsOfEnc[random])! It only took you \(days) days? Keep it up! Here's to the next thousand!"
                    }
                    else {
                        if let image = lifetimeDistanceAchievementsImage[text] {
                            icon.image = UIImage(named: "\(image)")
                        }
                        close.setTitle("Cool", forState: UIControlState.Normal)
                        titleLabel.text = lifetimeDistanceAchievements[text]
                        if let description = lifetimeDistanceAchievementsDescription[text] {
                            message.text = "Did you know \(description) It only took you \(days) days!"
                        }
                    }
                }
                currentLifetimeDistanceAchievements.removeFirst()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
