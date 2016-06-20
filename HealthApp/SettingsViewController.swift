//
//  PopUpViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-22.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var stepsPicker: UITextField!
    @IBOutlet weak var distancePicker: UITextField!
    
    var delegate: RefreshDelegate?
    
    var stepsOptions = ["1000", "2000", "3000", "4000", "5000", "6000", "7000", "8000", "9000", "10000", "11000", "12000"]
    var distanceOptions = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    @IBAction func closeButton(sender: AnyObject) {
        var td:Int?
        var ts:Int?
        if (distancePicker.text != "" && distancePicker.text != "0") {
            td = Int(distancePicker.text!)!
            NSUserDefaults.standardUserDefaults().setInteger(td!, forKey: "targetDistance")
        }
        
        if (stepsPicker.text != "" && stepsPicker.text != "0") {
            ts = Int(stepsPicker.text!)!
            NSUserDefaults.standardUserDefaults().setInteger(ts!, forKey: "targetSteps")
        }
        
        dismissViewControllerAnimated(true) {
            self.delegate?.refresh(td!, ts: ts!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 11
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        var stepsPickerView = UIPickerView()
        stepsPickerView.tag = 1
        stepsPickerView.delegate = self
        stepsPicker.inputView = stepsPickerView
        
        var distancePickerView = UIPickerView()
        distancePickerView.tag = 2
        distancePickerView.delegate = self
        distancePicker.inputView = distancePickerView
        
        distancePicker.delegate = self
        stepsPicker.delegate = self
        
        let td = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
        distancePicker.text = String(td)
        let ts = NSUserDefaults.standardUserDefaults().integerForKey("targetSteps")
        stepsPicker.text = String(ts)
        
        let stepsRow = stepsOptions.indexOf(String(ts))
        stepsPickerView.selectRow(stepsRow!, inComponent: 0, animated: false)
        
        let distanceRow = distanceOptions.indexOf(String(td))
        distancePickerView.selectRow(distanceRow!, inComponent: 0, animated: false)
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return stepsOptions.count
        } else {
            return distanceOptions.count
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return stepsOptions[row]
        } else {
            return distanceOptions[row]
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            stepsPicker.text = stepsOptions[row]
        } else {
            distancePicker.text = distanceOptions[row]
        }
    }
    
}
