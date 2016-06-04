
//  ViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-04-29.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion

class ViewController: UIViewController {
    
//    @IBOutlet weak var banner: UILabel!
//    
    var healthManager:HealthManager?
//    let pedometer = CMPedometer()
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var weeklyLabel: UIButton!
    @IBOutlet weak var monthlyLabel: UIButton!
    
    @IBOutlet weak var dailyAverage: UILabel!
    @IBOutlet weak var dailyTarget: UILabel!
    @IBAction func monthly(sender: UIButton) {
        weeklyLabel.selected = false
        sender.selected = true
        days = [String]()
        weeklyOrMonthly = 0
        readMonthlyData()
    }
    @IBAction func weekly(sender: UIButton) {
        monthlyLabel.selected = false
        sender.selected = true
        days = [String]()
        weeklyOrMonthly = 1
        readData()
    }
    var days = [String]()
    var weeklyOrMonthly = 1
    let data = Data()
    
    // Passed to ProgressViewController
    var scenario: Int! // 0 flying, 1 Pass, 2 Inconsistency, 3 Lower
    var average: Double!
    var targetDistance: Int!
    var count: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthManager = HealthManager()

    weeklyLabel.selected = true
    healthManager = HealthManager()
    self.dailyAverage.text = "daily average: 0 km"

//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "performLifetimeSegue", name: "lifetimeNotification", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unwrapNotification:", name: "dailyNotification", object: nil)
        
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            reset()
        }
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkInUnwrap:", name: "checkInStatus", object: nil)
    }
    
    func reset() {
        print("Resetting")
        NSUserDefaults.standardUserDefaults().setInteger(6, forKey: "targetDistance")
        NSUserDefaults.standardUserDefaults().setInteger(8000, forKey: "targetSteps")
        
        let array = [1]
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "doneDaily")
        
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "doneLifetimeDistance")
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "doneLifetimeSteps")
        
        NSUserDefaults.standardUserDefaults().setInteger(1000000, forKey: "millionTargetCounter")
        NSUserDefaults.standardUserDefaults().setInteger(1000, forKey: "thousandTargetCounter")
        
        let today = ModelInterface.sharedInstance.convertDate(NSDate())
        let temp:[Int: String] = [1: today]
        var data = NSKeyedArchiver.archivedDataWithRootObject(temp)
        NSUserDefaults.standardUserDefaults().setObject(today, forKey: "firstDate")
        NSUserDefaults.standardUserDefaults().setObject(today, forKey: "firstLogin")
        
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "doneLifetimeDistanceDates")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "doneLifetimeStepsDates")
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "progressReportedToday")
        
        NSUserDefaults.standardUserDefaults().setObject(today, forKey: "checkIn")
    }
//    func checkInUnwrap(notification: NSNotification) {
//        let firstLogin = NSUserDefaults.standardUserDefaults().stringForKey("firstLogin")
//        let checkedInToday = NSUserDefaults.standardUserDefaults().boolForKey("progressReportedToday")
//        if let checkIn = NSUserDefaults.standardUserDefaults().stringForKey("checkIn") {
//            let daysSince = ModelInterface.sharedInstance.daysDifference(checkIn, endDate: NSDate())
//            if daysSince >= 3 || (checkIn == firstLogin && checkedInToday == false) {
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "progressReportedToday")
//                if let weeklyDictionary = notification.userInfo as? Dictionary<Int, [Double]> {
//                    if let weeklyDistances = weeklyDictionary[1] {
//                        var counter = 0
//                        targetDistance = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
//                        let target = Double(targetDistance)
//                        for d in weeklyDistances {
//                            if d >= target {
//                                counter += 1
//                            }
//                        }
//                        count = counter
//                        var sum = 0.0
//                        for d in weeklyDistances {
//                            sum += d
//                        }
//                        average = sum/Double(weeklyDistances.count)
//                        
//                        if counter == 7 {
//                            scenario = 0
//                        }
//                        else if counter >= 4 && abs(average - target) <= 1.4 {
//                            scenario = 1
//                        }
//                        else if counter <= 4 && weeklyDistances.maxElement()! - weeklyDistances.minElement()! >= 4 && weeklyDistances.maxElement() >= target {
//                            scenario = 2
//                        }
//                        else {
//                            scenario = 3
//                        }
//                        self.performSegueWithIdentifier("progress", sender: nil)
//                    }
//                }
//                queueNotification()
//                let today = ModelInterface.sharedInstance.convertDate(NSDate())
//                NSUserDefaults.standardUserDefaults().setObject(today, forKey: "checkIn")
//            }
//        }
//    }
    func queueNotification() {
        if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
            
            if settings.types.contains(.Alert) {
                let notification = UILocalNotification()
                
                let fireDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 3, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
                
                notification.fireDate = fireDate
                notification.alertBody = "Your progress report is ready for review!"
                notification.alertAction = "view"
                notification.soundName = UILocalNotificationDefaultSoundName
//                notification.userInfo = ["progress": 1]
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "progress") {
            let progress = segue.destinationViewController as! ProgressViewController
            progress.scenario = scenario
            progress.average = average
            progress.targetDistance = targetDistance
            progress.count = count
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        print("viewdidappera")
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            self.performSegueWithIdentifier("introSegue", sender: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstRun")
        }
    }
//    func unwrapNotification(notification: NSNotification) {
//        if let dailyDistanceDictionary = notification.userInfo as? Dictionary<Int, NSNumber> {
//            if let dailyDistance = dailyDistanceDictionary[1] {
//                updateBanner(dailyDistance)
//            }
//        }
//        else {
//            print("error in userinfo type")
//        }
//    }
    
    func performLifetimeSegue() {
        self.performSegueWithIdentifier("lifetimeSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func updateBanner(distance: NSNumber) {
//        self.banner.text = ModelInterface.sharedInstance.hardestHole(distance.doubleValue/1000)
//        
//        
//        let a = distance.integerValue/1000
//        let achievement = ModelInterface.sharedInstance.reachedAchievement(a)
//        let achievementString = achievement.1
//        let achievementNumber  = achievement.0
//        
//        if achievementString != "" && distance.doubleValue/1000 - Double(achievementNumber) <= 1.5 {
//            self.banner.text = achievementString
//        }
//    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        let td = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
        dailyTarget.text = "daily goal: \(td) km"
        
        days = [String]()
        
        barChartView.backgroundColor = UIColor.clearColor()
        if weeklyOrMonthly == 0 {
            
            readMonthlyData()
        } else {
            readData()
        }
        
    }
    
    func readMonthlyData() {
        let distanceType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        self.healthManager?.readYearSample(distanceType!, completion: { (dates, distances, error) -> Void in
            if (error != nil) {
                print("Error reading past week steps from Healthkit")
                return
            }
            
            self.days = [String]()
            for date in dates {
                let day = ModelInterface.sharedInstance.getMonthNameBy(date)
                self.days.append(day)
            }
            
            self.setChart(self.days, values: distances, isWeekly: 0)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void  in
                self.barChartView.animate(yAxisDuration: 1.0)
                if !distances.isEmpty {
                    var average = 0.0
                    for distance in distances {
                        average += distance
                    }
                    let startDate = dates.first
                    let averageDenom = ModelInterface.sharedInstance.daysDifference(startDate!, endDate: NSDate())
                    let avg = average/Double(averageDenom)
                    self.dailyAverage.text = "daily average: \(String(format: "%.2f", avg)) km"
                }
            });
        });
    }
    
    func readData() {
        let distanceType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        self.healthManager?.readRecentSample(distanceType!, completion: { (dates, distances, error) -> Void in
            if (error != nil) {
                print("Error reading past week steps from Healthkit")
                return
            }
            
            self.data.weeklyDistances = distances
            
            self.days = [String]()
            for date in dates {
                let day = ModelInterface.sharedInstance.getDayNameBy(date)
                self.days.append(day)
            }
            
            if !self.days.isEmpty {
                self.days[self.days.count - 1] = "Today"
            }
            self.setChart(self.days, values: distances, isWeekly: 1)
            dispatch_async(dispatch_get_main_queue(), { () -> Void  in
                self.barChartView.animate(yAxisDuration: 1.0)
                if !distances.isEmpty {
                    var average = 0.0
                    for distance in distances {
                        average += distance
                    }
                    let avg = average/Double(distances.count)
                    self.dailyAverage.text = "daily average: \(String(format: "%.2f", avg)) km"
                }
                
            });
        });
    }
    
    func setChart(dataPoints: [String], values: [Double], isWeekly: Int) {
        
        if dataPoints.isEmpty || values.isEmpty {
            return
        }
        
        barChartView.noDataText = "You need to provide data for the chart"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Distance")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.legend.enabled = false
        barChartView.data = chartData
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.enabled = false
        if isWeekly == 1 {
            barChartView.xAxis.setLabelsToSkip(0)
        } else {
            barChartView.xAxis.setLabelsToSkip(1)
        }
        barChartView.xAxis.labelTextColor = UIColor.whiteColor()
        barChartView.xAxis.labelFont = UIFont(name: "Muli", size: 12)!
        barChartView.leftAxis.labelTextColor = UIColor.whiteColor()
        barChartView.leftAxis.labelFont = UIFont(name: "Muli", size: 13)!
        
        barChartView.dragEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        
        chartData.setValueTextColor(UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.95))
        chartData.highlightEnabled = false
        chartData.setValueFont(UIFont(name: "Muli", size: 12))
        
        let td = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
        
        if isWeekly == 1 {
            barChartView.rightAxis.removeAllLimitLines()
            let ll = ChartLimitLine(limit: Double(td), label: "")
            ll.lineWidth = 1.5
            barChartView.rightAxis.addLimitLine(ll)
            
        } else {
            barChartView.rightAxis.removeAllLimitLines()
            let ll = ChartLimitLine(limit: Double(td) * 31.0, label: "")
            ll.lineWidth = 1.5
            barChartView.rightAxis.addLimitLine(ll)
        }
        
        let entry = ChartDataEntry(value: values.last!, xIndex: values.count - 1)
        chartDataSet.addEntry(entry)
        
        
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0)
        barChartView.descriptionText = ""
        //        barChartView.animate(yAxisDuration: 2.0)
        barChartView.gridBackgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0)
        
        barChartView.drawGridBackgroundEnabled = true
        
        chartDataSet.colors = [UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.88)]
        
    }

}

