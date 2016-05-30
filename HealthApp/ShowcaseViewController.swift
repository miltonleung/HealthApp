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
    let reuseIdentifier = "cell"
    @IBAction func closeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showcaseView.layer.cornerRadius = 11
        
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
