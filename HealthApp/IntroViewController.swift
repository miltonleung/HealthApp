//
//  IntroViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-27.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var welcomeView: UIView!
    @IBAction func existingButton(sender: AnyObject) {
        
    }
    @IBAction func freshButton(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            welcomeView.layer.cornerRadius = 11
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
