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
    
    var delegate: RefreshDelegate?

    @IBOutlet weak var thirdLayer: UIImageView!
    @IBAction func closeButton(sender: AnyObject) {
        
        if (!currentLifetimeDistanceAchievements.isEmpty || !currentLifetimeStepsAchievements.isEmpty) {
            updateAchievements()
        }
        else {
            medalAlert = true
            dismissViewControllerAnimated(true) {
                self.delegate?.resetMenuImage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AchievementsView.layer.cornerRadius = 11
        titleLabel.text = "Lifetime Achievement"

        updateAchievements()
    }
    
    func updateAchievements() {
        secondLayer.hidden = true
        thirdLayer.hidden = true
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
            secondLayer.hidden = false
            if tempCombinedAchievements[1] % 1000 == 0 {
                secondLayer.image = UIImage(named: "SecondLight")
            } else {
                secondLayer.image = UIImage(named: "SecondDark")
            }
        }
        if reps >= 3 {
            thirdLayer.hidden = false
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
                    let newText = DateHelper.addThousandSeperator(text)
                    number.text = "\(newText) steps!"
                    if text <= 1000000 {
                        icon.image = UIImage(named: "Bronze")
                    }
                    else if text <= 2000000 {
                        icon.image = UIImage(named: "Silver")
                    }
                    else {
                        icon.image = UIImage(named: "Gold")
                    }
                }
                let days = DateHelper.daysDifference(firstDate, endDate: NSDate())
                message.text = "\(wordsOfEnc[random])! It only took you \(days) days? Keep it up! Here's to the next million!"
                
                currentLifetimeStepsAchievements.removeFirst()
            }
            else if !currentLifetimeDistanceAchievements.isEmpty {
                if let text = currentLifetimeDistanceAchievements.first {
                    let newText = DateHelper.addThousandSeperator(text)
                    number.text = "\(newText) km!"
                    let days = DateHelper.daysDifference(firstDate, endDate: NSDate())
                    if text % 1000 == 0 {
                        if text <= 1000 {
                            icon.image = UIImage(named: "Bronze")
                        }
                        else if text <= 2000 {
                            icon.image = UIImage(named: "Silver")
                        }
                        else {
                            icon.image = UIImage(named: "Gold")
                        }
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
