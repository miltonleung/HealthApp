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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    func testReachedAchievement() {
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(0), "")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(1), "Baby Steps")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(2), "")
        XCTAssertEqual(ModelInterface.sharedInstance.reachedAchievement(3), "You have reached 3 km!")
    }

}
