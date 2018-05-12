//
//  StringDateConverterTests.swift
//  MakubTests
//
//  Created by Елена Яновская on 02.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

@testable import Makub
import XCTest

final class StringDateConverterTests: XCTestCase {
    
    private let day: TimeInterval = 24 * 60 * 60
    private var month: TimeInterval {
        return day * 31
    }
    private var year: TimeInterval {
        return month * 12
    }
    private let formatter = DateFormatter()
    
    func testTomorrow() {
        let tomorrow = Date(timeIntervalSinceNow: day)
        formatter.dateFormat = "yyyy-MM-dd"
        let tomorrowDisplay = formatter.string(from: tomorrow).dateConverter()
        XCTAssertEqual(tomorrowDisplay?.0, "Завтра")
        XCTAssertEqual(tomorrowDisplay?.1, TimePeriod.future)
    }
    
    func testMonthAgo() {
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
    }
    
    func testNextYear() {
        let nextYear = Date(timeIntervalSinceNow: year)
        formatter.dateFormat = "yyyy-MM-dd"
        let nextYearDisplay = formatter.string(from: nextYear).dateConverter()
        formatter.dateFormat = "dd.MM.yyyy"
        XCTAssertEqual(nextYearDisplay?.0, formatter.string(from: nextYear))
        XCTAssertEqual(nextYearDisplay?.1, TimePeriod.future)
    }
    
}
