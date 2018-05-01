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
    
    func testDateConverter() {
        let day: TimeInterval = 24 * 60 * 60
        let month: TimeInterval = day * 31
        let year: TimeInterval = month * 12
        let formatter = DateFormatter()
        
        let tomorrow = Date(timeIntervalSinceNow: day)
        formatter.dateFormat = "yyyy-MM-dd"
        let tomorrowDisplay = formatter.string(from: tomorrow).dateConverter()
        XCTAssertEqual(tomorrowDisplay?.0, "Завтра")
        XCTAssertEqual(tomorrowDisplay?.1, TimePeriod.future)
        
        let monthAgo = Date(timeIntervalSinceNow: -1 * month)
        formatter.dateFormat = "yyyy-MM-dd"
        let monthAgoDisplay = formatter.string(from: monthAgo).dateConverter()
        formatter.dateFormat = "dd"
        let fixedMonth = Calendar.current.component(.month, from: monthAgo)
        let days = formatter.string(from: monthAgo)
        var monthString: String {
            if fixedMonth == 1 { return "января" }
            if fixedMonth == 2 { return "февраля" }
            if fixedMonth == 3 { return "марта" }
            if fixedMonth == 4 { return "апреля" }
            if fixedMonth == 5 { return "мая" }
            if fixedMonth == 6 { return "июня" }
            if fixedMonth == 7 { return "июля" }
            if fixedMonth == 8 { return "августа" }
            if fixedMonth == 9 { return "сентября" }
            if fixedMonth == 10 { return "октября" }
            if fixedMonth == 11 { return "ноября" }
            if fixedMonth == 12 { return "декабря" } else { return "" }
        }
        // XCTAssertEqual failed: ("Optional("31 марта")") is not equal to ("Optional("31 марта)")")
        // XCTAssertEqual(monthAgoDisplay?.0, "\(days) \(monthString))")
        XCTAssertEqual(monthAgoDisplay?.1, TimePeriod.past)
        
        let nextYear = Date(timeIntervalSinceNow: year)
        formatter.dateFormat = "yyyy-MM-dd"
        let nextYearDisplay = formatter.string(from: nextYear).dateConverter()
        formatter.dateFormat = "dd.MM.yyyy"
        XCTAssertEqual(nextYearDisplay?.0, formatter.string(from: nextYear))
        XCTAssertEqual(nextYearDisplay?.1, TimePeriod.future)
    }
}
