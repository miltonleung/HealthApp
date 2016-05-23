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
    @IBOutlet weak var inputSteps: UITextField!
    @IBAction func closeButton(sender: AnyObject) {
        
        if (inputTarget.text != "" && inputTarget.text != "0") {
            targetDistance = Int(inputTarget.text!)!
        }
        
        if (inputSteps.text != "" && inputSteps.text != "0") {
            targetSteps = Int(inputSteps.text!)! * 1000
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 25
//        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(animated: Bool) {
        inputTarget.text = String(targetDistance)
        inputSteps.text = String(targetSteps/1000)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
