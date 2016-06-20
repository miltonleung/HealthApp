//
//  ProgressViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-27.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var progressView: UIView!
    
    var scenario: Int!
    var average: Double!
    var targetDistance: Int!
    var count: Int!
    
    var delegate: RefreshDelegate?
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var dailyAverage: UILabel!
    @IBOutlet weak var dailyTarget: UILabel!
    
    @IBAction func noButton(sender: AnyObject) {
        dismissViewControllerAnimated(true) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "viewedProgress")
            progressAlert = false
            self.delegate?.resetMenuImage()
        }
    }
    @IBAction func addButton(sender: AnyObject) {
        var td = targetDistance
        let ts = NSUserDefaults.standardUserDefaults().integerForKey("targetSteps")
        if scenario == 0 {
            td = targetDistance + 2
            NSUserDefaults.standardUserDefaults().setInteger(targetDistance + 2, forKey: "targetDistance")
        } else if scenario == 1 {
            td = targetDistance + 1
            NSUserDefaults.standardUserDefaults().setInteger(targetDistance + 1, forKey: "targetDistance")
        } else if scenario == 2 {
            
        } else if scenario == 3 {
            td = targetDistance - 1
            NSUserDefaults.standardUserDefaults().setInteger(targetDistance - 1, forKey: "targetDistance")
        }
        dismissViewControllerAnimated(true) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "viewedProgress")
            progressAlert = false
            self.delegate?.resetMenuImage()
            self.delegate?.refresh(td, ts: ts)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.layer.cornerRadius = 11
        setup()
        let avg = String(format: "%.2f", average)
        dailyAverage.text = "daily average:     \(avg) km"
        dailyTarget.text = "daily target:       \(targetDistance) km"
        
    }

    func setup() {
        let random = Int(arc4random_uniform(UInt32(wordsOfEnc.count)))
        if scenario == 0 {
            message.text = "\(wordsOfEnc[random])! You have reached your target \(count) times in the past week! Do you want us to crank it up?"
            add.setTitle("+2", forState: .Normal)
        } else if scenario == 1 {
            message.text = "\(wordsOfEnc[random])! You have reached your target \(count) times in the past week! Do you want us to take it up a notch?"
            add.setTitle("+1", forState: .Normal)
        } else if scenario == 2 {
            message.text = "You've got some good days! ..and some not so great ones. You have reached your target \(count) times in the past week. Try being more consistent!"
            add.setTitle("OK", forState: .Normal)
        } else if scenario == 3 {
            message.text = "Go easy on yourself! You have reached your target \(count) times in the past week. Do you want us to take it down a notch?"
            add.setTitle("-1", forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
