//
//  PopUpViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-22.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var inputTarget: UITextField!
    @IBAction func closeButton(sender: AnyObject) {
        
        print(inputTarget)
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 25
//        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        inputTarget.text = String(targetDistance)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
