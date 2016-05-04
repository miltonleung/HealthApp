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
    
    var days = [String]()
    var healthManager: HealthManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        healthManager = HealthManager()
        
        self.view.backgroundColor = UIColor.clearColor()
        barChartView.backgroundColor = UIColor.clearColor()
        readData()
        
        
        
    }
    
    func readData() {
        let distanceType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        
        self.healthManager?.readRecentSample(distanceType!, completion: { (dates, distances, error) -> Void in
            if (error != nil) {
                print("Error reading past week steps from Healthkit")
                return
            }
            
//            for date in dates {
//                let day = ModelInterface.sharedInstance.getDayNameBy(date)
//                self.days.append(day)
//            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void  in
                for date in dates {
                    let day = ModelInterface.sharedInstance.getDayNameBy(date)
                    self.days.append(day)
                }
                self.setChart(self.days, values: distances)
            });
        });
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.noDataText = "You need to provide data for the chart"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.labelPosition = .Bottom
        
        let ll = ChartLimitLine(limit: 8.0, label: "Daily goal")
        barChartView.rightAxis.addLimitLine(ll)
        
        let entry = ChartDataEntry(value: values.last!, xIndex: values.count - 1)
        chartDataSet.addEntry(entry)
//        chartDataSet.removeLast()
        
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0)
        barChartView.descriptionText = ""
        barChartView.animate(yAxisDuration: 2.0)
        barChartView.gridBackgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0)
        
        barChartView.drawGridBackgroundEnabled = true
        
        chartDataSet.colors = [UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 0.88)]
        
    }
}