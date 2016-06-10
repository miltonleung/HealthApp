//
//  MenuViewController.swift
//  SmallSteps
//
//  Created by Milton Leung on 2016-06-05.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell"
    var images = ["Statistics",
                  "Tri",
                  "Progress",
                  "Friends",
                  "GearWhite"]
    var labels = ["statistics",
                  "medals",
                  "progress",
                  "coming soon",
                  "settings"]
    

    @IBAction func closeButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var interactor:Interactor? = nil
    
    var menuSelectDelegate:MenuSelectDelegate? = nil
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        
        let progress = MenuHelper.calculateProgress(
            translation,
            viewBounds: view.bounds,
            direction: .Left
        )
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                // 6
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MenuCollectionViewCell
        
        
        cell.label.text = labels[indexPath.item]
        if (medalAlert == true && indexPath.item == 1) || (progressAlert == true && indexPath.item == 2) {
            cell.menuImage.image = UIImage(named: "\(images[indexPath.item])Alert")
        }
        else {
            cell.menuImage.image = UIImage(named: "\(images[indexPath.item])")
        }
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsetsMake(0, 4, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if labels[indexPath.item] == "progress" {
            progressAlert = false
        }
        else if labels[indexPath.item] == "medals" {
            medalAlert = false
        }
        if labels[indexPath.item] != "coming soon" {
            menuSelectDelegate?.segue(labels[indexPath.item])
        }
        
    }
    
}
