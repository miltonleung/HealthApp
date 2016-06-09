//
//  ShowcaseViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-29.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class ShowcaseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var showcaseView: UIView!
    @IBOutlet weak var achievementView: UIView!
    
    var delegate: RefreshDelegate?
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var completed: UILabel!
    @IBOutlet weak var achievementIcon: UIImageView!
    @IBOutlet weak var hideButton: UIButton!
    @IBAction func hideAchievement(sender: AnyObject) {
        achievementView.hidden = true
        hideButton.hidden = true
    }
    let reuseIdentifier = "cell"
    @IBAction func closeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true) {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "viewedAchievements")
            self.delegate?.resetMenuImage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showcaseView.layer.cornerRadius = 11
        achievementView.layer.cornerRadius = 11
        
        hideButton.hidden = true
        achievementView.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementsImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        let doneDistances = NSUserDefaults.standardUserDefaults().arrayForKey("doneLifetimeDistance") as? [Int]
        let doneSteps = NSUserDefaults.standardUserDefaults().arrayForKey("doneLifetimeSteps") as? [Int]
        var photoName = achievementsImages[indexPath.item]
        cell.achievementImage.image = UIImage(named: "\(achievementsImages[indexPath.item])")
        if photoName == "GoldS" {
            if !(doneDistances?.contains(3000))! && !(doneSteps?.contains(3000000))! {
                cell.achievementImage.alpha = 0.4
            }
        } else if photoName == "SilverS" {
            if !(doneDistances?.contains(2000))! && !(doneSteps?.contains(2000000))! {
                cell.achievementImage.alpha = 0.4
            }
        } else if photoName == "BronzeS" {
            if !(doneDistances?.contains(1000))! && !(doneSteps?.contains(1000000))! {
                cell.achievementImage.alpha = 0.4
            }
        } else {
            var truncated = String(photoName.characters.dropLast())
            let distanceKey = getKeyForValue(truncated, dictionary: lifetimeDistanceAchievementsImage)
            if distanceKey != -1 {
                if !doneDistances!.contains(distanceKey) {
                    cell.achievementImage.alpha = 0.4
                }
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Segue right here")
        
        let doneDistances = NSUserDefaults.standardUserDefaults().arrayForKey("doneLifetimeDistance") as? [Int]
        let doneSteps = NSUserDefaults.standardUserDefaults().arrayForKey("doneLifetimeSteps") as? [Int]
        
        var data = NSUserDefaults.standardUserDefaults().objectForKey("doneLifetimeDistanceDates") as! NSData
        var doneDistanceDates = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Dictionary<Int,String>
        var data1 = NSUserDefaults.standardUserDefaults().objectForKey("doneLifetimeStepsDates") as! NSData
        var doneStepsDates = NSKeyedUnarchiver.unarchiveObjectWithData(data1) as! Dictionary<Int,String>
        let firstDate = NSUserDefaults.standardUserDefaults().stringForKey("firstDate")
        
        var photoName = achievementsImages[indexPath.item]
        
        var truncated = String(photoName.characters.dropLast())
        achievementIcon.image = UIImage(named: "\(truncated)")
        achievementIcon.alpha = 1
        if photoName == "GoldS" {
            if doneDistances?.contains(3000) == nil && doneSteps?.contains(3000000) == nil {
                achievementIcon.alpha = 0.4
                message.text = "???"
                completed.text = ""
            } else if doneDistances?.contains(3000) != nil {
                header.text = "3000 km!"
                message.text = "You walked 3000 km!"
                
                if let date = doneDistanceDates[3000] {
                    let days = ModelInterface.sharedInstance.daysDifferenceStrings(firstDate!, endString: date)
                    completed.text = "Completed on \(date), took \(days) days"
                }
            } else {
                header.text = "3000000 steps!"
                message.text = "You walked 3000000 steps!"
                
                if let date = doneStepsDates[3000000] {
                    let days = ModelInterface.sharedInstance.daysDifferenceStrings(firstDate!, endString: date)
                    completed.text = "Completed on \(date), took \(days) days"
                }
            }
            
        } else if photoName == "SilverS" {
            if doneDistances?.contains(2000) == nil && doneSteps?.contains(2000000) == nil {
                achievementIcon.alpha = 0.4
                message.text = "???"
                completed.text = ""
            } else if doneDistances?.contains(2000) != nil {
                header.text = "2000 km!"
                message.text = "You walked 2000 km!"
                
                if let date = doneDistanceDates[2000] {
                    let days = ModelInterface.sharedInstance.daysDifferenceStrings(firstDate!, endString: date)
                    completed.text = "Completed on \(date), took \(days) days"
                }
            } else {
                header.text = "2000000 steps!"
                message.text = "You walked 2000000 steps!"
                
                if let date = doneStepsDates[2000000] {
                    let days = ModelInterface.sharedInstance.daysDifferenceStrings(firstDate!, endString: date)
                    completed.text = "Completed on \(date), took \(days) days"
                }
            }
            
        } else if photoName == "BronzeS" {
            if doneDistances?.contains(1000) == nil && doneSteps?.contains(1000000) == nil {
                achievementIcon.alpha = 0.4
                message.text = "???"
                completed.text = ""
            } else if doneDistances?.contains(1000) != nil {
                header.text = "1000 km!"
                message.text = "You walked 1000 km!"
                
                if let date = doneDistanceDates[1000] {
                    let days = ModelInterface.sharedInstance.daysDifferenceStrings(firstDate!, endString: date)
                    completed.text = "Completed on \(date), took \(days) days"
                }
            } else {
                header.text = "1000000 steps!"
                message.text = "You walked 1000000 steps!"
                
                if let date = doneStepsDates[1000000] {
                    let days = ModelInterface.sharedInstance.daysDifferenceStrings(firstDate!, endString: date)
                    completed.text = "Completed on \(date), took \(days) days"
                }
            }
        } else {
            
            let distanceKey = getKeyForValue(truncated, dictionary: lifetimeDistanceAchievementsImage)
            if distanceKey != -1 {
                header.text = lifetimeDistanceAchievements[distanceKey]
                if let description = lifetimeDistanceAchievementsDescription[distanceKey] {
                    message.text = "Did you know \(description)"
                }
                if !doneDistances!.contains(distanceKey) {
                    achievementIcon.alpha = 0.4
                    message.text = "???"
                    completed.text = ""
                }
                if let date = doneDistanceDates[distanceKey] {
                    let days = ModelInterface.sharedInstance.daysDifferenceStrings(firstDate!, endString: date)
                    completed.text = "Completed on \(date), took \(days) days"
                }
            }
        }
        achievementView.hidden = false
        hideButton.hidden = false
        
    }
    
    func getKeyForValue(value: String, dictionary: [Int: String]) -> Int{
        for (distance, string) in dictionary {
            if string == value {
                return distance
            }
        }
        return -1
    }
    
}
