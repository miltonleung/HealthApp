//
//  GraphViewController.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-03.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import UIKit
import Charts
import HealthKit

class GraphViewController: UIViewController {
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var dailyAverage: UILabel!
    
    @IBOutlet weak var monthlyLabel: UIButton!
    @IBOutlet weak var weeklyLabel: UIButton!
    @IBAction func monthly(sender: UIButton) {
//        sender.state = UIControlState.Selected
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
    var healthManager: HealthManager?
    var weeklyOrMonthly = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyOrMonthly = 1
        weeklyLabel.selected = true
        healthManager = HealthManager()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        days = [String]()
        
        self.view.backgroundColor = UIColor.clearColor()
        barChartView.backgroundColor = UIColor.clearColor()
        if weeklyOrMonthly == 0 {
            weeklyOrMonthly = 1
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
                self.barChartView.animate(yAxisDuration: 1.5)
                var average = 0.0
                for distance in distances {
                    average += distance
                }
                let avg = average/365
                self.dailyAverage.text = "daily average: \(String(format: "%.2f", avg)) km"
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
                self.barChartView.animate(yAxisDuration: 1.5)
                var average = 0.0
                for distance in distances {
                    average += distance
                }
                let avg = average/Double(distances.count)
                self.dailyAverage.text = "daily average: \(String(format: "%.2f", avg)) km"
                
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
        
        
        if isWeekly == 1 {
            barChartView.rightAxis.removeAllLimitLines()
            let ll = ChartLimitLine(limit: 8.0, label: "")
            ll.lineWidth = 1.5
            barChartView.rightAxis.addLimitLine(ll)
            
        } else {
            barChartView.rightAxis.removeAllLimitLines()
            let ll = ChartLimitLine(limit: 248.0, label: "")
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