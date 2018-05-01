//
//  MakubTests.swift
//  MakubTests
//
//  Created by Елена Яновская on 01.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import XCTest
@testable import Макуб

final class MakubTests: XCTestCase {
    
    func testTimeConverter() {
        let minute: TimeInterval = 60
        let hour: TimeInterval = 60 * minute
        let day: TimeInterval = 24 * hour
        
        let fiveMinAgo = Date(timeIntervalSinceNow: -5 * minute)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fiveMinAgoDisplay = formatter.string(from: fiveMinAgo).timeConverter()
        XCTAssertEqual(fiveMinAgoDisplay, "5 минут назад")
        
        let treeHoursAgo = Date(timeIntervalSinceNow: -3 * hour)
        let treeHoursAgoDisplay = formatter.string(from: treeHoursAgo).timeConverter()
        XCTAssertEqual(treeHoursAgoDisplay, "3 часа назад")
        
        let fourHoursAgo = Date(timeIntervalSinceNow: -4 * hour)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fourHoursAgoDisplay = formatter.string(from: fourHoursAgo).timeConverter()
        formatter.dateFormat = "HH:mm"
        XCTAssertEqual(fourHoursAgoDisplay, "Сегодня в \(formatter.string(from: fourHoursAgo))")
        
        let dayAgo = Date(timeIntervalSinceNow: -1 * day)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dayAgoDisplay = formatter.string(from: dayAgo).timeConverter()
        formatter.dateFormat = "HH:mm"
        XCTAssertEqual(dayAgoDisplay, "Вчера в \(formatter.string(from: dayAgo))")
        
        let twoDaysAgo = Date(timeIntervalSinceNow: -2 * day)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let twoDaysAgoDisplay = formatter.string(from: twoDaysAgo).timeConverter()
        formatter.dateFormat = "dd.MM.yyyy"
        XCTAssertEqual(twoDaysAgoDisplay, (formatter.string(from: twoDaysAgo)))
    }
}
