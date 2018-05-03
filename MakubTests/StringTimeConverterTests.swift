//
//  StringTimeConverterTests.swift
//  StringTimeConverterTests
//
//  Created by Елена Яновская on 01.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

@testable import Makub
import XCTest

final class StringTimeConverterTests: XCTestCase {
    
    private let minute: TimeInterval = 60
    private var hour: TimeInterval {
        return 60 * minute
    }
    private var day: TimeInterval {
        return 24 * hour
    }
    private let formatter = DateFormatter()
    
    func testFiveMinAgo() {
        let fiveMinAgo = Date(timeIntervalSinceNow: -5 * minute)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fiveMinAgoDisplay = formatter.string(from: fiveMinAgo).timeConverter()
        XCTAssertEqual(fiveMinAgoDisplay, "5 минут назад")
    }
    
    func testTreeHoursAgo() {
        let treeHoursAgo = Date(timeIntervalSinceNow: -3 * hour)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let treeHoursAgoDisplay = formatter.string(from: treeHoursAgo).timeConverter()
        XCTAssertEqual(treeHoursAgoDisplay, "3 часа назад")
    }
    
    func testFourHoursAgo() {
        let fourHoursAgo = Date(timeIntervalSinceNow: -4 * hour)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fourHoursAgoDisplay = formatter.string(from: fourHoursAgo).timeConverter()
        formatter.dateFormat = "HH:mm"
        XCTAssertNotEqual(fourHoursAgoDisplay, "4 часа назад")
    }
    
    func testDayAgo() {
        let dayAgo = Date(timeIntervalSinceNow: -1 * day)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dayAgoDisplay = formatter.string(from: dayAgo).timeConverter()
        formatter.dateFormat = "HH:mm"
        XCTAssertEqual(dayAgoDisplay, "Вчера в \(formatter.string(from: dayAgo))")
    }
    
    func testTwoDaysAgo() {
        let twoDaysAgo = Date(timeIntervalSinceNow: -2 * day)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let twoDaysAgoDisplay = formatter.string(from: twoDaysAgo).timeConverter()
        formatter.dateFormat = "dd.MM.yyyy"
        XCTAssertEqual(twoDaysAgoDisplay, (formatter.string(from: twoDaysAgo)))
    }
    
}
