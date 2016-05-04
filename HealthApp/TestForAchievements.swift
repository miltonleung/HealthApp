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
    func testReachedAchievement() {
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(0), "")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(1), "Baby Steps")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(2), "Baby Steps")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(3), "You have reached 3 km!")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(4), "You have reached 3 km!")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(5), "You have reached 5 km!")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(6), "You have reached 5 km!")
    }
    func testReachedAchievementFive() {
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(5), "You have reached 5 km!")
    }
    func testReachedAchievementFour() {
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(4), "You have reached 3 km!")
    }
    
    func testDateString() {
        XCTAssertEqual(ModelInterface.sharedInstance.getDayNameBy("2016-05-03"), "Tue")
        XCTAssertEqual(ModelInterface.sharedInstance.getDayNameBy("2016-05-04"), "Wed")
        XCTAssertEqual(ModelInterface.sharedInstance.getDayNameBy("2016-05-05"), "Thu")
        XCTAssertEqual(ModelInterface.sharedInstance.getDayNameBy("2016-05-06"), "Fri")
    }
}
