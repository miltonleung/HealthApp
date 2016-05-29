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
//        if let thisDistance = currentLifetimeDistanceAchievements.last {
//            if thisDistance % 1000 != 0 {
//                close.setTitle("Cool", forState: UIControlState.Normal)
//                close.backgroundColor = UIColor(red: 2, green: 115, blue: 227, alpha: 100)
//            }
//        }
        
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
        let random = Int(arc4random_uniform(UInt32(wordsOfEnc.count)))
        if let firstDate = NSUserDefaults.standardUserDefaults().stringForKey("firstDate") {
            if !currentLifetimeStepsAchievements.isEmpty {
                if let text = currentLifetimeStepsAchievements.last {
                    let newText = ModelInterface.sharedInstance.addThousandSeperator(text)
                    number.text = "\(newText) steps!"
                }
                let days = ModelInterface.sharedInstance.daysDifference(firstDate, endDate: NSDate())
                message.text = "\(wordsOfEnc[random])! It only took you \(days) days? Keep it up! Here's to the next million!"
                
                currentLifetimeStepsAchievements.removeLast()
            }
            else if !currentLifetimeDistanceAchievements.isEmpty {
                if let text = currentLifetimeDistanceAchievements.last {
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
                currentLifetimeDistanceAchievements.removeLast()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
