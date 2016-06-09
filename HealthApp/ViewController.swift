//  ViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-04-29.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion
import Firebase
import FirebaseAuth

protocol MenuSelectDelegate {
    func segue(segueIdentifier: String)
}
protocol RefreshDelegate {
    func refresh(td: Int, ts: Int)
    func reload()
    func resetMenuImage()
}
class ViewController: UIViewController {
    
    //    @IBOutlet weak var banner: UILabel!
    //
    var healthManager:HealthManager?
    let pedometer = CMPedometer()
    
    var ref = FIRDatabaseReference.init()
    
    let interactor = Interactor()
    @IBAction func menuButton(sender: UIButton) {
        performSegueWithIdentifier("openMenu", sender: nil)
    }
    @IBOutlet weak var menu: UIButton!
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegueWithIdentifier("openMenu", sender: nil)
        }
    }
    
    //FIREBASE
    var userID:String?
    
    // GRAPH
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
    var weeklyOrMonthly:Int?
    let data = Data()
    var collectedPastWeekVal = [Double]()
    var collectedPastWeekDates = [String]()
    
    
    // PROGRESS
    @IBOutlet weak var outterCircle: KDCircularProgress!
    @IBOutlet weak var innerCircle: KDCircularProgress!
    @IBOutlet weak var circlePercentage: UILabel!
    @IBOutlet weak var denominator: UILabel!
    
    // STEPS & DISTANCE
    @IBOutlet weak var stepsLabel: UIButton!
    @IBOutlet weak var distanceLabel: UIButton!
    var totalSteps:Int?
    var totalDistance:Int?
    var currentSteps:Int?
    var currentDistance:Double?
    @IBAction func distanceButton(sender: UIButton) {
        if sender.selected == true {
            sender.selected = false
            stepsLabel.selected = false
            outterCircle.alpha = 1
            innerCircle.alpha = 1
            updateCirclePercentage()
            denominator.text = "of target reached"
            updateStepsProgressfromStart()
            updateDistanceProgressfromStart()
        } else {
            stepsLabel.selected = false
            sender.selected = true
            outterCircle.alpha = 0.2
            innerCircle.alpha = 1
            if currentDistance!/Double(totalDistance!) * 100 < 10 {
                circlePercentage.text = String(format: "%.1f", currentDistance!/Double(totalDistance!) * 100)
            } else {
                circlePercentage.text = String(Int(currentDistance!/Double(totalDistance!) * 100))
            }
            denominator.text = "of distance reached"
            updateDistanceProgressfromStart()
        }
    }
    @IBAction func stepsButton(sender: UIButton) {
        if sender.selected == true {
            sender.selected = false
            stepsLabel.selected = false
            outterCircle.alpha = 1
            innerCircle.alpha = 1
            updateCirclePercentage()
            denominator.text = "of target reached"
            updateStepsProgressfromStart()
            updateDistanceProgressfromStart()
        } else {
            distanceLabel.selected = false
            sender.selected = true
            innerCircle.alpha = 0.1
            outterCircle.alpha = 1
            if Double(currentSteps!)/Double(totalSteps!) * 100.0 < 10 {
                circlePercentage.text = String(format: "%.1f", Int(Double(currentSteps!)/Double(totalSteps!) * 100.0))
            } else {
                circlePercentage.text = String(Int(Double(currentSteps!)/Double(totalSteps!) * 100.0))
            }
            denominator.text = "of steps taken"
            updateStepsProgressfromStart()
        }
    }
    
    // Passed to ProgressViewController
    var scenario: Int! // 0 flying, 1 Pass, 2 Inconsistency, 3 Lower
    var average: Double!
    var targetDistance: Int!
    var count: Int!
    
    // Passed to LifetimeStatistics
    var lifetimeFirstDate:String!
    var lifetimeTotalSteps:Int!
    var lifetimeTotalDistance:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthManager = HealthManager()
        
        
        let firstRun = NSUserDefaults.standardUserDefaults().boolForKey("firstRun") as Bool
        if !firstRun {
            reset()
        }
        else {
            let viewedAchievements = NSUserDefaults.standardUserDefaults().boolForKey("viewedAchievements")
            let viewedProgress = NSUserDefaults.standardUserDefaults().boolForKey("viewedProgress")
            if viewedAchievements == false || viewedProgress == false {
                menu.setBackgroundImage(UIImage(named: "MenuAlert"), forState: UIControlState.Normal)
            } else {
                menu.setBackgroundImage(UIImage(named: "Menu"), forState: UIControlState.Normal)
            }
            weeklyOrMonthly = 1
        }
        userID = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        if (userID == nil) {
            FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user,error) in
                if let user = user {
                    self.userID = user.uid
                }
            }
        }
        
        ref = FIRDatabase.database().reference()
        
        

        
        // PROGRESS
        outterCircle.angle = 0
        innerCircle.angle = 0
        denominator.text = "of target reached"
        circlePercentage.text = "0.0"
        
        // STEPS & DISTANCE
        //        updatePedometer()
        totalSteps = NSUserDefaults.standardUserDefaults().integerForKey("targetSteps")
        totalDistance = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
        
        // GRAPH
        weeklyLabel.selected = true
        self.dailyAverage.text = "daily average: 0 km"
        
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "performLifetimeSegue", name: "lifetimeNotification", object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unwrapNotification:", name: "dailyNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "viewWillAppear:", name: "enterForeground", object: nil)
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkInUnwrap:", name: "checkInStatus", object: nil)
    }
    
    func reset() {
        print("Resetting")
        NSUserDefaults.standardUserDefaults().setInteger(6, forKey: "targetDistance")
        NSUserDefaults.standardUserDefaults().setInteger(6000, forKey: "targetSteps")
        
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
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "viewedAchievements")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "viewedProgress")
    }
    func checkInUnwrap(notification: NSNotification) {
        let firstLogin = NSUserDefaults.standardUserDefaults().stringForKey("firstLogin")
        let checkedInToday = NSUserDefaults.standardUserDefaults().boolForKey("progressReportedToday")
        if let checkIn = NSUserDefaults.standardUserDefaults().stringForKey("checkIn") {
            let daysSince = ModelInterface.sharedInstance.daysDifference(checkIn, endDate: NSDate())
            if daysSince >= 3 || (checkIn == firstLogin && checkedInToday == false) {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "progressReportedToday")
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "viewedProgress")
                menu.setBackgroundImage(UIImage(named: "MenuAlert"), forState: UIControlState.Normal)
                progressAlert = true
                if let weeklyDictionary = notification.userInfo as? Dictionary<Int, [Double]> {
                    performProgress(weeklyDictionary)
                }
                
                queueNotification()
                let today = ModelInterface.sharedInstance.convertDate(NSDate())
                NSUserDefaults.standardUserDefaults().setObject(today, forKey: "checkIn")
            }
        }
    }
    
    func performProgress(weeklyDictionary: Dictionary<Int, [Double]>) {
        if let weeklyDistances = weeklyDictionary[1] {
            var counter = 0
            targetDistance = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
            let target = Double(targetDistance)
            for d in weeklyDistances {
                if d >= target {
                    counter += 1
                }
            }
            count = counter
            var sum = 0.0
            for d in weeklyDistances {
                sum += d
            }
            average = sum/Double(weeklyDistances.count)
            callFirebase(average, counter: counter, target: targetDistance)
            
            if counter == 7 {
                scenario = 0
            }
            else if counter >= 4 && abs(average - target) <= 1.4 {
                scenario = 1
            }
            else if counter <= 4 && weeklyDistances.maxElement()! - weeklyDistances.minElement()! >= 4 && weeklyDistances.maxElement() >= target {
                scenario = 2
            }
            else {
                scenario = 3
            }
            self.performSegueWithIdentifier("progress", sender: nil)
        }
        
    }
    func callFirebase(average: Double, counter: Int, target: Int) {
        let key = ref.child("progress").childByAutoId().key
        let progress = ["average": average,
                        "counter": counter,
                        "target": target]
        let updates = ["/users/\(userID)/\(key)/": progress]
        ref.updateChildValues(updates)
    }
    
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
            progress.delegate = self
        }
        else if segue.identifier == "settings" {
            let settings = segue.destinationViewController as! SettingsViewController
            settings.delegate = self
        }
        else if segue.identifier == "introSegue" {
            let intro = segue.destinationViewController as! IntroViewController
            intro.delegate = self
        }
        else if segue.identifier == "statistics" {
            let statistics = segue.destinationViewController as! CumulativeStatsViewController
            statistics.firstDate = lifetimeFirstDate
            statistics.totalDistance = lifetimeTotalDistance
            statistics.totalSteps = lifetimeTotalSteps
        }
        else if segue.identifier == "medals" {
            let showcase = segue.destinationViewController as! ShowcaseViewController
            showcase.delegate = self
        }
        else if let destinationViewController = segue.destinationViewController as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.menuSelectDelegate = self
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
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
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "viewedAchievements")
        menu.setBackgroundImage(UIImage(named: "MenuAlert"), forState: UIControlState.Normal)
        medalAlert = true
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
    
    func updatePedometer() {
        
        if (CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable()) {
            let beginningOfDay = NSCalendar.currentCalendar().dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: [])
            self.pedometer.queryPedometerDataFromDate(beginningOfDay!, toDate: NSDate()) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if error == nil {
                        if let numberOfSteps = data?.numberOfSteps {
                            let result = ModelInterface.sharedInstance.addThousandSeperator(numberOfSteps.integerValue)
                            self.stepsLabel.setTitle("\(result) steps", forState: UIControlState.Normal)
                            self.updateStepsProgress(numberOfSteps.integerValue)
                            self.currentSteps = numberOfSteps.integerValue
                            self.updateCirclePercentage()
                            print(data?.numberOfSteps)
                        }
                        if let distance = data?.distance {
                            //                            self.dataModel.dailyDistance = distance
                            let distanceText = String(format: "%.2f", distance.doubleValue/1000)
                            self.distanceLabel.setTitle("\(distanceText) km", forState: UIControlState.Normal)
                            self.updateDistanceProgress(distance.doubleValue/1000.0)
                            self.currentDistance = distance.doubleValue/1000
                            self.updateCirclePercentage()
                            print(data?.distance)
                        }
                    }
                });
            }
            self.pedometer.startPedometerUpdatesFromDate(beginningOfDay!) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let numberOfSteps = data?.numberOfSteps {
                        let result = ModelInterface.sharedInstance.addThousandSeperator(numberOfSteps.integerValue)
                        self.stepsLabel.setTitle("\(result) steps", forState: UIControlState.Normal)
                        self.updateStepsProgress(numberOfSteps.integerValue)
                        self.currentSteps = numberOfSteps.integerValue
                        self.updateCirclePercentage()
                        print(data?.numberOfSteps)
                    }
                    if let distance = data?.distance {
                        //                        self.dataModel.dailyDistance = distance
                        let distanceText = String(format: "%.2f", distance.doubleValue/1000)
                        self.distanceLabel.setTitle("\(distanceText) km", forState: UIControlState.Normal)
                        self.updateDistanceProgress(distance.doubleValue/1000.0)
                        self.currentDistance = distance.doubleValue/1000
                        self.updateCirclePercentage()
                        print(data?.distance)
                    }
                });
            }
        }
    }
    
    func updateCirclePercentage() {
        if (currentDistance != nil && currentSteps != nil) {
            let percentage = 0.5 * (currentDistance!/Double(totalDistance!)) + 0.5 * Double(currentSteps!)/Double(totalSteps!)
            if percentage * 100 == 0 {
                circlePercentage.text = "0.0"
            }
            else if percentage * 100 < 10 {
                circlePercentage.text = String(format: "%.1f", percentage * 100)
            } else {
                circlePercentage.text = String(Int(percentage * 100))
            }
        }
    }
    
    func updateStepsProgress(steps: Int) {
        let angle = 360 * steps/totalSteps!
        
        if angle > 360 {
            outterCircle.animateToAngle(360.0, duration: 1, relativeDuration: true, completion: nil)
        }
        else {
            outterCircle.animateToAngle(Double(angle), duration: 1, relativeDuration: true, completion: nil)
        }
    }
    func updateDistanceProgress(distance: Double) {
        let angle = 360.0 * distance/Double(totalDistance!)
        
        if angle > 360 {
            innerCircle.animateToAngle(360.0, duration: 1, relativeDuration: true, completion: nil)
        }
        else {
            innerCircle.animateToAngle(angle, duration: 1, relativeDuration: true, completion: nil)
        }
    }
    
    func updateStepsProgressfromStart() {
        let angle = 360 * currentSteps!/totalSteps!
        
        if angle > 360 {
            outterCircle.animateFromAngle(0.0, toAngle: 360.0, duration: 1, completion: nil)
        }
        else {
            outterCircle.animateFromAngle(0.0, toAngle: Double(angle), duration: 1, completion: nil)
        }
    }
    func updateDistanceProgressfromStart() {
        
        let angle = 360.0 * currentDistance!/Double(totalDistance!)
        
        if angle > 360 {
            innerCircle.animateFromAngle(0.0, toAngle: 360.0, duration: 1, completion: nil)
        }
        else {
            innerCircle.animateFromAngle(0.0, toAngle: angle, duration: 1, completion: nil)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        let td = NSUserDefaults.standardUserDefaults().integerForKey("targetDistance")
        dailyTarget.text = "daily goal: \(td) km"
        
        days = [String]()
        
        
        updatePedometer()
        
        // LIFETIME STATISTICS
        updateFirstDate()
        updateTotalSteps()
        updateTotalDistance()
        
        weeklyOrMonthly = 1
        weeklyLabel.selected = true
        monthlyLabel.selected = false
        
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
            
            if self.collectedPastWeekDates.isEmpty {
                self.collectedPastWeekDates = dates
                self.collectedPastWeekVal = distances
            } else {
                self.collectedPastWeekDates += dates
                self.collectedPastWeekVal += distances
            }
            while self.collectedPastWeekDates.count > 8 {
                self.collectedPastWeekDates.removeFirst()
                self.collectedPastWeekVal.removeFirst()
            }
            self.days = [String]()
            for date in dates {
                let day = ModelInterface.sharedInstance.getDayNameBy(date)
                self.days.append(day)
            }
            
            self.setChart(self.days, values: self.collectedPastWeekVal, isWeekly: 1)
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
        
        chartDataSet.colors = [UIColor(red: 228/255, green: 241/255, blue: 254/255, alpha: 0.88)]
        
    }
    
    func updateFirstDate() {
        if let firstDate = NSUserDefaults.standardUserDefaults().stringForKey("firstDate") {
            self.lifetimeFirstDate = ModelInterface.sharedInstance.getDayNameByString(firstDate)
        }
    }
    
    func updateTotalSteps() {
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        self.healthManager?.readTotalSample(stepsCount!, completion: { (totalSteps, error) -> Void in
            if (error != nil) {
                print("Error reading total steps from HealthKit")
                return;
            }
            
            self.lifetimeTotalSteps = Int(totalSteps.1.doubleValueForUnit(HKUnit.countUnit()))
            self.data.totalSteps = self.lifetimeTotalSteps
            
        });
    }
    func updateTotalDistance() {
        let distanceType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        self.healthManager?.readTotalSample(distanceType!, completion: { (totalDistance, error) -> Void in
            if (error != nil) {
                print("Error reading total distance from HealthKit")
                return
            }
            
            let totalResult = Int(totalDistance.1.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo)))
            self.data.totalDistance = totalResult
            self.lifetimeTotalDistance = totalDistance.1.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(.Kilo))
            
        });
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
extension ViewController: MenuSelectDelegate {
    func segue(segueIdentifier: String) {
        if segueIdentifier == "progress" {
            dismissViewControllerAnimated(true) {
                self.performProgress(lastweekDistance)
            }
        } else {
            dismissViewControllerAnimated(true) {
                self.performSegueWithIdentifier("\(segueIdentifier)", sender: nil)
            }
        }
    }
}
extension ViewController: RefreshDelegate {
    func refresh(td: Int, ts: Int) {
        totalDistance = td
        totalSteps = ts
        
        let distanceAngle = 360.0 * currentDistance!/Double(totalDistance!)
        
        if distanceAngle > 360 {
            innerCircle.animateToAngle(360.0, duration: 1, relativeDuration: true, completion: nil)
        }
        else {
            innerCircle.animateToAngle(distanceAngle, duration: 1, relativeDuration: true, completion: nil)
        }
        
        let stepsAngle = 360.0 * Double(currentSteps!)/Double(totalSteps!)
        
        if stepsAngle > 360 {
            outterCircle.animateToAngle(360.0, duration: 1, relativeDuration: true, completion: nil)
        }
        else {
            outterCircle.animateToAngle(Double(stepsAngle), duration: 1, relativeDuration: true, completion: nil)
        }
        
        updateCirclePercentage()
        
        dailyTarget.text = "daily goal: \(td) km"
    }
    func reload() {
        viewWillAppear(true)
    }
    func resetMenuImage() {
        let viewedAchievements = NSUserDefaults.standardUserDefaults().boolForKey("viewedAchievements")
        let viewedProgress = NSUserDefaults.standardUserDefaults().boolForKey("viewedProgress")
        if viewedAchievements == true && viewedProgress == true {
            menu.setBackgroundImage(UIImage(named: "Menu"), forState: UIControlState.Normal)
        }
    }
}
