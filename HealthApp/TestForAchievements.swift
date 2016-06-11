//
//  TestForAchievements.swift
//  HealthApp
//
//  Created by Milton Leung on 2016-05-01.
//  Copyright © 2016 Milton Leung. All rights reserved.
//

import XCTest
@testable import HealthApp

class TestForAchievements: XCTestCase {

    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        doneAchievements = []
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateString() {
        XCTAssertEqual(DateHelper.getDayNameBy("2016-05-03"), "Tue")
        XCTAssertEqual(DateHelper.getDayNameBy("2016-05-04"), "Wed")
        XCTAssertEqual(DateHelper.getDayNameBy("2016-05-05"), "Thu")
        XCTAssertEqual(DateHelper.getDayNameBy("2016-05-06"), "Fri")
    }
    
    func testDateMDY() {
        XCTAssertEqual(DateHelper.getDayNameByString("2016-05-03"), "May 3, 2016")
        XCTAssertEqual(DateHelper.getDayNameByString("2016-04-30"), "Apr 30, 2016")
        XCTAssertEqual(DateHelper.getDayNameByString("2016-12-01"), "Dec 1, 2016")
    }
    
    func testHardestHole() {
        XCTAssertEqual(DateHelper.hardestHole(0.9), "The first km's the hardest.")
        XCTAssertEqual(DateHelper.hardestHole(1.9), "The second km's the hardest.")
        XCTAssertEqual(DateHelper.hardestHole(2.9), "The third km's the hardest.")
        XCTAssertEqual(DateHelper.hardestHole(3.9), "The 4th km's the hardest.")
        XCTAssertEqual(DateHelper.hardestHole(11), "The 11th km's the hardest.")
    }
    func testDateNumber() {
        XCTAssertEqual(DateHelper.getDayNumberBy("2016-05-03"), 3)
        XCTAssertEqual(DateHelper.daysDifference("2015-05-01", endDate: NSDate()), 372)
    }
}
